import UIKit
import SVProgressHUD
import AsyncDisplayKit
import FDWaveformView

class MediaSyncViewController: UIViewController {
    
    //MARK: - Properties
    let titleTextField = UITextView()
    var titleTextHeight: CGFloat = 50
    var player = ASVideoNode()
    let audioContainer = UIView()
    let videoContainer = UIView()
    let audioView = FDWaveformView()
    let leftArrowView = UIImageView()
    let rightArrowView = UIImageView()
    let audioDurationView = UIView()
    
    var captionLabel = UILabel()
    
    var audioPlayer: AVAudioPlayer?
    var audioPlayerForNativeAudio: AVAudioPlayer?
    var audioWidth = NSLayoutConstraint()
    var audioLeft = NSLayoutConstraint()
    var audioRight = NSLayoutConstraint()
    var lastDragPosition: CGFloat = 0
    var audioDelay: CGFloat = 0 {
        didSet {
            print("SET AUDIO DELAY \(audioDelay)")
//            audioLeft.constant = audioDelay
            EditedVideo.shared.audioDelay = audioDelay
        }
    }
    var audioStopMark: CGFloat = 0 {
        didSet {
            audioRight.constant = audioStopMark
            EditedVideo.shared.audioStopMark = audioStopMark
        }
    }
    var audioDuration: CGFloat = 140 {
        didSet {
            if audioDuration < minimumAudioDuration {
                audioDuration = minimumAudioDuration
            }
            audioWidth.constant = audioDuration
            EditedVideo.shared.audioDuration = audioDuration
        }
    }
    
    var audioStartsAt: CGFloat = 0
    
    private let minimumAudioDuration: CGFloat = 50
    
    private let timeScale: Int32 = 30
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let videoTitle = EditedVideo.shared.videoTitle {
            self.titleTextField.text = videoTitle
        }
        self.player.muted = EditedVideo.shared.isMuted
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        if let tabBar = self.navigationController?.tabBarController as? YoTabBarController {
            tabBar.toggleButtonVisibility()
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.audioStopMark = self.audioContainer.bounds.width - audioDuration
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if let tabBar = self.navigationController?.tabBarController as? YoTabBarController {
            tabBar.toggleButtonVisibility()
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let audioUrl = EditedVideo.shared.audioUrl {
            audioView.audioURL = audioUrl
            print("Audio Delay \(EditedVideo.shared.audioDelay)")
            self.audioDelay = EditedVideo.shared.audioDelay
            self.audioStartsAt = self.audioDelay
//            audioRight = audioDurationView.rightAnchor.constraint(equalTo: audioContainer.rightAnchor, constant: audioWidth.constant + audioLeft.constant - audioContainer.frame.width)
//            audioRight.isActive = true
            audioStopMark = audioRight.constant
            updateAudioCharacteristics()
            updateAudioPosition()

            //startAudio()
            previewAnimation()
            if let videoUrl = EditedVideo.shared.videoUrl {
                player.asset = AVURLAsset(url: videoUrl)
            }
            if EditedVideo.shared.audioUrl != nil {
                startAudio()
            }
            startNativeAudio()
        }
        updateAudioWidth()
    }
    
    func updateAudioPosition() {
        if self.audioDelay > 0 {
            if let videoUrl = EditedVideo.shared.videoUrl, let _ = EditedVideo.shared.audioUrl {
                let video = AVAsset(url: videoUrl)
                let videoDuration = video.duration.seconds
                let videoWidth = audioContainer.frame.width
                
                let percentage = Double(self.audioDelay) / videoDuration
                let left = videoWidth * CGFloat(percentage)
                self.audioLeft.constant = left
                self.audioStartsAt = left
                self.view.layoutIfNeeded()

                //                seconds / videoDuration
                
                //                let audioStartsAt = audioLeft.constant
                //                let percentage = audioStartsAt / videoWidth
                //                seconds = Double(percentage) * videoDuration
                //                self.audioDelay = seconds
            }
        }
    }
    
    func previewAnimation() {
        self.captionLabel.alpha = 0
        self.captionLabel.text = EditedVideo.shared.captionText
        print(EditedVideo.shared.textEndPoints.end - EditedVideo.shared.textEndPoints.start)
        let duration = EditedVideo.shared.textEndPoints.end - EditedVideo.shared.textEndPoints.start
        UIView.animate(withDuration: 0.3, animations: {
            self.captionLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveLinear, animations: {
                self.captionLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    //MARK: - Private methods
    private func toggleBottomBar(){
        if let yoTabBar = self.navigationController?.tabBarController as? YoTabBarController {
            yoTabBar.toggleButtonVisibility()
            yoTabBar.tabBar.isHidden = !yoTabBar.tabBar.isHidden
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func updateAudioCharacteristics() {
        print("AUDIO CHARACTERISTICS")
        //if EditedVideo.shared.textIsSet {
        audioLeft.constant = EditedVideo.shared.audioDelay
        audioRight.constant = EditedVideo.shared.audioStopMark
        audioWidth.constant = EditedVideo.shared.audioDuration
        print("audioDelay")
        print(EditedVideo.shared.audioDelay)
        print("audioStop")
        print(EditedVideo.shared.audioStopMark)
        print("audioDuration")
        print(EditedVideo.shared.audioDuration)
        self.view.layoutIfNeeded()
        //}
    }
    
    private func updateAudioWidth() {
        if let videoUrl = EditedVideo.shared.videoUrl, let audioUrl = EditedVideo.shared.audioUrl {
            let video = AVURLAsset(url: videoUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
            let audio = AVURLAsset(url: audioUrl)
            var videoDuration = Double(CMTimeGetSeconds(video.duration))
            let audioDuration = Double(CMTimeGetSeconds(audio.duration))
            if videoDuration == 0 {
                videoDuration = audioDuration
            }
            let videoLength = audioContainer.frame.width
            let audioPercentage = audioDuration / videoDuration
            let audioWidthConstant = Double(videoLength) * audioPercentage
            audioWidth.constant = CGFloat(audioWidthConstant)
            self.view.layoutIfNeeded()
        }
    }
    
    private func mergeFilesWithUrl(videoUrl: URL, audioUrl: URL) {
        
        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        
        let aVideoAsset: AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset: AVAsset = AVAsset(url: audioUrl)
        
        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        mutableCompositionAudioTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        
        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        
        do {
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)
            
            let startPoint = CMTime(seconds: Double(audioDelay), preferredTimescale: timeScale)
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration - startPoint), of: aAudioAssetTrack, at: startPoint)
            
        }catch{
            fatalError(error.localizedDescription)
        }
        
        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration )
        
        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(1, timeScale)
        
        mutableVideoComposition.renderSize = CGSize(width:720, height:1280)
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        print ("random id = \(NSUUID().uuidString)")
        
        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let uniqueVideoID = "mergedVideo.mp4"
        
        let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        let mergedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
        if FileManager.default.fileExists(atPath: videoUrl.path) {
            try? FileManager.default.removeItem(at: videoUrl)
        }
        if FileManager.default.fileExists(atPath: mergedOutputFileUrl.path) {
            try? FileManager.default.removeItem(at: mergedOutputFileUrl)
        }
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = mergedOutputFileUrl
        assetExport.shouldOptimizeForNetworkUse = true
        
        assetExport.exportAsynchronously {
            () -> Void in
            switch assetExport.status {
                
            case AVAssetExportSessionStatus.completed:
                OperationQueue.main.addOperation {
                    EditedVideo.shared.videoUrl = mergedOutputFileUrl
                    EditedVideo.shared.audioUrl = audioUrl
                    self.navigationController?.popViewController(animated: true)
                }
            case  AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport.error))")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
            default:
                print("complete")
            }
        }
        
    }
    
    //MARK: - Actions
    @objc func nextTapped() {
        if let audioPlayer = self.audioPlayer {
            audioPlayer.stop()
        }
        //        if let videoVC = self.videoViewController {
        //            videoVC.audioDelay = Double(self.audioDelay)
        //            if let videoUrl = videoUrl, let audioUrl = audioUrl {
        //                mergeFilesWithUrl(videoUrl: videoUrl, audioUrl: audioUrl)
        //            }
        //        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func leftPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: audioContainer).x
        } else if gesture.state == .ended {
            playFromBeginning()
        } else {
            let currentPosition = gesture.location(in: audioContainer).x
            let diff = currentPosition - lastDragPosition
            if audioDuration - diff > minimumAudioDuration, audioDelay + diff > 0 {
                audioDuration -= diff
                audioDelay += diff
                self.view.layoutIfNeeded()
                lastDragPosition = currentPosition
                return
            }
        }
    }
    
    @objc func rightPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: audioContainer).x
        } else if gesture.state == .ended {
            playFromBeginning()
        } else {
            let currentPosition = gesture.location(in: audioContainer).x
            let diff = currentPosition - lastDragPosition
            if audioDuration + diff > minimumAudioDuration, audioStopMark + diff < 0 {
                audioDuration += diff
                audioStopMark += diff
                self.view.layoutIfNeeded()
                lastDragPosition = currentPosition
                return
            }
        }
    }
    
    @objc func audioDragged(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended {
            playFromBeginning()
        }
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: audioContainer).x
        } else {
            let currentPosition = gesture.location(in: audioContainer).x
            let diff = currentPosition - lastDragPosition
//            let previousLeftConstant = audioDelay
            let previousConstant = audioLeft.constant
            var newConstant = previousConstant + diff
            if newConstant < 0 {
                newConstant = 0
            }
//            var newLeftConstant = previousLeftConstant + diff
//            if newLeftConstant < 0 {
//                newLeftConstant = 0
//            }
//            let previousRightConstant = audioStopMark
//            var newRightConstant = previousRightConstant + diff
//            if newRightConstant > 0 {
//                newRightConstant = 0
//            }
//            if newRightConstant != 0 {
//                audioDelay = newLeftConstant
//            }
//            if newLeftConstant != 0 {
//                audioStopMark = newRightConstant
//            }
            print(newConstant)
            audioDelay = newConstant
            audioLeft.constant = newConstant
            self.view.layoutIfNeeded()
            lastDragPosition = currentPosition
        }
        if gesture.state == .ended {
            playFromBeginning()
        }
        
    }
    @objc func goBack() {
        let alertController = UIAlertController(title: "Remove audio?", message: "Are you sure you want to abandon this sound?", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "YES", style: .destructive, handler: { (_) in
            EditedVideo.shared.audioUrl = nil
            self.navigationController?.popViewController(animated: true)
//            if let videoViewController = self.videoViewController {
//                videoViewController.audioUrl = nil
//            }
            //            if let url = self.videoUrl {
            //                self.removeAudioFromVideo(url, goBackOnDone: true)
            //            }
        })
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: { (_) in})
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //    func removeAudioFromVideo(_ videoToMuteUrl: URL, goBackOnDone: Bool) {
    //        let inputVideoURL: URL = videoToMuteUrl
    //        let sourceAsset = AVURLAsset(url: inputVideoURL)
    //        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
    //        let composition : AVMutableComposition = AVMutableComposition()
    //        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
    //        let x: CMTimeRange = CMTimeRangeMake(kCMTimeZero, sourceAsset.duration)
    //        _ = try? compositionVideoTrack!.insertTimeRange(x, of: sourceVideoTrack!, at: kCMTimeZero)
    //        let mutableVideoURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo.mp4")
    //        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
    //        exporter.outputFileType = AVFileType.mp4
    //        exporter.outputURL = mutableVideoURL as URL
    //        removeFileAtURLIfExists(url: mutableVideoURL)
    //        exporter.exportAsynchronously(completionHandler:
    //            {
    //                switch exporter.status
    //                {
    //                case AVAssetExportSessionStatus.failed:
    //                    print("failed \(String(describing: exporter.error))")
    //                case AVAssetExportSessionStatus.cancelled:
    //                    print("cancelled \(String(describing: exporter.error))")
    //                case AVAssetExportSessionStatus.unknown:
    //                    print("unknown\(String(describing: exporter.error))")
    //                case AVAssetExportSessionStatus.waiting:
    //                    print("waiting\(String(describing: exporter.error))")
    //                case AVAssetExportSessionStatus.exporting:
    //                    print("exporting\(String(describing: exporter.error))")
    //                default:
    //                    print("-----Mutable video exportation complete.")
    //                    self.removeFileAtURLIfExists(url: videoToMuteUrl)
    //                    let fileManager = FileManager.default
    //                    if fileManager.fileExists(atPath: mutableVideoURL.path) {
    //                        do {
    //                            try fileManager.moveItem(at: mutableVideoURL, to: videoToMuteUrl)
    //                        } catch let error as NSError {
    //                            print("Couldn't move file: \(error)")
    //                        }
    //                    }
    //                    OperationQueue.main.addOperation {
    //                        if goBackOnDone {
    //                            self.navigationController?.popViewController(animated: true)
    //                        }
    //                    }
    //
    //
    //                    // 0. remove original
    //                    // 1. copy to a correct URL
    //                    // 2. remove temp video
    //                    // 3. call completion
    //                }
    //        })
    //    }
    
    func removeFileAtURLIfExists(url: URL) {
        let filePath = url.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do{
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print("Couldn't remove existing destination file: \(error)")
            }
        }
    }
    
    
    //MARK: - Private methods
    private func playFromBeginning() {
        print(self.player.muted)
        startAudio()
        startNativeAudio()
        let startTime = EditedVideo.shared.textEndPoints.start
        DispatchQueue.main.asyncAfter(deadline: .now() + startTime, execute: {
            self.previewAnimation()
        })
        player.pause()
        player.resetToPlaceholder()
        player.play()
    }
    
    func startNativeAudio() {
        self.player.muted = true
        if let url = EditedVideo.shared.audioContainerUrl {
            self.player.muted = EditedVideo.shared.isMuted
            do {
                self.audioPlayerForNativeAudio = try AVAudioPlayer(contentsOf: url)
                if let aPlayer = self.audioPlayerForNativeAudio {
                    aPlayer.numberOfLoops = 0
                    aPlayer.prepareToPlay()
                    if EditedVideo.shared.isMuted {
                        aPlayer.setVolume(0, fadeDuration: 0)
                    } else {
                        aPlayer.setVolume(1, fadeDuration: 0)
                    }
                }
            } catch {
                
            }
        } else {
            self.player.muted = EditedVideo.shared.isMuted
            self.audioPlayerForNativeAudio = nil
        }
    }
    
    func startAudio() {
        self.player.muted = true
        if let url = EditedVideo.shared.audioUrl {
            self.player.muted = EditedVideo.shared.isMuted
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                if let aPlayer = self.audioPlayer {
                    aPlayer.numberOfLoops = 0
                    aPlayer.prepareToPlay()
                }
            } catch {
                
            }
            
            // calculate seconds delay
            var seconds: Double = 0
            if let videoUrl = EditedVideo.shared.videoUrl, let _ = EditedVideo.shared.audioUrl {



//                let audioStartsAt = audioLeft.constant
//                print(audioStartsAt)
//                let percentage = audioStartsAt / videoWidth
//                seconds = Double(percentage) * videoDuration
//                self.audioDelay = seconds

                let video = AVAsset(url: videoUrl)
                let videoDuration = video.duration.seconds
                let videoWidth = audioContainer.frame.width

                                let audioStartsAt = audioLeft.constant

                                let percentage = audioStartsAt / videoWidth
                                seconds = Double(percentage) * videoDuration
                self.audioDelay = CGFloat(seconds)
                self.audioStartsAt = CGFloat(seconds)



//                let percentage = audioDelay / videoWidth
//                seconds = Double(percentage) * videoDuration
//                self.audioStartsAt = CGFloat(seconds)
//                EditedVideo.shared.audioDelay = self.audioStartsAt
//                print("audio start \(audioStartsAt)")
            }
        }
    }
}

extension MediaSyncViewController: ASVideoNodeDelegate {
    
    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying == false {
            audioPlayer.stop()
        }
        startAudio()
        startNativeAudio()
        let startTime = EditedVideo.shared.textEndPoints.start
        DispatchQueue.main.asyncAfter(deadline: .now() + startTime, execute: {
            self.previewAnimation()
        })
    }
    
    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        let seconds = Double(timeInterval.remainder(dividingBy: 60))
        
        //let roundedSeconds = Double(round(1000*seconds)/1000)
        let roundedTime = Double(round(1000*audioStartsAt)/1000)
        //        print("\(roundedTime) == \(roundedSeconds) (\(seconds))")
        //        if roundedTime == roundedSeconds {
        //            self.playAudio()
        //        }
        if roundedTime > (seconds - 0.01) && roundedTime < (seconds + 0.01) {
            GeneralMethods.playAudio(player: self.audioPlayer)
        } else if roundedTime < 0 {

        }
        
        GeneralMethods.playAudio(player: self.audioPlayerForNativeAudio)
    }
    
    func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
        print(error)
    }
}

