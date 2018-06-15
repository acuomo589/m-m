 import UIKit
 fileprivate let controlButtonsSize = CGFloat(22)
 
 extension GifView {
    
    func setup(sv: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        sv.addSubview(self)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        title.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        title.font = UIFont(name: "Helvetica-Light", size: 24)
        title.textColor = .black
        title.text = ""
        title.numberOfLines = 0
        
        player.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(player.view)
        player.view.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        player.view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        player.view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        player.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-20).isActive = true
        player.view.backgroundColor = .black
        player.shouldAutoplay = true
        player.shouldAutorepeat = true
        player.muted = true
        player.delegate = self
        
       // self.captionLabel.frame = CGRect(x: 0, y: 20, width: Double(self.player.view.frame.width), height: Double(self.player.view.frame.height) - 20)
        captionLabel.font = EditedVideo.shared.captionFont
        captionLabel.numberOfLines = 0
        captionLabel.backgroundColor = .clear
        captionLabel.minimumScaleFactor = 0.5
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.baselineAdjustment = .alignCenters
        captionLabel.textAlignment = .center
        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.captionLabel)
        self.bringSubview(toFront: self.captionLabel)
        self.captionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.captionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        //self.captionLabel.topAnchor.constraint(equalTo: player.view.topAnchor, constant: 20).isActive = true
       // self.captionLabel.text = "TEST"
        
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(muteButton)
        muteButton.bottomAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -15).isActive = true
        muteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        muteButton.widthAnchor.constraint(equalToConstant: controlButtonsSize + 7).isActive = true
        muteButton.heightAnchor.constraint(equalToConstant: controlButtonsSize + 7).isActive = true
//        muteButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconSoundMuted"), for: .normal)
        muteButton.setBackgroundImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
        muteButton.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        muteButton.imageView?.contentMode = .scaleAspectFit
        muteButton.isHidden = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userName)
        userName.topAnchor.constraint(equalTo: player.view.bottomAnchor, constant: 5).isActive = true
        userName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        userName.setTitleColor(.black, for: .normal)
        userName.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        userName.addTarget(self, action: #selector(userNameTapped), for: .touchUpInside)
        
        postDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(postDate)
        postDate.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 2).isActive = true
        postDate.leftAnchor.constraint(equalTo: userName.leftAnchor, constant: 0).isActive = true
        postDate.font = UIFont(name: "Helvetica-Light", size: 12)
        postDate.textColor = .gray
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        likeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconLike"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.contentMode = .scaleAspectFit
        likeButton.imageView?.contentMode = .scaleAspectFit
        
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.widthAnchor.constraint(equalToConstant: controlButtonsSize - 2).isActive = true
        dislikeButton.heightAnchor.constraint(equalToConstant: controlButtonsSize - 2).isActive = true
        dislikeButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconDisike"), for: .normal)
        dislikeButton.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        dislikeButton.contentMode = .scaleAspectFit
        dislikeButton.imageView?.contentMode = .scaleAspectFit
        dislikeButton.isHidden = false
        
        bookmarkIcon.translatesAutoresizingMaskIntoConstraints = false
        bookmarkIcon.widthAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        bookmarkIcon.heightAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        bookmarkIcon.setBackgroundImage(#imageLiteral(resourceName: "gifIconBookmark"), for: .normal)
        bookmarkIcon.contentMode = .scaleAspectFit
        bookmarkIcon.isHidden = true
        bookmarkIcon.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        playIcon.widthAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        playIcon.heightAnchor.constraint(equalToConstant: controlButtonsSize).isActive = true
        playIcon.setBackgroundImage(#imageLiteral(resourceName: "gifIconPlay"), for: .normal)
        playIcon.contentMode = .scaleAspectFit
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: controlButtonsSize - 4).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: controlButtonsSize ).isActive = true
        shareButton.setBackgroundImage(#imageLiteral(resourceName: "gifIconShare"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.contentMode = .scaleAspectFit
        
        let controllButtons = UIStackView(arrangedSubviews: [shareButton, bookmarkIcon, playIcon, dislikeButton, likeButton])
        controllButtons.alignment = .fill
        controllButtons.distribution = .fillEqually
        controllButtons.axis = .horizontal
        controllButtons.spacing = 16
        self.addSubview(controllButtons)
        controllButtons.translatesAutoresizingMaskIntoConstraints = false
        controllButtons.topAnchor.constraint(equalTo: player.view.bottomAnchor, constant: 8).isActive = true
        controllButtons.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        
        playCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playCount)
        playCount.topAnchor.constraint(equalTo: playIcon.bottomAnchor, constant: 8).isActive = true
        playCount.centerXAnchor.constraint(equalTo: playIcon.centerXAnchor, constant: 0).isActive = true
        playCount.font = UIFont(name: "Helvetica-Light", size: 12)
        playCount.textColor = .gray
        playCount.text = "0"
        
        likesCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(likesCount)
        likesCount.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        likesCount.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor, constant: 0).isActive = true
        likesCount.font = UIFont(name: "Helvetica-Light", size: 12)
        likesCount.textColor = .gray
        likesCount.text = "0"
        
        dislikesCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dislikesCount)
        dislikesCount.topAnchor.constraint(equalTo: dislikeButton.bottomAnchor, constant: 8).isActive = true
        dislikesCount.centerXAnchor.constraint(equalTo: dislikeButton.centerXAnchor, constant: 0).isActive = true
        dislikesCount.font = UIFont(name: "Helvetica-Light", size: 12)
        dislikesCount.textColor = .gray
        dislikesCount.isHidden = true
        
        bookmarkCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bookmarkCount)
        bookmarkCount.topAnchor.constraint(equalTo: bookmarkIcon.bottomAnchor, constant: 0).isActive = true
        bookmarkCount.centerXAnchor.constraint(equalTo: bookmarkIcon.centerXAnchor, constant: 0).isActive = true
        bookmarkCount.font = UIFont(name: "Helvetica-Light", size: 12)
        bookmarkCount.textColor = .gray
        bookmarkCount.isHidden = true
        
        tags.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tags)
        tags.topAnchor.constraint(equalTo: postDate.bottomAnchor, constant: 10).isActive = true
        tags.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        tags.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        tags.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tags.font = UIFont(name: "Helvetica-Light", size: 14)
        tags.textColor = .black
        tags.text = ""
        tags.isEditable = false
        tags.isSelectable = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        tags.addGestureRecognizer(tapGesture)
        
        self.refresh.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.refresh)
        self.refresh.centerXAnchor.constraint(equalTo: player.view.centerXAnchor).isActive = true
        self.refresh.centerYAnchor.constraint(equalTo: player.view.centerYAnchor).isActive = true
        self.refresh.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.refresh.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    static func gifViewHeight() -> CGFloat {
        //let headerHeight = CGFloat(30)
        print("TITLE HEIGHT")
        let footerView = CGFloat(150)
        return gifHeight() + footerView
    }
    
    static func gifHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        var height = screenHeight * 0.5
        if (screenHeight == 667) {
            // iphone 6
            height = screenHeight * 0.5
        } else if screenHeight == 812 {
            //
            height = screenHeight * 0.415
        }
        if height < 300 {
            height = 300
        }
        return height
    }
    
 }
 
