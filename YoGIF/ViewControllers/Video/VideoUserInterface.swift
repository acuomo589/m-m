import UIKit
import Player
import UITextView_Placeholder
import AsyncDisplayKit

extension VideoViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue
        self.automaticallyAdjustsScrollViewInsets = false

        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        self.navigationItem.titleView = navHeader

        self.navigationController?.isNavigationBarHidden = false

        let padding = CGFloat(10)
        let button = UIButton()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        //scrollView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        //scrollView.isDirectionalLockEnabled = true
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: GifView.gifViewHeight() - 75)
        //scrollView.addSubview(self.view)

        scrollView.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        videoContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        videoContainer.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -10).isActive = true
        
        //videoContainer.heightAnchor.constraint(equalTo: videoContainer.widthAnchor, constant: 100).isActive = true
        videoContainer.backgroundColor = .white
        videoContainer.layer.cornerRadius = 5
        videoContainer.clipsToBounds = true

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.autocorrectionType = .no
        videoContainer.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 0).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 5).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: -5).isActive = true
        
        
        textHeightConstraint = titleTextField.heightAnchor.constraint(equalToConstant: 60)
        //titleTextField.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        textHeightConstraint.isActive = true

        titleTextField.backgroundColor = .white
        titleTextField.textColor = .black
        titleTextField.font = UIFont(name: "Helvetica", size: 22)
        titleTextField.placeholder = "Add Text"

        titleTextField.delegate = self
        titleTextField.returnKeyType = .default
        titleTextField.isScrollEnabled = true

        titleTextField.textContainer.maximumNumberOfLines = 6
        titleTextField.textContainer.lineBreakMode = .byClipping

        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true

        if UIScreen.main.bounds.height <= 568 {
            button.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 15).isActive = true
            button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        } else {
            button.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 35).isActive = true
            button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
        button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true

        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        button.setTitle("POST", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)

        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            let yoBackButton = UIButton()
            yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            yoBackButton.setImage(#imageLiteral(resourceName: "backArrowWhiteBold"), for: .normal)
            yoBackButton.sizeToFit()
            yoBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            yoBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            yoBackButton.contentHorizontalAlignment = .left
            let myCustomBackButtonItem = UIBarButtonItem(customView: yoBackButton)
            self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        }

        setupPlayer()
        setupMuteButton()
        setupButtons()

    }
    
    @objc func goBack() {
        let alertController = UIAlertController(title: "Remove video?", message: "Are you sure you want to abandon this mīm?", preferredStyle: .alert)

        let removeAction = UIAlertAction(title: "YES", style: .destructive, handler: { (_) in
            let name = EditedVideo.shared.weeklyTitle
            EditedVideo.shared.resetToDefaults()
            EditedVideo.shared.weeklyTitle = name
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(removeAction)

        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: { (_) in})
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func setupPlayer() {
        if let url = EditedVideo.shared.videoUrl {
            self.player = ASVideoNode()
            videoContainer.addSubview(self.player.view)
            
            player.view.translatesAutoresizingMaskIntoConstraints = false
            player.view.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 0).isActive = true
            player.view.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 0).isActive = true
            player.view.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: 0).isActive = true
            player.view.heightAnchor.constraint(equalTo: player.view.widthAnchor, multiplier: 1).isActive = true
            
            player.view.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -30).isActive = true
            
            setupCaption()
            player.view.backgroundColor = AppConstants.emptyVideoHolder
            player.shouldAutoplay = true
            player.shouldAutorepeat = true
            player.muted = true
            player.delegate = self
            player.asset = AVURLAsset(url: url, options: nil)
            player.pause()
            player.resetToPlaceholder()
            videoContainer.bringSubview(toFront: muteButton)
            //self.textViewDidChange(self.titleTextField)
        }
    }

    func setupCaption() {
        let topLayerView = UIView()
        videoContainer.addSubview(topLayerView)
        topLayerView.translatesAutoresizingMaskIntoConstraints = false
        topLayerView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        topLayerView.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor).isActive = true
        topLayerView.rightAnchor.constraint(equalTo: videoContainer.rightAnchor).isActive = true
        topLayerView.leftAnchor.constraint(equalTo: videoContainer.leftAnchor).isActive = true
        topLayerView.backgroundColor = .clear
        topLayerView.addSubview(captionLabel)
        topLayerView.isUserInteractionEnabled = true
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = EditedVideo.shared.captionFont
        captionLabel.numberOfLines = 0
        captionLabel.backgroundColor = .clear
        captionLabel.minimumScaleFactor = 0.5
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.baselineAdjustment = .alignCenters

        captionLabel.textAlignment  = .center
        captionLabel.centerXAnchor.constraint(equalTo: topLayerView.centerXAnchor).isActive = true
        let screenBounds = UIScreen.main.bounds
        captionLabel.bottomAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -20).isActive = true
        captionLabel.heightAnchor.constraint(lessThanOrEqualTo: player.view.heightAnchor, multiplier: 0.95).isActive = true
        captionLabel.widthAnchor.constraint(equalTo: topLayerView.widthAnchor, multiplier: 0.95).isActive = true
        //captionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: <#T##CGFloat#>)
        //captionX.isActive = true
        //captionY.isActive = true
        //let panGesture = UIPanGestureRecognizer()
        //panGesture.addTarget(self, action: #selector(captionDragged(_:)))
        //captionLabel.addGestureRecognizer(panGesture)
    }

    func setupMuteButton() {
        scrollView.addSubview(muteButton)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.topAnchor.constraint(equalTo: player.view.topAnchor, constant: 8).isActive = true
        muteButton.rightAnchor.constraint(equalTo: player.view.rightAnchor, constant: -8).isActive = true
        muteButton.widthAnchor.constraint(equalToConstant: 29).isActive = true
        muteButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        muteButton.addTarget(self, action: #selector(muteButtonTouchUpInside), for: .touchUpInside)
        muteButton.setImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
    }
    
    func setupButtons() {

        let screenHeight = UIScreen.main.bounds.height
        var buttonSize = CGFloat(70)
        if screenHeight <= 568 {
            buttonSize = CGFloat(40)
        }
        
        
        scrollView.addSubview(hashtagButton)
        hashtagButton.translatesAutoresizingMaskIntoConstraints = false
//        if UIScreen.main.bounds.height <= 568 {
//            hashtagButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 86).isActive = true
//        } else {
//            hashtagButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 102).isActive = true
//        }
        hashtagButton.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 15).isActive = true
        hashtagButton.topAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -10).isActive = true
        
        
        
        hashtagButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        hashtagButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        hashtagButton.setTitleColor(.white, for: .normal)
        hashtagButton.backgroundColor = AppConstants.colorGreen
        hashtagButton.layer.cornerRadius = buttonSize * 0.5
        hashtagButton.setImage(#imageLiteral(resourceName: "hashtag"), for: .normal)
        hashtagButton.addTarget(self, action: #selector(hashtagTapped), for: .touchUpInside)

        scrollView.addSubview(textButton)
        textButton.translatesAutoresizingMaskIntoConstraints = false
        textButton.leftAnchor.constraint(equalTo: hashtagButton.rightAnchor, constant: 15).isActive = true
        textButton.centerYAnchor.constraint(equalTo: hashtagButton.centerYAnchor).isActive = true
        textButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        textButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        textButton.setTitleColor(.white, for: .normal)
        textButton.backgroundColor = AppConstants.colorGreen
        textButton.backgroundColor = AppConstants.colorGreen
        textButton.layer.cornerRadius = buttonSize * 0.5
        textButton.setTitle("T", for: .normal)
        textButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
        textButton.setTitleColor(.white, for: .normal)
        //textButton.setImage(#imageLiteral(resourceName: "hashtag"), for: .normal)
        textButton.addTarget(self, action: #selector(addTextTapped), for: .touchUpInside)

        scrollView.addSubview(privateButton)
        privateButton.translatesAutoresizingMaskIntoConstraints = false
        privateButton.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: -15).isActive = true
        privateButton.centerYAnchor.constraint(equalTo: hashtagButton.centerYAnchor).isActive = true
        privateButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        privateButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        privateButton.setTitleColor(.white, for: .normal)
        privateButton.backgroundColor = AppConstants.colorGreen
        privateButton.layer.cornerRadius = buttonSize * 0.5
        privateButton.setImage(#imageLiteral(resourceName: "public"), for: .normal)
        privateButton.addTarget(self, action: #selector(privateTapped), for: .touchUpInside)

        scrollView.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.rightAnchor.constraint(equalTo: privateButton.leftAnchor, constant: -15).isActive = true
        audioButton.centerYAnchor.constraint(equalTo: hashtagButton.centerYAnchor).isActive = true
        audioButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        audioButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        audioButton.setTitleColor(.white, for: .normal)
        audioButton.backgroundColor = AppConstants.colorGreen
        audioButton.layer.cornerRadius = buttonSize * 0.5
        audioButton.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
        audioButton.addTarget(self, action: #selector(audioTapped), for: .touchUpInside)
    }
}
