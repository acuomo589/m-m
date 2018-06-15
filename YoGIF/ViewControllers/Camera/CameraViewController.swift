import UIKit
import CameraManager
import SVProgressHUD
import MobileCoreServices
import AVFoundation

private final class MCamera: CameraManager {
    override var flashMode: CameraFlashMode {
        didSet {
            if flashMode != oldValue {
                _updateFlashMode(flashMode.rawValue == 1 ? true : false)
            }
        }
    }
    private func _updateFlashMode(_ flashMode: Bool) {
        captureSession?.beginConfiguration()
        defer { captureSession?.commitConfiguration() }
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = flashMode ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

class CameraViewController: UIViewController, YoSegmentControlControlDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraView = UIView()
    let recordButton = UIButton()
    let segmentControl = YoSegmentControl()
    private let cameraManager = MCamera()
    let recordContainer = UIView()
    let recordTime = UILabel()
    let flashButton = UIButton()
    let switchCameraButton = UIButton()
    private var timer: Timer!
    let redDot = UIView()
    let topContainer = UIView()
    let bottomContainer = UIView()
    let imagePicker = UIImagePickerController()
    var yoGifWeeklyTitle: String?
    let maxVideoLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCamera()
        setupUI()
        addCameraLayer()
        EditedVideo.shared.resetToDefaults()
        imagePicker.delegate = self
        imagePicker.videoMaximumDuration = Double(maxVideoLength)
        imagePicker.allowsEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        segmentControl.redraw(animated: false)
        
        if let captureSession = cameraManager.captureSession, !captureSession.isRunning {
            cameraManager.resumeCaptureSession()
        }
        if self.yoGifWeeklyTitle != nil {
            self.segmentControl.isHidden = true
        }
    }
    
    func selectedItem(index: Int) {
        if index == 1 {
            getImageFromLibrary()
            segmentControl.segmentControl.selectedSegmentIndex = 0
            segmentControl.changeSelection(animated: true)
        }
    }
    @objc func flashTapped() {
        if cameraManager.flashMode == .off{
            cameraManager.flashMode = .on
        } else {
            cameraManager.flashMode = .off
        }
    }
    @objc func cameraSwitchTapped() {
        if cameraManager.cameraDevice == .front {
            cameraManager.cameraDevice = .back
            flashButton.isHidden = false
        } else {
            if cameraManager.flashMode == .on {
                cameraManager.flashMode = .off
            }
            flashButton.isHidden = true
            cameraManager.cameraDevice = .front
        }
    }
    func addCameraLayer(){
        let cameraStatus = cameraManager.addPreviewLayerToView(self.cameraView)
        
        switch cameraStatus {
        case .accessDenied:
            show(failure: "Camera acces denied. Go to settings and provide access", with: "Access denied",
                 actionHandler: {
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!,
                                              options: [:], completionHandler: nil)
            })
            print("Camera acces denied")
        case .noDeviceFound:
            show(failure: "There is no camera. Or something wrong with your hardware", with: "Camera hardware error!")
            print("There is no camera")
        case .notDetermined:
            print("State notDetermined")
        case .ready:
            print("Camera is ready!")
        }
    }
    func configureCamera(){
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true
        cameraManager.shouldEnableTapToFocus = true
        cameraManager.shouldEnablePinchToZoom = true
        cameraManager.animateShutter = true
        cameraManager.cameraOutputMode = .videoWithMic

    }
    
    @objc func startVideo() {
        //        cameraManager.cameraOutputMode = .videoOnly // for some reason it gets overridden. Have to have it in here.
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(updateRecordTime),
                                          userInfo: nil,
                                          repeats: true)
        cameraManager.startRecordingVideo()
        recordTime.text = "00:00"
        dotAnimation()
        topContainer.alpha = 0.5
        bottomContainer.alpha = 0.5
        recordContainer.isHidden = false
    }
    
    @objc func stopVideo() {
        let recordedVideoDuration = cameraManager.recordedDuration
        cameraManager.stopCaptureSession()
        
        cameraManager.stopVideoRecording({
            [unowned self]
            (videoURL, error) -> Void in
            self.timer.invalidate()
            self.cameraManager.resumeCaptureSession()
            SVProgressHUD.show(withStatus: "Saving video")
            
            if let errorText = error?.localizedDescription {
                SVProgressHUD.showError(withStatus: errorText)
            } else if let videoURL = videoURL {
                if self.cameraManager.flashMode == .on {
                    self.cameraManager.flashMode = .off
                }
                self.cameraManager.stopCaptureSession()
                self.process(videoURL, completion: {
                    [unowned self](url, audioUrl) in
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        if let url = url {
                            EditedVideo.shared.videoUrl = url
                            EditedVideo.shared.audioContainerUrl = audioUrl
                            EditedVideo.shared.weeklyTitle = self.yoGifWeeklyTitle
                            
                            let vc = VideoViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                })
            }
        })
        
        if recordedVideoDuration.seconds < 1 {
            cameraManager.resumeCaptureSession()
        }
        print("Video has stoped")
        
        timer.invalidate()
        
        topContainer.alpha = 1
        bottomContainer.alpha = 1
        recordContainer.isHidden = true
        /* MARK: minimum video length feature
         let seconds = Double(cameraManager.recordedDuration.seconds)
         let minSeconds = 1.0
         if let timer = self.timer {
         timer.invalidate()
         }
         if seconds <= minSeconds {
         //            recreateCameraManager()
         cameraManager.stopCaptureSession()
         SVProgressHUD.showError(withStatus: "Tap and hold to record video")
         cameraManager.resumeCaptureSession()
         return
         }
         */
    }
    
    @objc func close() {
        EditedVideo.shared.resetToDefaults()
        self.dismiss(animated: true)
    }
    
    @objc func updateRecordTime() {
        print(cameraManager.recordedDuration.seconds)
        let totalSeconds: Double = cameraManager.recordedDuration.seconds
        let minutes = Int(floor(totalSeconds / 60))
        let seconds = Int(round(totalSeconds.truncatingRemainder(dividingBy:60)))
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        recordTime.text = timeString
        if seconds >= maxVideoLength {
            stopVideo()
        }
        
    }
    
    func dotAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.redDot.alpha = 0
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                self.redDot.alpha = 1
            }, completion: { (_) in
                if !self.recordContainer.isHidden {
                    self.dotAnimation()
                }
            })
        })
    }
    
    func getImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let fileURL = info[UIImagePickerControllerMediaURL] as? URL {
            print(fileURL)
            SVProgressHUD.show(withStatus: "Cropping your video")
            self.process(fileURL, completion: { (url, audioUrl) in
                if let url = url {
                    let vc = VideoViewController()
                    EditedVideo.shared.weeklyTitle = self.yoGifWeeklyTitle
                    EditedVideo.shared.videoUrl = url
                    EditedVideo.shared.audioContainerUrl = audioUrl
                    
                    picker.dismiss(animated: false, completion: {
                        //                        SVProgressHUD.showSuccess(withStatus: "All set and DONE!")
                        SVProgressHUD.dismiss()
                    })
                    vc.title = "EDIT"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func process(_ videoURL: URL, completion: @escaping (_ outputURL : URL?, _ audioURL: URL?) -> ()) {
        
        let inputVideoURL: URL = videoURL
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
        let composition = AVMutableComposition()
        
        
        
        
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
        
        _ = try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, sourceAsset.duration),
                                                       of: sourceVideoTrack, at: kCMTimeZero)
        
        let instructions = QUWatermarkManager.videoCompositionInstructions(for: sourceAsset, track: compositionVideoTrack!)
        
        let transformer = instructions.0
        let instruction = instructions.1
        
        var minLength = sourceVideoTrack.naturalSize.width
        if minLength > sourceVideoTrack.naturalSize.height {
            minLength = sourceVideoTrack.naturalSize.height
        }
        let videoComposition = AVMutableVideoComposition()
        
        videoComposition.renderSize = CGSize(width: minLength, height: minLength)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        export(asset: composition, originalAsset: sourceAsset, composition: videoComposition, completion: completion)
    }
    
    func export(asset: AVMutableComposition, originalAsset: AVURLAsset, composition: AVMutableVideoComposition,
                completion: @escaping (_ outputURL : URL?, _ audioURL: URL?) -> ()) {
        
        func removeFileAtURLIfExists(url: URL) {
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: url.path) {
                do{
                    try fileManager.removeItem(atPath: url.path)
                } catch let error as NSError {
                    print("Couldn't remove existing destination file: \(error)")
                }
            }
        }
        let uniqueVideoID = "removedVideo.mp4"
        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                           FileManager.SearchPathDomainMask.userDomainMask, true).first!
        
        
        let tempPathUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        let croppedOutputFileUrl = tempPathUrl.appendingPathComponent(uniqueVideoID)
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputFileType = AVFileType.mp4
        exporter.outputURL = croppedOutputFileUrl
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = composition
        
        removeFileAtURLIfExists(url: croppedOutputFileUrl)
        exporter.exportAsynchronously(completionHandler:
            {
                switch exporter.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(exporter.error?.localizedDescription ?? "")")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(exporter.error?.localizedDescription ?? "")")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(exporter.error?.localizedDescription ?? "")")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(exporter.error?.localizedDescription ?? "")")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(exporter.error?.localizedDescription ?? "")")
                default:
                    DispatchQueue.main.async(execute: {
                        print("Success")
                        let tempPathStr = URL(fileURLWithPath: tempPath, isDirectory: true)
                        if let path = URL(string: "\(tempPathStr)/audioUn.m4a") {
                            removeFileAtURLIfExists(url: path)
                            originalAsset.writeAudioTrack(to: path, success: { url in
                                completion(croppedOutputFileUrl,url)
                            }, failure: { error in
                                completion(croppedOutputFileUrl, nil)
                            })
                        }
                        
                    })
                }
        })
    }
    
    
}

