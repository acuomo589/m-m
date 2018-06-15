import UIKit
import AsyncDisplayKit
import SVProgressHUD
import RealmSwift

class GifViewSingle: NSObject {
    static let shared = GifViewSingle()
    let gifView = GifView()
}

class GifView: UIView, ASVideoNodeDelegate {

    var viewController: UIViewController?
    let title = UILabel()
    let onVideoTextLabel = UILabel()
    
    let refresh = UIActivityIndicatorView()
    
    let player = ASVideoNode()
    
    let muteButton = UIButton()
    let userName = UIButton()
    let postDate = UILabel()
    let shareButton = UIButton()
    let playIcon = UIButton()
    let playCount = UILabel()
    let bookmarkIcon = UIButton()
    let bookmarkCount = UILabel()
    let dislikeButton = UIButton()
    let dislikesCount = UILabel()
    let likeButton = UIButton()
    let likesCount = UILabel()
    let tags = UITextView()
    var visual: Visual?
    var isFirstTime = true
    var audioDelay: Double = 0
    var showDislikes = false
    var currentGifUuid = String()
    let captionLabel = UILabel()
    var isHaveAudio = false {
        didSet {
            if self.isHaveAudio {
                self.muteButton.isHidden = false
            } else {
                self.muteButton.isHidden = true
            }
        }
    }
    
    
    
    var titleHeight: CGFloat = 0
    
    var muted = false
    {
        didSet {
            player.muted = muted
            if muted {
//                muteButton.setBackgroundImage(#imageLiteral(resourceName: "noSoundIconWhite"), for: .normal)
                muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
            } else {
//                muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundIconWhite"), for: .normal)
                muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
            }
        }
    }


    private final func getWordAtPosition(_ point: CGPoint) -> String?{
        if let textPosition = self.tags.closestPosition(to: point) {
            if let range = self.tags.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: 1) {
                return self.tags.text(in: range)
            }
        }
        return nil
    }
    
    func removePlayer() {
        player.pause()
        player.asset = nil
        player.view.removeFromSuperview()
        player.removeFromSupernode()
    }
    
    //MARK: unkomment book mark when this functionality will come
    func loadVisual(_ visual: Visual) {
        player.asset = nil
        print(visual.filename)
        print(visual.username)
        if muted {
            muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
        } else {
            muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
        }
        
        currentGifUuid = visual.filename
        bookmarkCount.isHidden = true
        if showDislikes {
            dislikeButton.isHidden = false
            dislikesCount.isHidden = false
            //            bookmarkIcon.isHidden = true
            //            bookmarkCount.isHidden = true
        } else {
            dislikeButton.isHidden = true
            dislikesCount.isHidden = true
            //            bookmarkIcon.isHidden = false
            //            bookmarkCount.isHidden = false
        }

        self.layoutIfNeeded()

        if let username = visual.username {
            self.loadImage(visual: visual, username: username)
        }
        print("----1 \(visual.likedByUsers.count) | \(visual.likedByUsers.count)")

        showVisualInfo(visual)

        
        
        if let animText = visual.animText {
            if let animColorDict = NSKeyedUnarchiver.unarchiveObject(with: visual.animColor ?? Data()) as? NSDictionary {
                DispatchQueue.main.asyncAfter(deadline: .now() + visual.animStartAt, execute: {
                    self.animation(text: animText, colorDict: animColorDict, startPoint: visual.animStartAt, endPoint: visual.animEndAt, type: visual.animType, yPosition: visual.animYPoint)
                })
            }
        }
        
        if isFirstTime {
            isFirstTime = false
            visual.incrementViews { error in
                if let error = error {
                    if let vc = self.viewController {
                        _ = SimpleAlert.showAlert(alert: "Incrementing Views Error:" + error, delegate: vc)
                    }
                    print(error)
                } else {
                    print("incemrented views count")
                }
            }
        }

        visual.getInfo {
            [weak self]visual, error in
            if let visual = visual {
                
                let userInfo = ["Visual": visual]
                NotificationCenter.default.post(name: AppConstants.notificationVisualLoaded, object: nil, userInfo: userInfo)
                
                self?.likeButton.isUserInteractionEnabled = true
                self?.dislikeButton.isUserInteractionEnabled = true
                
                
                
                print("----2")
                self?.showVisualInfo(visual)

            } else if let error = error {
                if let vc = self?.viewController {
                    vc.show(failure: error,
                            with:"Somethong went wrong on server" ,
                            actionHandler: {
                                vc.navigationController?.popViewController(animated: true)
                    })
                }
                print(error)
            } else {
                let error = "Unexpected error"
                if let vc = self?.viewController {
                    _ = SimpleAlert.showAlert(alert: "Error (#961MA):" + error, delegate: vc)
                }
                print(error)
            }
        }
    }

    func showVisualInfo(_ visual: Visual) {
        
        if currentGifUuid != visual.filename {
            player.asset = nil
            return
        }
        self.visual = visual
        
        self.title.text = visual.title ?? " "
        self.userName.setTitle(visual.preferredUsername ?? "username", for: .normal)
        self.postDate.text = "posted \(visual.passedTime)"
        dislikesCount.text = String(visual.totalDislikes)
        print("LIKES 5: \(visual.totalLikes)")
        likesCount.text = String(describing: visual.totalLikes)

        playCount.text = String(describing: visual.views)
        var tagsStr = String()
        for tag in visual.tagsArray {
            tagsStr += "#" + tag + " "
        }
        if tagsStr.count > 1 {
            tagsStr = tagsStr.substring(to: tagsStr.index(before: tagsStr.endIndex))
        }
        tags.text = tagsStr

        if let user = User.me() {
            if user.bookmarked.contains(visual) {
                bookmarkIcon.alpha = 1
            } else {
                bookmarkIcon.alpha = 0.5
            }
            if visual.likedByMe() {
                likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLikeLiked"), for: .normal)
            } else {
                likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLike"), for: .normal)
            }
            if visual.dislikedByMe() {
                dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDislikeDisliked"), for: .normal)
            } else {
                dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDisike"), for: .normal)
            }
            self.likeButton.isUserInteractionEnabled = true
            self.dislikeButton.isUserInteractionEnabled = true
        }
    }

    func loadImage(visual: Visual, username: String) {
        if currentGifUuid != visual.filename {
            player.asset = nil
            return
        }

        let filename = visual.filename
        if let file = visual.file() {
            let asset = AVURLAsset(url: file, options: nil)
            player.asset = asset
            self.isHaveAudio = !asset.tracks(withMediaType: AVMediaType.audio).isEmpty
        } else {
            let fd = FileDownloader()
            self.refresh.startAnimating()
            self.refresh.isHidden = false
            fd.downloadAwsVideo(username: username, filename: filename, isPublic: visual.isPublic) { error in
                self.refresh.isHidden = true
                self.refresh.stopAnimating()
                if let error = error {
                    print(error)
                } else {
                    self.loadImage(visual: visual, username: username)
                    //self.downloadAudioAndMakePreviewvisual: visual, username: username)
                }
            }
        }
    }

    private func downloadAudioAndMakePreview(visual: Visual, username: String) {
//        if let audioUid = visual.audioUid {
//            let fd = FileDownloader()
//            fd.downloadAwsAudio(username: username, filename: audioUid, completion: { (error) in
//                if let error = error {
//                    print(error)
//                }
//                self.loadImage(visual: visual, username: username)
//            })
//        } else {
            self.loadImage(visual: visual, username: username)
//        }
    }
    
    private func updateEverything() {
        if let user = User.me(), let visual = visual {
            User.getProfile(user.username) {
                user, error in
                if user != nil {
                    self.loadVisual(visual)
                } else if let error = error, let vc = self.viewController {
                    _ = SimpleAlert.showAlert(alert: "Get Profile Error (#692):" + error, delegate: vc)
                } else {
                    print("failed to update user info")
                }
            }
        }
    }


    //MARK: - Actions
    @objc func muteTapped() {
        muted = !muted
    }
    
    @objc func dislikeTapped() {
        if let visual = visual {
            self.dislikeButton.isUserInteractionEnabled = false
            self.likeButton.isUserInteractionEnabled = false
            if visual.dislikedByMe() {
                self.removeDislikeLocally()

                dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDisike"), for: .normal)
                dislikesCount.text = String(visual.totalDislikes)
                self.dislikeButton.isUserInteractionEnabled = false
                visual.make(operation: .undislike, with: errorHandler(_:))
            } else {
                dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDislikeDisliked"), for: .normal)
                dislikesCount.text = String(visual.totalDislikes + 1)
                if visual.likedByMe() {
                    self.removeLikeLocally()

                    likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLike"), for: .normal)
                    likesCount.text = String(visual.totalLikes)

                    visual.make(operation: .unlike, with: {
                        [unowned self] error in
                        if let error = error {
                            self.likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLikeLiked"), for: .normal)
                            self.likesCount.text = String(visual.totalLikes)
                            self.errorHandler(error)
                        }else{
                            self.markDislikedLocally()
                            visual.make(operation: .dislike, with: self.errorHandler(_:))
                        }
                    })
                }else {
                    self.markDislikedLocally()
                    visual.make(operation: .dislike, with: errorHandler(_:))
                }
            }
        }
    }

    func markLikedLocally() {
        // save like locally, so it will be shown when data will be updated
        if let me = User.me(), let visual = self.visual {
            let realm = try! Realm()
            try! realm.write {
                visual.likedByUsers.append(me)
                visual.totalLikes += 1
                realm.add(visual, update: true)
            }
        }
    }

    func markDislikedLocally() {
        // save like locally, so it will be shown when data will be updated
        if let me = User.me(), let visual = self.visual {
            let realm = try! Realm()
            try! realm.write {
                visual.dislikedByUsers.append(me)
                visual.totalDislikes += 1
                realm.add(visual, update: true)
            }
        }
    }

    func removeLikeLocally() {
        // save like locally, so it will be shown when data will be updated
        if let me = User.me(), let visual = self.visual, let index = visual.likedByUsers.index(of: me) {
            let realm = try! Realm()
            try! realm.write {
                visual.totalLikes -= 1
                visual.likedByUsers.remove(at: index)
                realm.add(visual, update: true)
            }
        }
    }

    func removeDislikeLocally() {
        // save like locally, so it will be shown when data will be updated
        if let me = User.me(), let visual = self.visual, let index = visual.dislikedByUsers.index(of: me) {
            let realm = try! Realm()
            try! realm.write {
                visual.totalDislikes -= 1
                visual.dislikedByUsers.remove(at: index)
                realm.add(visual, update: true)
            }
        }
    }

    @objc func likeTapped() {
        if let visual = visual {
            self.likeButton.isUserInteractionEnabled = false
            self.dislikeButton.isUserInteractionEnabled = false
            if visual.likedByMe() {
                removeLikeLocally()
                likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLike"), for: .normal)
                likesCount.text = String(visual.totalLikes)

                visual.make(operation: .unlike, with: errorHandler(_:))
            } else {
                likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLikeLiked"), for: .normal)
                likesCount.text = String(visual.totalLikes + 1)
                if visual.dislikedByMe() {
                    removeDislikeLocally()
                    dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDisike"), for: .normal)
                    dislikesCount.text = String(visual.totalDislikes)


                    visual.make(operation: .undislike, with: {
                        [unowned self] error in
                        if let error = error {
                            self.dislikesCount.text = String(visual.totalDislikes)
                            self.dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDislikeDisliked"), for: .normal)
                            self.errorHandler(error)
                        }else{
                            self.markLikedLocally()
                            visual.make(operation: .like, with: self.errorHandler(_:))
                        }
                    })
                }else {
                    markLikedLocally()
                    visual.make(operation: .like, with: errorHandler(_:))
                }
            }
        }
    }
    @objc func shareTapped() {
        // check Photos access. If don't have - get, and call func again
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    OperationQueue.main.addOperation {
                        self.shareTapped()
                    }
                } else {}
            })
            return
        }
        if photos == .denied {
            if let vc = self.viewController {
                _ = SimpleAlert.showAlert(alert: "Mīm app does not have access to save images to your Photo Library. You can change it in iOS Settings", delegate: vc)
            }
            return
        }
        let wm = QUWatermarkManager()
        if let _ = self.viewController, let gifTitle = title.text, let assetFile = visual?.file(){
            SVProgressHUD.show(withStatus: "Exporting")
            QUWatermarkManager.addHeight(for: assetFile, text: gifTitle, completion: { (newUrl, videoHeight) in
                
                var asset = AVURLAsset(url: assetFile, options: nil)
                if let newUrl = newUrl {
                    asset = AVURLAsset(url: newUrl, options: nil)
                }
                
                wm.watermark(video: asset, watermarkText: gifTitle, origHeight: videoHeight , imageName: "mimLogo", saveToLibrary: false, watermarkPosition: .topLeft, completion: { (assetExportStatus, assetExport, url) in
                    
                        OperationQueue.main.addOperation {
                            guard let _ = url else {
                                SVProgressHUD.showError(withStatus: assetExport.error?.localizedDescription)
                                return
                            }
                            SVProgressHUD.dismiss(withDelay: 1)
                            SVProgressHUD.showSuccess(withStatus: "Saved to camera roll!")
                        }
                    })

            })

            //MARK: - left old code as people ask
            //            let activityViewController = UIActivityViewController(
            //                activityItems: [text],
            //                applicationActivities: nil)
            //            vc.present(activityViewController, animated: true, completion: {})
        }
    }
    @objc func userNameTapped() {
        if let gif = self.visual, let username = gif.username, let viewController = self.viewController {
            self.player.muted = true
            self.player.pause()
            let vc = ProfileViewController()
            vc.username = username
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func bookmarkTapped() {
        if let visual = visual, let user = User.me() {
            if user.bookmarked.contains(visual) {
                visual.make(operation: .unbookmark, with: errorHandler(_:))
            } else {
                visual.make(operation: .bookmark, with: errorHandler(_:))
            }
        }
    }

    private func errorHandler(_ error: String?) {

        if let error = error, let vc = self.viewController {
            SimpleAlert.showAlert(alert: "Error (#491ER):" + error, delegate: vc)
            self.likeButton.isUserInteractionEnabled = true
            self.dislikeButton.isUserInteractionEnabled = true
        } else {
            self.updateEverything()
        }
    }
    
    @objc func tapOnTextView(_ tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: self.tags)
        if let detectedWord = getWordAtPosition(point) {

            let vc = GifsListViewController()
            vc.moodTag = detectedWord

            if let viewController = self.viewController, let nav = viewController.navigationController {
                nav.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: Animate Text
    func animation(text: String?, colorDict: NSDictionary?, startPoint: Double, endPoint: Double, type: Int, yPosition: Double) {
        
        self.captionLabel.bottomAnchor.constraint(equalTo: player.view.bottomAnchor, constant: CGFloat(yPosition)).isActive = true
        self.captionLabel.alpha = 0
        self.captionLabel.text = text ?? ""
        
        let red = colorDict?["red"] as? CGFloat ?? CGFloat(0)
        let green = colorDict?["green"] as? CGFloat ?? CGFloat(0)
        let blue = colorDict?["blue"] as? CGFloat ?? CGFloat(0)
        let alpha = colorDict?["alpha"] as? CGFloat ?? CGFloat(1)
        
        self.captionLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        let duration = endPoint - startPoint
        
        UIView.animate(withDuration: 0.3, animations: {
            self.captionLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveLinear, animations: {
                self.captionLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    //MARK: VideoNodeDelegate Methods
    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        self.captionLabel.alpha = 0
        
        guard let visual = self.visual else {
            return
        }
        
        if let animColorDict = NSKeyedUnarchiver.unarchiveObject(with: visual.animColor ?? Data()) as? NSDictionary {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + visual.animStartAt) {
                if let text = visual.animText {
                    self.animation(text: text, colorDict: animColorDict, startPoint: visual.animStartAt, endPoint: visual.animEndAt, type: visual.animType, yPosition: visual.animYPoint)
                }
            }
        }
    }

}
