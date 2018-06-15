import UIKit
import SVProgressHUD
import AsyncDisplayKit

class VideoViewController: UIViewController, UITextViewDelegate {

    //MARK: - Properties
    let muteButton = UIButton()
    let audioButton = UIButton()
    let titleTextField = UITextView()
    weak var audioRecordView: AudioDialogView?
    weak var hashtagView: TagDialogView?
    let privateButton = UIButton()
    var player = ASVideoNode()
    var audioPlayer: AVAudioPlayer?
    var audioPlayerForNativeAudio: AVAudioPlayer?
    let scrollView = UIScrollView()
    let hashtagButton = UIButton()
    let textButton = UIButton()
    let titleLabel = UILabel()
    let videoContainer = UIView()
    var lastAudioAdded = false

    var captionLabel = UILabel()

    //var originVideo: URL?
    var visualName: String?
    //var videoUrl: URL?
    //var audioUrl: URL?
    var visual: Visual?
    var isPublic = true {
        didSet {
            if isPublic {
                privateButton.setImage(#imageLiteral(resourceName: "public"), for: .normal)
                privateButton.backgroundColor = AppConstants.colorGreen
                privateButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            } else {
                privateButton.setImage(#imageLiteral(resourceName: "privateIcon"), for: .normal)
                privateButton.backgroundColor = UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1.00)
                privateButton.imageView?.contentMode = .scaleAspectFit
                privateButton.contentMode = .scaleToFill
                //privateButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            }
        }
    }
    var audiosList = [String]()
    //var yoGifWeeklyTitle: String?
    var textHeightConstraint = NSLayoutConstraint()
    
    var isMuted = Bool() {
        didSet {
            EditedVideo.shared.isMuted = isMuted
            if isMuted {
                muteButton.setImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
                self.player.muted = true
                
                //self.audioPlayer?.setVolume(0, fadeDuration: 0)
                self.audioPlayerForNativeAudio?.setVolume(0, fadeDuration: 0)
            } else {
                muteButton.setImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
                self.player.muted = false
                //self.audioPlayer?.setVolume(1, fadeDuration: 0)
                self.audioPlayerForNativeAudio?.setVolume(1, fadeDuration: 0)
            }
        }
    }
    
    var isAudioDialogOnScreend = Bool() {
        didSet {
            if isAudioDialogOnScreend {
                self.audioPlayerForNativeAudio?.setVolume(0, fadeDuration: 0)
                self.player.muted = true
            } else {
                self.audioPlayerForNativeAudio?.setVolume(1, fadeDuration: 0)
                self.player.muted = EditedVideo.shared.isMuted
            }
        }
    }
    
    var isHaveSound = true
    

    private var audiosListUrl = [
        Bundle.main.url(forResource: "Big bang", withExtension: "mp3"),
        Bundle.main.url(forResource: "Caliente!", withExtension: "mp3"),
        Bundle.main.url(forResource: "Clown horn", withExtension: "mp3"),
        Bundle.main.url(forResource: "Crowd Cheer", withExtension: "mp3"),
        Bundle.main.url(forResource: "Emo", withExtension: "mp3"),
        Bundle.main.url(forResource: "Feeling myself", withExtension: "mp3"),
        Bundle.main.url(forResource: "Happy go lucky", withExtension: "mp3"),
        Bundle.main.url(forResource: "Horror", withExtension: "mp3"),
        Bundle.main.url(forResource: "Love scene", withExtension: "mp3"),
        Bundle.main.url(forResource: "Magic moment", withExtension: "mp3"),
        Bundle.main.url(forResource: "Rainfall", withExtension: "mp3"),
        Bundle.main.url(forResource: "Rave", withExtension: "mp3"),
        Bundle.main.url(forResource: "Record scratch", withExtension: "mp3"),
        Bundle.main.url(forResource: "Secret agent", withExtension: "mp3"),
        Bundle.main.url(forResource: "Suspense", withExtension: "mp3"),
        Bundle.main.url(forResource: "Ta Da!", withExtension: "mp3"),
        Bundle.main.url(forResource: "Terrified crowd", withExtension: "mp3"),
        Bundle.main.url(forResource: "Wah wah wah", withExtension: "mp3"),
        Bundle.main.url(forResource: "What a shot", withExtension: "mp3")
    ]
    private var tags = [String]()

    //MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        setupUI()
        self.titleTextField.isUserInteractionEnabled = !(EditedVideo.shared.weeklyTitle != nil)
       // isMuted = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playFromBeginning()
        muteButton.setImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
        self.isMuted = EditedVideo.shared.isMuted
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let visual = self.visual {
            self.isPublic = visual.isPublic
            self.tags = visual.tagsArray
        }
        
        if let currentText = self.titleTextField.text, !currentText.isEmpty {return}
        captionLabel.text = EditedVideo.shared.captionText
        captionLabel.textColor = EditedVideo.shared.captionColor
        if let title = EditedVideo.shared.weeklyTitle {
            self.titleTextField.text = title
            self.titleTextField.placeholder = title
            self.titleTextField.isUserInteractionEnabled = false
        } else {
            titleTextField.text = visualName
            self.titleTextField.isUserInteractionEnabled = true
        }
        if let _ = self.visual {
            // disable Animatino button
            textButton.alpha = 0.3
            hashtagButton.alpha = 0.3

            textButton.isUserInteractionEnabled = false
            hashtagButton.isUserInteractionEnabled = false
        } else {
            textButton.alpha = 1
            textButton.isUserInteractionEnabled = true

            hashtagButton.alpha = 1
            hashtagButton.isUserInteractionEnabled = true
        }
        self.audioPlayer?.setVolume(1, fadeDuration: 0)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hashtagView?.removeFromSuperview()
        hashtagView = nil
        audioRecordView?.removeFromSuperview()
        audioRecordView = nil
        audioPlayer?.stop()
        audioPlayerForNativeAudio?.stop()
        player.resetToPlaceholder()
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen
    }
    
    func uploadVideo(_ url: URL, audioUid: String?, title: String?) {
        SVProgressHUD.dismiss()
        OperationQueue.main.addOperation {
            
            var tagsStr = String()
            let inContest = EditedVideo.shared.weeklyTitle != nil
            for tag in self.tags {
                if tag != self.tags.last {
                    tagsStr += tag + ","
                } else {
                    tagsStr += tag
                }
            }
            if tagsStr.count > 1 {
                tagsStr = String(tagsStr[...tagsStr.index(before: tagsStr.endIndex)])
            }
            let titleText = title ?? " "
            let tagJson: String? = tagsStr.count == 0 ? nil : tagsStr

            if let visual = self.visual {
                self.updateExitingGif(url: url, audioUid: audioUid, title: titleText, tagJson: tagJson, visual: visual)
            } else {
                self.uploadNewGif(url: url, audioUid: audioUid, tagJson: tagJson, titleText: titleText, inContest: inContest)
            }
            
        }
    }

    
    //MARK: Actions
    @objc func postTapped() {
        
        setNativeAudio()
        hideHashtagPopup()
        hideAudioPopup()

        var title: String?
        title = EditedVideo.shared.weeklyTitle ?? self.titleTextField.text ?? ""
        SVProgressHUD.show(withStatus: "Rendering")
        //self.audioPlayer?.setVolume(0, fadeDuration: 0)
        //self.player.pause()
        self.audioPlayerForNativeAudio?.setVolume(0, fadeDuration: 0)
        EditedVideo.shared.renderVideo { (url) in
            self.checkAndUpload(url: url, title: title)
        }
        
    }

    func previewAnimation() {
        self.captionLabel.alpha = 0
        self.captionLabel.text = EditedVideo.shared.captionText
        self.captionLabel.textColor = EditedVideo.shared.captionColor
        let duration = EditedVideo.shared.textEndPoints.end - EditedVideo.shared.textEndPoints.start
        UIView.animate(withDuration: 0.3, animations: {
            self.captionLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveLinear, animations: {
                self.captionLabel.alpha = 0
            }, completion: nil)
        }
    }

    func hideHashtagPopup() {
        if let hashtagView = hashtagView {
            privateButton.isHidden = false
            audioButton.isHidden = false
            textButton.isHidden = false
            hashtagView.removeFromSuperview()
            self.hashtagView = nil
        }
    }

    func hideAudioPopup() {
        if let audioRecordView = audioRecordView {
            privateButton.isHidden = false
            hashtagButton.isHidden = false
            textButton.isHidden = false
            audioRecordView.removeFromSuperview()
            isAudioDialogOnScreend = false
            self.audioRecordView = nil
        }
    }

    @objc func hashtagTapped() {
        audioRecordView?.removeFromSuperview()
        audioRecordView = nil
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen

        if hashtagView != nil {
            hideHashtagPopup()
        } else {
            privateButton.isHidden = true
            audioButton.isHidden = true
            textButton.isHidden = true
            self.navigationController?.navigationBar.barTintColor = AppConstants.editNavGrayColor
            let temp = TagDialogView()
            temp.setup(sv: self.view, anchorTo: audioButton, delegate: self, tags: self.tags)
            hashtagView = temp
        }
    }

    @objc func addTextTapped() {
        let captionVC = CaptionViewController()
        //        captionVC.videoUrl = self.videoUrl
        //        captionVC.audioUrl = self.audioUrl
        //        captionVC.textVideoUrl = nil
        //        captionVC.videoTitle = self.titleTextField.text
        //        captionVC.videoViewController = self
        //        if self.captionColor != nil {
        //            captionVC.textColor = self.captionColor!
        //        }
        //        if self.captionText != nil {
        //            captionVC.captionLabel.text = self.captionText
        //        }
        EditedVideo.shared.titleHeight = textHeightConstraint.constant
        self.navigationController?.pushViewController(captionVC, animated: true)
    }

    @objc func audioTapped() {

        hashtagView?.removeFromSuperview()
        hashtagView = nil

        EditedVideo.shared.titleHeight = textHeightConstraint.constant
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen

        if let _ = audioRecordView {
            hideAudioPopup()
        } else if let url = EditedVideo.shared.audioUrl {
            // user already has audio added, go to Sync screen
            onSaveRecord(url: url)
        } else {
            // show "Add Audio Dialog"
            self.navigationController?.navigationBar.barTintColor = AppConstants.editNavGrayColor
            privateButton.isHidden = true
            hashtagButton.isHidden = true
            textButton.isHidden = true
            isAudioDialogOnScreend = true
            let audioDialog = AudioDialogView()
            audioDialog.add(to: self.view, anchorTo: audioButton, delegate: self,
                            files: nil, localFiles: self.audiosListUrl)
            audioRecordView = audioDialog
        }

    }

    func onSaveRecord(url: URL) {
        
        if EditedVideo.shared.videoUrl != nil {
            hideAudioPopup()
            player.pause()
            player.resetToPlaceholder()
            // show media sync controller
            EditedVideo.shared.audioUrl = url
            let vc = MediaSyncViewController()
            //            vc.audioDelay = EditedVideo.shared.audioDelay//self.audioDelay
            //            vc.audioUrl = url
            //            vc.videoUrl = textVideoUrl ?? videoUrl

            //            vc.videoViewController = self
            //vc.videoTitle = self.titleTextField.text
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @objc func muteButtonTouchUpInside() {
        isMuted = !isMuted
    }
    
    @objc func privateTapped() {
        if EditedVideo.shared.weeklyTitle != nil {
            SimpleAlert.showAlert(title: "Nope!", alert: "Mīm Weekly posts can't be private", delegate: self)
            return
        }
        
        isPublic = !isPublic
    }

    //MARK: TextView
    func textViewDidChange(_ textView: UITextView) {
        if EditedVideo.shared.weeklyTitle != nil {
            textView.text = EditedVideo.shared.weeklyTitle
            return
        }
        var str = textView.text ?? ""
        str = str.trimmingCharacters(in: CharacterSet.newlines)
        while let rangeToReplace = str.range(of: "\n") {
            str.replaceSubrange(rangeToReplace, with: "")
        }
        textView.text = str
        
        let maxChars = 140
        if textView.text.count > maxChars {
            textView.text = String(textView.text.prefix(maxChars))
            return
        }

        EditedVideo.shared.videoTitle = textView.text
        let tempTextView = UITextView()
        tempTextView.font = UIFont(name: "Helvetica", size: 22)
        tempTextView.text = textView.text

        let height = tempTextView.text.height(withConstrainedWidth: textView.bounds.width, font: UIFont(name: "Helvetica", size: 22)!) + 20//sizeThatFits(CGSize(width: textView.bounds.width, height: 9999))
        let minHeight = CGFloat(60)
        let maxHeight = CGFloat(250)

        if height >= minHeight {
            textHeightConstraint.constant = height
        }/* else if size.height > maxHeight {
            textHeightConstraint.constant = maxHeight
        }*/ else {
            textHeightConstraint.constant = minHeight
        }
        self.view.layoutIfNeeded()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: Playing Audio/Video
    private func playFromBeginning() {
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

    func playVideo() {
        if EditedVideo.shared.videoUrl != nil {
            player.play()
            startAudio()
            startNativeAudio()
        }
    }
    

    func startNativeAudio() {
        if let url = EditedVideo.shared.audioContainerUrl {
            do {
                self.audioPlayerForNativeAudio = try AVAudioPlayer(contentsOf: url)
                if let aPlayer = self.audioPlayerForNativeAudio {
                    aPlayer.numberOfLoops = 0
                    aPlayer.prepareToPlay()
                    if self.isMuted {
                        aPlayer.setVolume(0, fadeDuration: 0)
                    } else {
                        if isAudioDialogOnScreend {
                            aPlayer.setVolume(0, fadeDuration: 0)
                        } else {
                            aPlayer.setVolume(1, fadeDuration: 0)
                        }
                        
                    }
                }
            } catch {
                
            }
        } else {
            self.audioPlayerForNativeAudio = nil
        }
        self.player.muted = self.isMuted
        if isAudioDialogOnScreend {
            self.player.muted = true
        }
    }
    
    func startAudio() {
        if let url = EditedVideo.shared.audioUrl {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                if let aPlayer = self.audioPlayer {
                    aPlayer.numberOfLoops = 0
                    aPlayer.prepareToPlay()
                    aPlayer.setVolume(1, fadeDuration: 0)
                    if self.isMuted {
                        //aPlayer.setVolume(0, fadeDuration: 0)
                    } else {
                        //aPlayer.setVolume(1, fadeDuration: 0)
                    }
                }
            } catch {
                
            }
        } else {
            self.player.muted = self.isMuted
            self.audioPlayer = nil
        }
    }
}

extension VideoViewController: ASVideoNodeDelegate {
    //MARK: Video Node Delegate
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
        //        print("Audio delay: \(EditedVideo.shared.audioDelay)")
        let roundedTime = Double(round(1000*EditedVideo.shared.audioDelay)/1000)
        //        let endTime = Double(round(1000*EditedVideo.shared.audioStopMark)/1000)
        if roundedTime > (seconds - 0.01) && roundedTime < (seconds + 0.01) {
            GeneralMethods.playAudio(player: self.audioPlayer)
        }
        GeneralMethods.playAudio(player: self.audioPlayerForNativeAudio)
        //        if endTime > (seconds - 0.01) && endTime < (seconds + 0.01) {
        //            self.audioPlayer?.stop()
        //        }
    }

    
    func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
        print(error)
    }
}

extension VideoViewController {
    
    //MARK: Helper Methods
    
    func saveTags(_ tags: [String]) {
        self.tags = tags
    }
    
    func gifEditUploadNew(url: URL, audioUid: String?, title: String, tagJson: String?) {
        
        SVProgressHUD.show(withStatus: "Uploading")
        let inContest = EditedVideo.shared.weeklyTitle != nil
        
        Visual.make(.create,
                    url,
                    nil,
                    visual: self.visualForPost(audioUid: audioUid, tagJson: tagJson, titleText: title),
                    isPublic: self.isPublic,
                    inContest: inContest,
                    completionHandler: {
                        [unowned self](visual, error) in
                        SVProgressHUD.dismiss()
                        if let _ = visual {
                            UserDefaults.standard.set(true, forKey: AppConstants.gifUploadedUD)
                            EditedVideo.shared.resetToDefaults()
                            self.navigationController?.popViewController(animated: true)
                        } else if let error = error {
                            SimpleAlert.showAlert(alert: "GIF Update Error (#882):" + error, delegate: self)
                        } else {
                            SimpleAlert.showAlert(alert: "GIF Upload: Unexpected error #019", delegate: self)
                        }
        })
    }
    
    func gifEditUpdate(url: URL, audioUid: String?, tagJson: String?, filename: String?) {
        SVProgressHUD.show(withStatus: "Uploading")
        let inContest = EditedVideo.shared.weeklyTitle != nil
        
        Visual.make(.create,
                    url,
                    filename,
                    visual: self.visualForPost(audioUid: audioUid, tagJson: tagJson, titleText: self.titleTextField.text ?? ""),
                    isPublic: self.isPublic,
                    inContest: inContest,
                    completionHandler: {
                        [unowned self] (visual, error) in
                        // upload Audio
                        if visual != nil {
                            SVProgressHUD.dismiss()
                            EditedVideo.shared.resetToDefaults()
                            
                            self.navigationController?.popViewController(animated: true)
                        } else if let error = error {
                            SVProgressHUD.dismiss()
                            _ = SimpleAlert.showAlert(alert: "GIF Update Error (#881):" + error, delegate: self)
                        } else {
                            SVProgressHUD.dismiss()
                            _ = SimpleAlert.showAlert(alert: "GIF Update: Unexpected error #018", delegate: self)
                        }
        })
    }
    
    func uploadNewGif(url: URL, audioUid: String?, tagJson: String?, titleText: String, inContest: Bool) {
        
        SVProgressHUD.show(withStatus: "Uploading")
        
        
        Visual.make(.create,
                    url,
                    nil,
                    visual: self.visualForPost(audioUid: audioUid, tagJson: tagJson, titleText: titleText),
                    isPublic: self.isPublic,
                    inContest: inContest,
                    completionHandler: { (visual, error) in
                        SVProgressHUD.dismiss()
                        if let visual = visual {
                            UserDefaults.standard.set(true, forKey: AppConstants.gifUploadedUD)
                            if EditedVideo.shared.weeklyTitle != nil {
                                EditedVideo.shared.resetToDefaults()
                                self.dismiss(animated: true, completion: {
                                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                                    let viewController = appDelegate.window!.rootViewController
                                    SimpleAlert.showInviteOffer(.likePost,
                                                                videoUid: visual.filename,
                                                                message: "Invite friends to like your post!",
                                                                delegate: viewController!,
                                                                dismissAfter: true)
                                })
                            } else {
                                EditedVideo.shared.resetToDefaults()
                                self.dismiss(animated: true)
                            }
                        } else if let error = error {
                            SimpleAlert.showAlert(alert: "GIF Update Error (#882):" + error, delegate: self)
                        } else {
                            SimpleAlert.showAlert(alert: "GIF Upload: Unexpected error #019", delegate: self)
                        }
        })
    }
    
    func updateExitingGif(url: URL, audioUid: String?, title: String, tagJson: String?, visual: Visual) {
        SimpleAlert.showAlert(title: "", alert: "Your changes will be uploaded as new GIF", actionTitles: "Cancel","OK", delegate: self, callback: { actionTag in
        
            switch actionTag {
            case 1:
                self.gifEditUploadNew(url: url, audioUid: audioUid, title: title, tagJson: tagJson)
            case 0:
                break//self.gifEditUpdate(url: url, audioUid: audioUid, tagJson: tagJson, filename: visual.filename)
            default:
                break
            }
        })
    }
    
    func checkAndUpload(url: URL?, title: String?) {
        if url != nil {
            //if let audioUrl = EditedVideo.shared.audioUrl {
                
//                if self.visual != nil {
//                    Audio.updateAudio(audioUrl, isPublic: self.isPublic) { audio, audioError in
//
//                        if let audio = audio {
//                            self.uploadVideo(url!, audioUid: audio, title: title)
//                        } else if let audioError = audioError {
//
//                            SVProgressHUD.dismiss()
//                            SimpleAlert.showAlert(alert: "Audio Update: Unexpected error #017" + audioError, delegate: self)
//                        } else {
//
//                            SVProgressHUD.dismiss()
//                            SimpleAlert.showAlert(alert: "Audio Update: Unexpected error #014", delegate: self)
//                        }
//                    }
//                } else {
//                    // create new audio
//                    Audio.uploadAudio(audioUrl, isPublic: self.isPublic) { audio, audioError in
//
//                        if let audio = audio {
//                            self.uploadVideo(url!, audioUid: audio, title: title)
//                        } else if let audioError = audioError {
//
//                            SVProgressHUD.dismiss()
//                            SimpleAlert.showAlert(alert: "Audio Upload: Unexpected error #042" + audioError, delegate: self)
//                        } else {
//
//                            SVProgressHUD.dismiss()
//                            SimpleAlert.showAlert(alert: "Audio Upload: Unexpected error #819", delegate: self)
//                        }
//                    }
//                }
           // } else {
                self.uploadVideo(url!, audioUid: nil, title: title)
           // }
        }
    }
    
    func visualForPost(audioUid: String?, tagJson: String?, titleText: String) -> Visual {
        
        let visualForPost = Visual()
        visualForPost.audioMuted = self.isMuted
        visualForPost.audioUid = audioUid
        visualForPost.audioDelay = Double(EditedVideo.shared.audioDelay)
        visualForPost.title = titleText
        visualForPost.tags = tagJson
        //visualForPost.permission = self.isPublic ? "shared" : "private"
        /*
         if let animTxt = self.captionLabel.text {
         visualForPost.animYPoint = Double((self.captionLabel.frame.origin.y) - self.player.view.frame.height)
         visualForPost.animText = animTxt
         visualForPost.animType = 0
         visualForPost.animStartAt = EditedVideo.shared.textEndPoints.start
         visualForPost.animEndAt = EditedVideo.shared.textEndPoints.end
         
         let color = self.captionLabel.textColor
         let colorArray = color?.rgb() ?? [0,0,0,0]
         let colorDict: NSMutableDictionary = ["red": colorArray[0],"green": colorArray[1], "blue": colorArray[2], "alpha": colorArray[3]]
         let colorData = NSKeyedArchiver.archivedData(withRootObject: colorDict)
         
         visualForPost.animColor = colorData
         }*/
        
        return visualForPost
    }
    
    func setNativeAudio() {
        if let _ = EditedVideo.shared.audioUrl {
            
        } else {
            if !self.isMuted {
                EditedVideo.shared.audioUrl = EditedVideo.shared.audioContainerUrl
            }
        }
    }
}

