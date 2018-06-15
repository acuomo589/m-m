//
//  EditedVideo.swift
//  YoGIF
//
//  Created by Artem Misesin on 2/14/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EditedVideo {

    private var resultUrl: URL?

    var videoUrl: URL? {
        didSet {
            if videoUrl == nil {
                videoTitle = ""
                self.audioUrl = nil
                self.textIsSet = false
            }
        }
    }

    var videoTitle: String?
    var titleHeight: CGFloat = 40
    var weeklyTitle: String?
    
    var isMuted = false
    
    
    
    
    var audioUrl: URL? {
        didSet {
            if audioUrl == nil {
                self.audioDelay = 0
                self.audioDuration = 140
            }
        }
    }
    
    var audioContainerUrl: URL?
    
    var audioDelay: CGFloat = 0
    var audioStopMark: CGFloat = 0
    var audioDuration: CGFloat = 140

    var textIsSet = false {
        didSet {
            if textIsSet == false {
                self.captionText = ""
                self.captionColor = AppConstants.colorGreen
                self.textDelay = 0
                self.textDuration = 140
                self.textEndPoints = (0, 1)
                self.textFontSize = 76
            }
        }
    }

    var captionText: String = ""
    var textDelay: CGFloat = 0
    var textStopMark: CGFloat = 0
    var textDuration: CGFloat = 140
    var textFontSize: CGFloat = 76
    var captionLocation = CGPoint(x: 0, y: 0)

    var captionFont: UIFont = {
//        switch UIScreen.main.bounds.height {
//        case 568:
//            return UIFont.boldSystemFont(ofSize: 20)
//        case 736:
//            return UIFont.boldSystemFont(ofSize: 26)
//        case 812:
//            return UIFont.boldSystemFont(ofSize: 28)
//        default:
        return UIFont.boldSystemFont(ofSize: 24)
       // }
    }()

    var captionHeight: CGFloat = 0

    var textEndPoints: (start: Double, end: Double) = (0, 1)

    var captionColor: UIColor = AppConstants.colorGreen

    
    
    private let timeScale: Int32 = 30

    static let shared = EditedVideo()

    func resetToDefaults() {
        videoUrl = nil

        videoTitle = ""
        titleHeight = 40
        weeklyTitle = nil

        audioUrl = nil
        audioDelay = 0
        audioStopMark = 0
        audioDuration = 140

        isMuted = false
        
        textIsSet = false
        captionText = ""
        textDelay = 0
        textStopMark = 0
        textDuration = 140
        textFontSize = 76
        captionLocation = CGPoint(x: 0, y: 0)

        audioContainerUrl = nil
        
        
        captionHeight = 0

        textEndPoints = (0, 1)

        captionColor = AppConstants.colorGreen
    }

    private func addTextLayer(completion: @escaping (AVAssetExportSessionStatus, AVAssetExportSession, URL?) -> Void) {
        let wm = QUWatermarkManager()
        print(videoUrl!)
        guard let videoUrl = self.videoUrl else {
            return
        }
        let asset = AVURLAsset(url: videoUrl)
        print("Caption location: \(self.captionLocation)")
        print("Caption font: \(self.textFontSize)")
        wm.animatedText(video: asset,
                        animationText: captionText,
                        startAt: self.textEndPoints.start,
                        finishAt: self.textEndPoints.end,
                        textColor: self.captionColor,
                        textFontSize: 24,
                        position: self.captionLocation,
                        completion: { (status, session, url) in
            completion(status, session, url)
        })
    }

    private func addAudioLayer(to videoUrl: URL, completion: @escaping (AVAssetExportSession?) -> Void) {
        
        let audioUrl:URL!
        if let aUrl = self.audioUrl {
            audioUrl = aUrl
        } else {
            if !self.isMuted {
                audioUrl = videoUrl
            } else {
                completion(nil)
                return
            }
        }
        
        /*
            - Створюємо нову композицію, додаємо аудіо і відео треки, вставляємо в ці треки наше відео і аудіо, зберігаємо готовий відеоролик в форматі .mp4
            - Creating a new composition, adding audio and video tracks, inserting our video and audio in these tracks, saving the finished video in .mp4 format
        */

        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()

        let aVideoAsset: AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset: AVAsset = AVAsset(url: audioUrl)
        
        
        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        mutableCompositionAudioTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)

        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        var aAudioAssetTrack: AVAssetTrack?
        
        if !aAudioAsset.tracks(withMediaType: AVMediaType.audio).isEmpty {
            aAudioAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        }

        do {
            
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)

            let startPoint = CMTime(seconds: Double(self.audioDelay), preferredTimescale: timeScale)
            if let aTrack = aAudioAssetTrack {
                try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration - startPoint), of: aTrack, at: startPoint)
            }
            
            if let originalAudioUrl = self.audioContainerUrl {
                if !self.isMuted {
                    // adding native audio from micro to composition
                    // додаємо нативний звук з мікрофона до композиції
                    let oAudioAsset: AVAsset = AVAsset(url: originalAudioUrl)
                    mutableCompositionAudioTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
                    let oAudioAssetTrack: AVAssetTrack = oAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
                    try mutableCompositionAudioTrack[1].insertTimeRange(CMTimeRangeMake(kCMTimeZero, oAudioAssetTrack.timeRange.duration), of: oAudioAssetTrack, at: kCMTimeZero)
                }
            } else {
                if !self.isMuted {
                    var oaAudioAssetTrack: AVAssetTrack?
                    if !aVideoAsset.tracks(withMediaType: AVMediaType.audio).isEmpty {
                        oaAudioAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.audio)[0]
                    }
                    mutableCompositionAudioTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
                    if let oaTrack = oaAudioAssetTrack {
                        try mutableCompositionAudioTrack[1].insertTimeRange(CMTimeRangeMake(kCMTimeZero, oaTrack.timeRange.duration), of: oaTrack, at: kCMTimeZero)
                    }
                }
            }

        } catch {
            fatalError(error.localizedDescription)
        }

        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration )

        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(1, self.timeScale)

        mutableVideoComposition.renderSize = CGSize(width:720, height:1280)

 
        print("Video Size: \(self.videoMBSize(asset: aVideoAsset))")
        
//        if videoMbsize > 80 {
//
//            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//            let rootController = appDelegate.window!.rootViewController as! YoTabBarController
//            let vc = rootController.viewControllers?.last!
//            SimpleAlert.showAlert(alert: "Video huge!", delegate: vc ?? rootController)
//
//        }
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)!
        print ("random id = \(NSUUID().uuidString)")

        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let uniqueVideoID = "mergedVideo.mp4"

        let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        resultUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
        if FileManager.default.fileExists(atPath: videoUrl.path) {
            try? FileManager.default.removeItem(at: videoUrl)
        }
        if FileManager.default.fileExists(atPath: resultUrl!.path) {
            try? FileManager.default.removeItem(at: resultUrl!)
        }
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = resultUrl!
        assetExport.shouldOptimizeForNetworkUse = true

        assetExport.exportAsynchronously {
            () -> Void in
            completion(assetExport)
        }

    }

    func renderVideo(completion: @escaping (URL?) -> Void) {
        
        self.addTextLayer { (status, session, url) in
            guard url != nil else {
                completion(nil)
                return
            }

            self.addAudioLayer(to: url!, completion: { (assetExport) in
                guard assetExport != nil else {
                    completion(url)
                    return
                }
                switch assetExport!.status {
                case AVAssetExportSessionStatus.completed:
                    OperationQueue.main.addOperation {
                        guard let resultUrl = self.resultUrl else {
                            return
                        }
                        EditedVideo.shared.videoUrl = self.videoUrl
                        
                        if let aUrl = self.audioUrl {
                            EditedVideo.shared.audioUrl = aUrl
                        } else {
                            if !self.isMuted {
                                EditedVideo.shared.audioUrl = self.videoUrl
                            }
                        }
                        completion(resultUrl)
                        //self.navigationController?.popViewController(animated: true)
                    }
                case  AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: assetExport!.error))")
                    completion(nil)
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: assetExport!.error))")
                    completion(nil)
                default:
                    print("complete")
                    completion(nil)
                }
            })
            
        }
    }
    
    func videoMBSize(asset: AVAsset) -> Double {
        let tracks = asset.tracks
        var estimatedSize = 0.0
        for track in tracks {
            let rate = Double(track.estimatedDataRate / 8)
            let seconds = CMTimeGetSeconds(track.timeRange.duration)
            estimatedSize += seconds * rate
        }
        let mbSize = estimatedSize / 1024 / 1024
        
        return mbSize
    }
    
    
    
}
