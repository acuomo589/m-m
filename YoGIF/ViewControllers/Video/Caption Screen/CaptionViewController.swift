import UIKit
import SVProgressHUD
import AsyncDisplayKit
import FDWaveformView

class CaptionViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    let textSpinnerContainer = UIView()
    let titleTextField = UITextView()
    var titleTextHeight: CGFloat = 50
    var videoTitle: String?
    var player = ASVideoNode()
    
    //var videoUrl, audioUrl, textVideoUrl: URL?
    var videoViewController: VideoViewController?
    
    var audioPlayer: AVAudioPlayer?
    var audioPlayerForNativeAudio: AVAudioPlayer?
    var textDurationSpinnerWidth = NSLayoutConstraint()
    var textDurationLeftConstraint = NSLayoutConstraint()
    var textDurationRightConstraint = NSLayoutConstraint()
    var captionY = NSLayoutConstraint()
    var captionX = NSLayoutConstraint()
    
    var lastDragPosition: CGFloat = 0
    
    var captionLabel = UILabel()
    var captionLocation = CGPoint()
    var captionTextFieldHeightConstraint = NSLayoutConstraint()
    
    let videoContainer = UIView()
    let durationView = UIView()
    let leftArrowView = UIImageView()
    let rightArrowView = UIImageView()
    let durationText = UILabel()
    
    let animatedText = UITextView()
    
    var textDelay: CGFloat = 0 {
        didSet {
            textDurationLeftConstraint.constant = textDelay
            EditedVideo.shared.textDelay = textDelay
        }
    }
    
    var textStopMark: CGFloat = 0 {
        didSet {
            textDurationRightConstraint.constant = textStopMark
            EditedVideo.shared.textStopMark = textStopMark
        }
    }
    
    var textWidth: CGFloat = 140 {
        didSet {
            if textWidth < 130 {
                durationText.text = "slide"
            } else {
                durationText.text = "slide for timing"
            }
            if textWidth < minimumTextDuration {
                textWidth = minimumTextDuration
            }
            textDurationSpinnerWidth.constant = textWidth
            EditedVideo.shared.textDuration = textWidth
        }
    }
    
    var audioDelay: Double = 0
    var minimumTextDuration: CGFloat = 30
    
    let textColorView = UIView()
    var textColor = AppConstants.colorGreen {
        didSet {
            self.captionLabel.textColor = self.textColor
            EditedVideo.shared.captionColor = textColor
        }
    }
    private let timeScale: Int32 = 30
    
    var colors = [
        AppConstants.colorGreen,
        AppConstants.colorRed,
        AppConstants.colorYellow,
        AppConstants.colorDarkBlueBG,
        AppConstants.colorGray,
        AppConstants.colorPink
    ]
    
    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        setupUI()
        if let tabBar = self.navigationController?.tabBarController as? YoTabBarController {
            tabBar.toggleButtonVisibility()
        }
        if let videoTitle = EditedVideo.shared.videoTitle {
            self.titleTextField.text = videoTitle
        }
        NotificationCenter.default.addObserver(self, selector: #selector(CaptionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CaptionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        animatedText.isScrollEnabled = false
        //titleTextField.layoutManager.ensureLayout(for: self.titleTextField.textContainer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //self.textStopMark = textDelay + textWidth - self.textSpinnerContainer.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        animatedText.isScrollEnabled = true
        textDurationRightConstraint = durationView.rightAnchor.constraint(equalTo: textSpinnerContainer.rightAnchor, constant: textDurationSpinnerWidth.constant + textDurationLeftConstraint.constant - textSpinnerContainer.frame.width)
        textDurationRightConstraint.isActive = true
        textStopMark = textDurationRightConstraint.constant
        updateTextCharacteristics()
        playFromBeginning()
        if let videoTitle = EditedVideo.shared.videoTitle {
            self.titleTextField.text = videoTitle
            //print("Title = " + self.titleTextField.text!)
        }
        self.player.muted = EditedVideo.shared.isMuted
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if let tabBar = self.navigationController?.tabBarController as? YoTabBarController {
            tabBar.toggleButtonVisibility()
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Private methods
    private func toggleBottomBar() {
        if let yoTabBar = self.navigationController?.tabBarController as? YoTabBarController {
            yoTabBar.toggleButtonVisibility()
            yoTabBar.tabBar.isHidden = !yoTabBar.tabBar.isHidden
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func previewAnimation() {
        self.captionLabel.alpha = 0
        let seconds = getTextStartAndFinish()
        let duration = seconds.1 - seconds.0
        UIView.animate(withDuration: 0.3, animations: {
            self.captionLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveLinear, animations: {
                self.captionLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    private func updateTextCharacteristics() {
        //if EditedVideo.shared.textIsSet {
            textDurationLeftConstraint.constant = EditedVideo.shared.textDelay
            textDurationRightConstraint.constant = EditedVideo.shared.textStopMark
            textDurationSpinnerWidth.constant = EditedVideo.shared.textDuration
            captionLabel.text = EditedVideo.shared.captionText
            self.textColor = EditedVideo.shared.captionColor
            self.view.layoutIfNeeded()
        //}
    }
    
    //MARK: - Actions
    @objc func nextTapped() {
        EditedVideo.shared.textIsSet = true
        EditedVideo.shared.captionText = captionLabel.text ?? ""
        EditedVideo.shared.textFontSize = getApproximateAdjustedFontSizeWith(label: self.captionLabel)
        EditedVideo.shared.captionHeight = self.captionLabel.frame.height
        self.navigationController?.popViewController(animated: true)
//        if self.videoViewController != nil {
//            if let text = captionLabel.text, text != "" {
//                view.endEditing(true)
//
//                updateVideoText(with: text)
//            }
//        }
    }
    
    var colorCounter = 0
    
    @objc func colorChanged() {
        textColorView.backgroundColor = self.colors[colorCounter]
        self.textColor = self.colors[colorCounter]
        colorCounter += 1
        if colorCounter == colors.count {
            colorCounter = 0
        }
    }
    
    @objc func leftPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: videoContainer).x
        } else if gesture.state == .ended {
            print(getTextStartAndFinish())
            playFromBeginning()
        } else {
            let currentPosition = gesture.location(in: videoContainer).x
            let diff = currentPosition - lastDragPosition
            if textWidth - diff > minimumTextDuration, textDelay + diff > 0 {
                textWidth -= diff
                textDelay += diff
                self.view.layoutIfNeeded()
                lastDragPosition = currentPosition
                return
            }
        }
    }
    
    @objc func rightPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: videoContainer).x
        } else if gesture.state == .ended {
            print(getTextStartAndFinish())
            playFromBeginning()
        } else {
            let currentPosition = gesture.location(in: videoContainer).x
            let diff = currentPosition - lastDragPosition
            if textWidth + diff > minimumTextDuration, textStopMark + diff < 0 {
                textWidth += diff
                textStopMark += diff
                self.view.layoutIfNeeded()
                lastDragPosition = currentPosition
                return
            }
        }
    }
    
    @objc func textDragged(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            lastDragPosition = gesture.location(in: videoContainer).x
        } else {
            let currentPosition = gesture.location(in: videoContainer).x
            let diff = currentPosition - lastDragPosition
            let previousLeftConstant = textDelay
            var newLeftConstant = previousLeftConstant + diff
            if newLeftConstant < 0 {
                newLeftConstant = 0
            }
            let previousRightConstant = textStopMark
            var newRightConstant = previousRightConstant + diff
            if newRightConstant > 0 {
                newRightConstant = 0
            }
            if newRightConstant != 0 {
                textDelay = newLeftConstant
            }
            if newLeftConstant != 0 {
                textStopMark = newRightConstant
            }
            self.view.layoutIfNeeded()
            lastDragPosition = currentPosition
        }
        if gesture.state == .ended {
            playFromBeginning()
        }
    }
    
    @objc func captionDragged(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            captionLocation = sender.location(in: videoContainer)
        } else {
            let currentPosition = sender.location(in: videoContainer)
            let diffX = currentPosition.x - captionLocation.x
            let diffY = currentPosition.y - captionLocation.y
            if abs(captionX.constant + diffX) < abs(sender.view!.superview!.frame.width / 2),
                abs(captionY.constant + diffY) < abs(sender.view!.superview!.frame.height / 2){
                captionX.constant += diffX
                captionY.constant += diffY
                self.view.layoutIfNeeded()
                captionLocation = currentPosition
            }
        }
    }
    
    @objc func goBack() {
        let alertController = UIAlertController(title: "Remove caption?", message: "Are you sure you want to abandon this text?", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            EditedVideo.shared.textIsSet = false
            EditedVideo.shared.captionText = ""
//            if let videoViewController = self.videoViewController {
//                videoViewController.textVideoUrl = nil
//                videoViewController.captionText = nil
//                videoViewController.captionColor = nil
//                videoViewController.textDelay = 0
//                videoViewController.textWidth = 0
//            }
//            if let url = self.videoUrl {
//                self.removeTextFromVideo(url, goBackOnDone: true)
//            }
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { (_) in})
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func getApproximateAdjustedFontSizeWith(label: UILabel) -> CGFloat {
        if label.adjustsFontSizeToFitWidth == true {
            var currentFont: UIFont = label.font
            let originalFontSize = currentFont.pointSize
            var currentSize: CGSize = (label.text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            while currentSize.width > label.frame.size.width && currentFont.pointSize > (originalFontSize * label.minimumScaleFactor) {
                currentFont = currentFont.withSize(currentFont.pointSize - 1)
                currentSize = (label.text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            }
            return currentFont.pointSize
        }
        else {
            return label.font.pointSize
        }
    }
    
    func removeTextFromVideo(_ videoToMuteUrl: URL, goBackOnDone: Bool) {
        
        let inputVideoURL: URL = videoToMuteUrl
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
        let composition : AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let x: CMTimeRange = CMTimeRangeMake(kCMTimeZero, sourceAsset.duration)
        _ = try? compositionVideoTrack!.insertTimeRange(x, of: sourceVideoTrack!, at: kCMTimeZero)
        let mutableVideoURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo.mp4")
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputFileType = AVFileType.mp4
        exporter.outputURL = mutableVideoURL as URL
        removeFileAtURLIfExists(url: mutableVideoURL)
        exporter.exportAsynchronously(completionHandler:
            {
                switch exporter.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: exporter.error))")
                default:
                    print("-----Mutable video exportation complete.")
                    self.removeFileAtURLIfExists(url: videoToMuteUrl)
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: mutableVideoURL.path) {
                        do {
                            try fileManager.moveItem(at: mutableVideoURL, to: videoToMuteUrl)
                        } catch let error as NSError {
                            print("Couldn't move file: \(error)")
                        }
                    }
                    OperationQueue.main.addOperation {
                        if goBackOnDone {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    
                    // 0. remove original
                    // 1. copy to a correct URL
                    // 2. remove temp video
                    // 3. call completion
                }
        })
    }
    
    func removeFileAtURLIfExists(url: URL) {
        let filePath = url.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print("Couldn't remove existing destination file: \(error)")
            }
        }
    }
    
    var previousNumberOfLines = 1//(x: 1000, y: 1000, width: 8, height: 8)
    
    func textViewDidChange(_ textView: UITextView) {
        let maxChars = 240
        if textView.text.count > maxChars {
            textView.text = String(textView.text.prefix(maxChars))
            return
        }
//        captionLabel.text = textView.text
//        let currentNumberOfLines = captionLabel.numberOfVisibleLines
//        print(currentNumberOfLines)
//        if (currentNumberOfLines > previousNumberOfLines) && textView.text.last != "\n" {
//            print("NEWLINE")
//            let lastChar = textView.text.removeLast()
//            textView.text.append("\n")
//            textView.text.append(lastChar)
//            previousNumberOfLines += 1
//        }
//        previousNumberOfLines = captionLabel.numberOfVisibleLines
        captionLabel.text = textView.text
        EditedVideo.shared.captionText = textView.text
        let tempTextView = UITextView()
        tempTextView.font = UIFont(name: "Helvetica", size: 18)
        tempTextView.text = textView.text
        
        let size = tempTextView.sizeThatFits(CGSize(width: textView.bounds.width, height: 9999))
        let minHeight = CGFloat(45)
        let maxHeight = CGFloat(60)
        
        if size.height >= minHeight && size.height <= maxHeight {
            captionTextFieldHeightConstraint.constant = size.height
        } else if size.height > maxHeight {
            captionTextFieldHeightConstraint.constant = maxHeight
        } else {
            captionTextFieldHeightConstraint.constant = minHeight
        }
        self.view.layoutIfNeeded()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.last == "\n" {
            textView.text.removeLast()
        }
        if textView.text.first == "\n" {
            textView.text.removeFirst()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
//            if textView.text.last == "\n" {
//                textView.resignFirstResponder()
//                return false
//            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //textField.resignFirstResponder()
//
////        guard textField.text != nil, textField.text!.count > 0, textField.text?.last != "\n" else {
////            textField.resignFirstResponder()
////            return true
////        }
////        textField.text = textField.text! + "\n"
//        textField.resignFirstResponder()
//        return false
//    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        if text == "\n" {
////            textView.resignFirstResponder()
////            return false
////        }
//        return true
//    }
    
//    private func updateVideoText(with string: String?) {
//        // 1. save video to new location with given text
//        // 2. reload player
//        let wm = QUWatermarkManager()
//        EditedVideo.shared.textEndPoints = getTextStartAndFinish()
//        EditedVideo.shared.textFontSize = getApproximateAdjustedFontSizeWith(label: self.captionLabel)
//        if let videoUrl = EditedVideo.shared.videoUrl, let text = string {
//            let asset = AVURLAsset(url: videoUrl)
//            SVProgressHUD.show(withStatus: "Loading")
//            
//        }
//    }
    
    func getTextStartAndFinish() -> (Double, Double) {
        if let videoUrl = EditedVideo.shared.videoUrl {
            let video = AVURLAsset(url: videoUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
            let videoDuration = Double(CMTimeGetSeconds(video.duration))
            let videoLength = videoContainer.frame.width
            
            let sliderFrame = self.view.convert(durationView.frame, to: videoContainer)
            let start = sliderFrame.origin.x + 10
            let finish = start + sliderFrame.size.width
            let percent = videoLength * 0.01
            let secondsPercent = videoDuration * 0.01
            let startPercent = start / percent
            let endPercent = finish / percent
            
            let startSecond = secondsPercent * Double(startPercent)
            let endSecond = secondsPercent * Double(endPercent)
            EditedVideo.shared.textEndPoints = (startSecond, endSecond)
            return (startSecond, endSecond)
        } else {
            return (0,0)
        }
    }
    
    
    //MARK: - Private methods
    private func playFromBeginning() {
        
        startAudio()
        startNativeAudio()
        EditedVideo.shared.textEndPoints = getTextStartAndFinish()
        let startTime = EditedVideo.shared.textEndPoints.start
        DispatchQueue.main.asyncAfter(deadline: .now() + startTime, execute: {
            self.previewAnimation()
        })
        player.pause()
        player.resetToPlaceholder()
        player.play()
    }
    
//    func playVideo() {
//        if EditedVideo.shared.videoUrl != nil {
//            player.play()
//            startAudio()
//            startNativeAudio()
//        }
//    }
    
    func startNativeAudio() {
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
        if let url = EditedVideo.shared.audioUrl {
            self.player.muted = EditedVideo.shared.isMuted
            if let player = try? AVAudioPlayer(contentsOf: url) {
                player.numberOfLoops = 0
                player.prepareToPlay()
                self.audioPlayer = player
            }
        } else {
            self.player.muted = EditedVideo.shared.isMuted
            self.audioPlayer = nil
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 40
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 40
            }
        }
    }
    
}

extension CaptionViewController: ASVideoNodeDelegate{
    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying == false {
            audioPlayer.stop()
        }
        if let aNativePlayer = self.audioPlayerForNativeAudio, aNativePlayer.isPlaying == false {
            aNativePlayer.stop()
        }
        playFromBeginning()
    }
    
    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        let seconds = Double(timeInterval.remainder(dividingBy: 60))
        let roundedTime = Double(round(1000*EditedVideo.shared.audioDelay)/1000)
        if roundedTime > (seconds - 0.01) && roundedTime < (seconds + 0.01) {
            GeneralMethods.playAudio(player: self.audioPlayer)
        }
        GeneralMethods.playAudio(player: self.audioPlayerForNativeAudio)
    }
    
    func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
        print(error)
    }
}


