import UIKit
import AssetsLibrary
import AVFoundation
import Photos

enum QUWatermarkPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class QUWatermarkManager: NSObject {
    
    //    func watermark(video videoAsset:AVAsset, watermarkText text : String, imageName: String?, saveToLibrary flag : Bool,
    //                   watermarkPosition position : QUWatermarkPosition,
    //                   completion : @escaping (_ status: AVAssetExportSessionStatus, _ session: AVAssetExportSession, _  outputURL: URL?) -> ()) {
    //
    ////        self.watermark(video: videoAsset, watermarkText: text, imageName: "watermark", saveToLibrary: flag,
    //        self.watermark(video: videoAsset, watermarkText: text, imageName: imageName, saveToLibrary: flag,
    //                       watermarkPosition: position) {
    //                        (status, session, outputURL) -> () in
    //                        completion(status,session,outputURL)
    //        }
    //    }
    //
    //    func watermark(video videoAsset:AVAsset, imageName name : String, saveToLibrary flag : Bool,
    //                   watermarkPosition position : QUWatermarkPosition,
    //                   completion : @escaping ( _ status :AVAssetExportSessionStatus, _ session: AVAssetExportSession, _ outputURL: URL?) -> ()) {
    //
    //        self.watermark(video: videoAsset, watermarkText: nil, imageName: name, saveToLibrary: flag, watermarkPosition: position) {
    //            (status, session, outputURL) -> () in
    //            completion(status, session, outputURL)
    //        }
    //    }

    func watermark(video videoAsset:AVAsset, watermarkText text: String?, origHeight: CGFloat, imageName name :String?, saveToLibrary flag : Bool,
                   watermarkPosition position : QUWatermarkPosition,
                   completion: @escaping (_ status : AVAssetExportSessionStatus, _ session: AVAssetExportSession, _ outputURL: URL?) -> ()) {
        
        DispatchQueue.main.async(execute: {
            let mixComposition = AVMutableComposition()
            let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
            try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: clipVideoTrack, at: kCMTimeZero)
            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
                let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
                let sourceAudioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
                try! compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: sourceAudioTrack, at: kCMTimeZero)
            }
            let _ = clipVideoTrack.preferredTransform
            
            let videoSize = clipVideoTrack.naturalSize
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            parentLayer.addSublayer(videoLayer)
            
            if let text = text {
                // Adding watermark text
                let titleLayer = CATextLayer()
                titleLayer.isWrapped = true

                titleLayer.backgroundColor = UIColor.white.cgColor
                titleLayer.foregroundColor = UIColor.black.cgColor

                var xPosition : CGFloat = 0.0
                var yPosition : CGFloat = 0.0
                
                let multiplier = origHeight / 335
                let origHeight = text.height(withConstrainedWidth: 335, font: UIFont(name: "Helvetica-Light", size: 24)!) + 10
                let textHeight = origHeight * multiplier
                
                let textWidth  : CGFloat = 350

                switch (position) {
                case .bottomLeft:
                    xPosition = 0
                    yPosition = 0
                    break
                case .topRight:
                    xPosition = videoSize.width - textWidth
                    yPosition = videoSize.height - textHeight
                    break
                case .topLeft:
                    xPosition = 0
                    yPosition = videoSize.height - textHeight
                    break
                case .bottomRight:
                    xPosition = videoSize.width - textWidth
                    yPosition = 0
                    break
                }

                titleLayer.string = text
                titleLayer.fontSize = 24 * multiplier

                let font = UIFont(name: "Helvetica-Light", size: 1)
                titleLayer.font = CGFont(font!.fontName as NSString)
                titleLayer.alignmentMode = kCAAlignmentLeft
                titleLayer.opacity = 1
                titleLayer.frame = CGRect(x: xPosition, y: yPosition, width: videoSize.width, height: textHeight)
                parentLayer.addSublayer(titleLayer)
            }
            
            if name != nil {
                // Adding image
                let watermarkImage = UIImage(named: name!)
                let imageLayer = CALayer()
                imageLayer.contents = watermarkImage?.cgImage

                var xPosition : CGFloat = 0.0
                var yPosition : CGFloat = 0.0
                let imageHeight : CGFloat = 56
                let imageWidth  : CGFloat = 100
                let horizontalPadding : CGFloat = 10
                xPosition = videoSize.width - imageWidth - horizontalPadding
                yPosition = 0

                imageLayer.frame = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
                imageLayer.opacity = 0.5
                parentLayer.addSublayer(imageLayer)
            }

            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(1, 30)
            
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            //            let instructions = QUWatermarkManager.videoCompositionInstructions(for: videoAsset)
            //            let instructions = QUWatermarkManager.videoCompositionInstructions(for: videoAsset, track: compositionVideoTrack)
            //            let layerInstruction = instructions.0
            //            let instruction = instructions.1

            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
            let instruction = AVMutableVideoCompositionInstruction()
            //            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))


            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]
            
            let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
            
            let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            let uniqueVideoID = "sharedVideo\(NSUUID().uuidString).mp4"
            
            let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
            let sharedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
            
            if FileManager.default.fileExists(atPath: sharedOutputFileUrl.path) {
                try? FileManager.default.removeItem(at: sharedOutputFileUrl)
            }
            assetExport.outputFileType = AVFileType.mp4
            assetExport.outputURL = sharedOutputFileUrl
            assetExport.shouldOptimizeForNetworkUse = true
            assetExport.videoComposition = videoComp
            
            assetExport.exportAsynchronously {
                switch assetExport.status {
                    
                case AVAssetExportSessionStatus.completed:
                    OperationQueue.main.addOperation {
                        
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: sharedOutputFileUrl)
                        }) {
                            saved, error in
                            print(error?.localizedDescription)
                            if saved {
                                let fetchOptions = PHFetchOptions()
                                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                                
                                // After uploading we fetch the PHAsset for most recent video and then get its current location url
                                
                                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                                PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                                    let newObj = avurlAsset as! AVURLAsset
                                    print(newObj.url)
                                    // This is the URL we need now to access the video from gallery directly.
                                })
                                completion(assetExport.status, assetExport, sharedOutputFileUrl)
                            }
                        }
                    }
                case  AVAssetExportSessionStatus.failed:
                    completion(assetExport.status, assetExport, nil)
                    print("failed \(String(describing: assetExport.error))")
                case AVAssetExportSessionStatus.cancelled:
                    completion(assetExport.status, assetExport, nil)
                    print("cancelled \(String(describing: assetExport.error))")
                default:
                    print("complete")
                }
            }
        })
    }

    
    //MARK: ANIMATED TEXT
    
    func animatedText(video videoAsset:AVAsset,
                      animationText text: String,
                      startAt: Double,
                      finishAt: Double,
                      textColor: UIColor, textFontSize: CGFloat,
                      position: CGPoint,
                      completion: @escaping (_ status : AVAssetExportSessionStatus, _ session: AVAssetExportSession, _ outputURL: URL?) -> ()
        ) {
        DispatchQueue.main.async(execute: {
            let mixComposition = AVMutableComposition()
            let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
            try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: clipVideoTrack, at: kCMTimeZero)
            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
                let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
                let sourceAudioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
                try! compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: sourceAudioTrack, at: kCMTimeZero)
            }
            let _ = clipVideoTrack.preferredTransform

            let videoSize = clipVideoTrack.naturalSize
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)

            // Adding watermark text

            let titleLayer = CATextLayer()
            titleLayer.isWrapped = true

            titleLayer.backgroundColor = UIColor.clear.cgColor
            titleLayer.foregroundColor = textColor.cgColor

            let captionHeightOniPhone6 = text.height(withConstrainedWidth: 335, font: EditedVideo.shared.captionFont.withSize(textFontSize)) + 20
            let multiplier = (videoSize.height / 335)
            let textHeight : CGFloat = captionHeightOniPhone6 * multiplier
            
            let xPosition : CGFloat = 0
            let yPosition : CGFloat = 27 * multiplier
            
            let myAttributes = [NSAttributedStringKey.font: EditedVideo.shared.captionFont.withSize(textFontSize * multiplier), NSAttributedStringKey.foregroundColor: textColor]

            let myAttributedString = NSAttributedString(string: text, attributes: myAttributes)
            titleLayer.string = myAttributedString
            titleLayer.alignmentMode = kCAAlignmentCenter
            titleLayer.opacity = 0
            titleLayer.frame = CGRect(x: xPosition, y: yPosition, width: videoSize.width, height: textHeight)
            
            let startAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            startAnimation.duration = 0.1
            startAnimation.fromValue = 0.0
            startAnimation.toValue = 1.0
            startAnimation.fillMode = kCAFillModeForwards
            startAnimation.isRemovedOnCompletion = false
            startAnimation.beginTime = AVCoreAnimationBeginTimeAtZero + startAt
            titleLayer.opacity = 0
            titleLayer.add(startAnimation, forKey: "opacity")

            let finishAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            finishAnimation.duration = 0.1
            finishAnimation.fromValue = 1.0
            finishAnimation.toValue = 0.0
            finishAnimation.fillMode = kCAFillModeForwards
            finishAnimation.isRemovedOnCompletion = false
            finishAnimation.beginTime = AVCoreAnimationBeginTimeAtZero + finishAt
            //titleSuperviewLayer.opacity = 1
            //titleSuperviewLayer.add(finishAnimation, forKey: "opacity")

            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(titleLayer)

            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(1, 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))

            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]

            let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!

            let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            let uniqueVideoID = "sharedVideo\(NSUUID().uuidString).mp4"

            let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
            let sharedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)

            if FileManager.default.fileExists(atPath: sharedOutputFileUrl.path) {
                try? FileManager.default.removeItem(at: sharedOutputFileUrl)
            }
            assetExport.outputFileType = AVFileType.mp4
            assetExport.outputURL = sharedOutputFileUrl
            assetExport.shouldOptimizeForNetworkUse = true
            assetExport.videoComposition = videoComp

            assetExport.exportAsynchronously {
                switch assetExport.status {

                case AVAssetExportSessionStatus.completed:
                    completion(assetExport.status, assetExport, sharedOutputFileUrl)
                case  AVAssetExportSessionStatus.failed:
                    completion(assetExport.status, assetExport, nil)
                    print("failed \(String(describing: assetExport.error))")
                case AVAssetExportSessionStatus.cancelled:
                    completion(assetExport.status, assetExport, nil)
                    print("cancelled \(String(describing: assetExport.error))")
                default:
                    print("complete")
                }
            }
        })
    }
    
    
    static func videoCompositionInstructions(for asset: AVAsset, track: AVMutableCompositionTrack) -> (AVMutableVideoCompositionLayerInstruction, AVMutableVideoCompositionInstruction) {

        
        let clipVideoTrack = asset.tracks( withMediaType: AVMediaType.video).first! as AVAssetTrack

        var minLength = clipVideoTrack.naturalSize.width
        let yOffset = CGFloat((clipVideoTrack.naturalSize.height - clipVideoTrack.naturalSize.width) / 2)
        let xOffset = CGFloat(0)
        if minLength > clipVideoTrack.naturalSize.height {
            minLength = clipVideoTrack.naturalSize.height
        }

        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: track)

        //            AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))

        let txf = clipVideoTrack.preferredTransform
        let videoSize = clipVideoTrack.naturalSize

        if videoSize.width == txf.tx && videoSize.height == txf.ty {
            // UIImageOrientationLeft
            let transform1: CGAffineTransform = CGAffineTransform(translationX: clipVideoTrack.naturalSize.width + yOffset, y: clipVideoTrack.naturalSize.height - xOffset)

            let transform2 = transform1.rotated(by: .pi)
            let finalTransform = transform2
            transformer.setTransform(finalTransform, at: kCMTimeZero)
        } else if txf.tx == 0 && txf.ty == 0 {
            // UIImageOrientationRight
            // I don't know why we use yOffset in X, but it seems to work well
            let transform1: CGAffineTransform = CGAffineTransform(translationX: 0 + yOffset, y: 0 + xOffset)
            let transform2 = transform1.rotated(by: 0)
            let finalTransform = transform2
            transformer.setTransform(finalTransform, at: kCMTimeZero)
        } else if txf.tx == 0 && txf.ty == videoSize.width {
            // UIImageOrientationDown
            let transform1: CGAffineTransform = CGAffineTransform(translationX: 0 - xOffset, y: clipVideoTrack.naturalSize.width + yOffset)
            let transform2 = transform1.rotated(by: -(.pi/2))
            let finalTransform = transform2
            transformer.setTransform(finalTransform, at: kCMTimeZero)
        } else {
            // UIImageOrientationUp
            let transform1: CGAffineTransform = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height - xOffset, y: 0 + yOffset)
            let transform2 = transform1.rotated(by: .pi/2)
            let finalTransform = transform2
            transformer.setTransform(finalTransform, at: kCMTimeZero)
        }
        return (transformer, instruction)
        
        //        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        //        let assetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        //
        //        let transform = assetTrack.preferredTransform
        //        let assetInfo = orientationFromTransform(transform: transform)
        //
        //        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        //        if assetInfo.isPortrait {
        //            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
        //            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        //            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
        //                                     at: kCMTimeZero)
        //        } else {
        //            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        //            var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
        //                .concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
        //            if assetInfo.orientation == .down {
        //                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        //                let windowBounds = UIScreen.main.bounds
        //                let yFix = assetTrack.naturalSize.height + windowBounds.height
        //                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
        //                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
        //            }
        //            instruction.setTransform(concat, at: kCMTimeZero)
        //        }
        //
        //        return instruction
    }

    static func addHeight(for inputUrl: URL, text: String , completion: @escaping (_ url: URL?, _ videoHeight: CGFloat) -> ()) {
        //        let asset = AVURLAsset(url: url)
        //
        //        let sourceVideoTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        //        let composition = AVMutableComposition()
        //        let track = composition.addMutableTrack(withMediaType: AVMediaTypeVideo,
        //                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
        //
        //        _ = try? track.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration),
        //                                                       of: sourceVideoTrack, at: kCMTimeZero)
        //
        //        let mixComposition = AVMutableComposition()
        //        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        //
        //        let clipVideoTrack = asset.tracks( withMediaType: AVMediaTypeVideo ).first! as AVAssetTrack
        //
        //
        //
        //        var minLength = clipVideoTrack.naturalSize.width
        //        let yOffset = CGFloat(0)
        //        let xOffset = CGFloat(0)
        //
        //        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        //        let instruction = AVMutableVideoCompositionInstruction()
        //        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        //
        //        let txf = clipVideoTrack.preferredTransform
        //        let videoSize = clipVideoTrack.naturalSize
        //
        //        let transform1: CGAffineTransform = CGAffineTransform(translationX: clipVideoTrack.naturalSize.width,
        //                                                              y: clipVideoTrack.naturalSize.height + 100)
        //        transformer.setTransform(transform1, at: kCMTimeZero)
        //
        //
        //        let videoComposition = AVMutableVideoComposition()
        //        videoComposition.renderSize = CGSize(width: minLength, height: minLength + 100)
        //        videoComposition.frameDuration = CMTimeMake(1, 30)
        //
        //        instruction.layerInstructions = [transformer]
        //        videoComposition.instructions = [instruction]
        //
        //        let uniqueVideoID = "temp_video.mp4"
        //        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
        //                                                           FileManager.SearchPathDomainMask.userDomainMask, true).first!
        //
        //
        //        let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        //        let croppedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
        //
        //
        //        let fileManager = FileManager.default
        //        if fileManager.fileExists(atPath: croppedOutputFileUrl.path) {
        //            do{
        //                try fileManager.removeItem(atPath: url.path)
        //            } catch let error as NSError {
        //                print("Couldn't remove existing destination file: \(error)")
        //            }
        //        }
        //
        //        // export
        //        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        //        exporter.outputFileType = AVFileTypeMPEG4
        //        exporter.outputURL = croppedOutputFileUrl
        //        exporter.shouldOptimizeForNetworkUse = true
        //        exporter.videoComposition = videoComposition
        //
        //        exporter.exportAsynchronously(completionHandler:
        //            {
        //                switch exporter.status {
        //                case AVAssetExportSessionStatus.failed:
        //                    print("failed \(exporter.error?.localizedDescription ?? "")")
        //                case AVAssetExportSessionStatus.cancelled:
        //                    print("cancelled \(exporter.error?.localizedDescription ?? "")")
        //                case AVAssetExportSessionStatus.unknown:
        //                    print("unknown\(exporter.error?.localizedDescription ?? "")")
        //                case AVAssetExportSessionStatus.waiting:
        //                    print("waiting\(exporter.error?.localizedDescription ?? "")")
        //                case AVAssetExportSessionStatus.exporting:
        //                    print("exporting\(exporter.error?.localizedDescription ?? "")")
        //                default:
        //                    DispatchQueue.main.async(execute: {
        //                        print("Success")
        //                        completion(croppedOutputFileUrl)
        //                    })
        //                }
        //        })



        let videoAsset = AVURLAsset(url: inputUrl)
        //        let videoAsset = AVAsset(URL: inputURL) as AVAsset
        let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first! as AVAssetTrack

        let videoSize = clipVideoTrack.naturalSize
        let multiplier = videoSize.height / 335
        let origHeight = text.height(withConstrainedWidth: 335, font: UIFont(name: "Helvetica-Light", size: 24)!) + 10
        let height = origHeight * multiplier
        
        let composition = AVMutableComposition()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())

        let videoComposition = AVMutableVideoComposition()

        videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.width,
                                             height: clipVideoTrack.naturalSize.height + height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(180, 30))

        let transformer : AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)

        let t1 = CGAffineTransform(translationX: 0, y: height)
        transformer.setTransform(t1, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]

        let uniqueVideoID = "temp_video.mp4"
        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                           FileManager.SearchPathDomainMask.userDomainMask, true).first!

        let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        let croppedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: croppedOutputFileUrl.path) {
            do {
                try fileManager.removeItem(atPath: croppedOutputFileUrl.path)
            } catch let error as NSError {
                print("Couldn't remove existing destination file: \(error)")
            }
        }

        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        exporter.outputURL = croppedOutputFileUrl
        exporter.outputFileType = AVFileType.mov


        exporter.exportAsynchronously {
            DispatchQueue.main.async(execute: {
                switch exporter.status {
                case AVAssetExportSessionStatus.failed:
                    print(exporter.error)
                    print(exporter)
                    print("failed \(exporter.error?.localizedDescription ?? "")")
                    completion(nil,videoSize.height)
                    break
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(exporter.error?.localizedDescription ?? "")")
                    completion(nil,videoSize.height)
                    break
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(exporter.error?.localizedDescription ?? "")")
                    completion(nil,videoSize.height)
                    break
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(exporter.error?.localizedDescription ?? "")")
                    break
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(exporter.error?.localizedDescription ?? "")")
                    break
                default:
                    print("Success")
                    completion(croppedOutputFileUrl,videoSize.height )
                    break
                }
            })
        }
    }
}
