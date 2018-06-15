import UIKit
import AsyncDisplayKit
import PryntTrimmerView

class TrimViewController: UIViewController, TrimmerViewDelegate {
    var videoUrl: URL?
    let player = ASVideoNode()
    let trimmer = TrimmerView()
    var currentFile: URL?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.videoUrl = Bundle.main.url(forResource: "sample", withExtension: "mp4")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func destinationUrl() -> URL {
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString + ".mp4"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
        return fullURL
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = videoUrl {
            let asset = AVAsset(url: url)
            trimmer.asset = asset
            player.asset = asset
        }
    }

    func positionBarStoppedMoving(_ playerTime: CMTime) {
        print("stopped moving")
        print(playerTime)
        player.pause()
        if let url = self.videoUrl, let start = trimmer.startTime, let end = trimmer.endTime {
            let destinationUrl = self.destinationUrl()
            self.trimVideo(sourceURL: url,
                    destinationURL: destinationUrl,
                    startTime: start,
                    endTime: end, completion: { (error) in
                OperationQueue.main.addOperation {
                    if let error = error {
                        print(error)
                    } else {
                        let asset = AVAsset(url: destinationUrl)
                        self.player.resetToPlaceholder()
                        self.player.asset = asset
                        self.player.play()
                    }
                }
            })
        }
    }

    func didChangePositionBar(_ playerTime: CMTime) {
//        print("position changed")
    }

    func trimVideo(sourceURL: URL, destinationURL: URL, startTime: CMTime, endTime: CMTime,
                   completion: @escaping (Error?) -> Void) {
        assert(sourceURL.isFileURL)
        assert(destinationURL.isFileURL)

        let asset = AVURLAsset(url: sourceURL, options: [ AVURLAssetPreferPreciseDurationAndTimingKey: true ])
        let preferredPreset = AVAssetExportPresetPassthrough
        let composition = AVMutableComposition()

        let videoCompTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                preferredTrackID: CMPersistentTrackID())
        let audioCompTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio,
                preferredTrackID: CMPersistentTrackID())

        let assetVideoTrack: AVAssetTrack = asset.tracks(withMediaType: AVMediaType.video).first as! AVAssetTrack
        let assetAudioTrack: AVAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first as! AVAssetTrack

        var accumulatedTime = kCMTimeZero
        let durationOfCurrentSlice = CMTimeSubtract(endTime, startTime)
        let timeRangeForCurrentSlice = CMTimeRangeMake(startTime, durationOfCurrentSlice)

        try? videoCompTrack?.insertTimeRange(timeRangeForCurrentSlice,
                of: assetVideoTrack,
                at: accumulatedTime)
        try? audioCompTrack?.insertTimeRange(timeRangeForCurrentSlice,
                of: assetAudioTrack,
                at: accumulatedTime)

        accumulatedTime = CMTimeAdd(accumulatedTime, durationOfCurrentSlice)
        if let exportSession = AVAssetExportSession(asset: composition, presetName: preferredPreset) {
            exportSession.outputURL = destinationURL
            exportSession.outputFileType = AVFileType.m4v
            exportSession.shouldOptimizeForNetworkUse = true

            exportSession.exportAsynchronously(completionHandler: { () -> Void in
                print(exportSession.error)
                if exportSession.status == AVAssetExportSessionStatus.completed {
                    completion(nil)
                } else if exportSession.status == AVAssetExportSessionStatus.failed {
                    completion(exportSession.error)
                } else if exportSession.status == AVAssetExportSessionStatus.cancelled {
                    completion(exportSession.error)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
