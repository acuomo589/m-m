import UIKit
import Player

extension MediaSyncViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(videoContainer)
        
        let yoBackButton = UIButton()
        yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        yoBackButton.setImage(#imageLiteral(resourceName: "gifDelete"), for: .normal)
        yoBackButton.sizeToFit()
        yoBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        yoBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        yoBackButton.contentHorizontalAlignment = .left
        let myCustomBackButtonItem = UIBarButtonItem(customView: yoBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self , action: #selector(nextTapped))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        
        let padding = CGFloat(10)
        let auddioViewHeight = CGFloat(96)
        
        let audioContainerVisible = UIView()
        self.view.addSubview(audioContainerVisible)
        audioContainerVisible.translatesAutoresizingMaskIntoConstraints = false
        audioContainerVisible.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        audioContainerVisible.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        //audioContainerVisible.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        audioContainerVisible.heightAnchor.constraint(equalToConstant: auddioViewHeight).isActive = true
        audioContainerVisible.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        audioContainerVisible.backgroundColor = .clear
        audioContainerVisible.clipsToBounds = true
        
        let holderView = UIImageView(image: #imageLiteral(resourceName: "audioShifterModal"))
        audioContainerVisible.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.topAnchor.constraint(equalTo: audioContainerVisible.topAnchor, constant: 0).isActive = true
        holderView.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 0).isActive = true
        holderView.rightAnchor.constraint(equalTo: audioContainerVisible.rightAnchor, constant: 0).isActive = true
        holderView.heightAnchor.constraint(equalToConstant: auddioViewHeight).isActive = true
        
        audioContainerVisible.addSubview(audioContainer)
        audioContainer.translatesAutoresizingMaskIntoConstraints = false
        audioContainer.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 10).isActive = true
        audioContainer.rightAnchor.constraint(equalTo: audioContainerVisible.rightAnchor, constant: -10).isActive = true
        audioContainer.bottomAnchor.constraint(equalTo: audioContainerVisible.bottomAnchor, constant: 0).isActive = true
        audioContainer.topAnchor.constraint(equalTo: audioContainerVisible.topAnchor, constant: 32).isActive = true
        audioContainer.backgroundColor = .clear
        
        
        let separator = UIView()
        audioContainer.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leftAnchor.constraint(equalTo: audioContainer.leftAnchor, constant: 0).isActive = true
        separator.rightAnchor.constraint(equalTo: audioContainer.rightAnchor, constant: 0).isActive = true
        separator.backgroundColor = .lightGray
        
//        let separatorLeft = UIView()
//        audioContainer.addSubview(separatorLeft)
//        separatorLeft.translatesAutoresizingMaskIntoConstraints = false
//        separatorLeft.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        separatorLeft.leftAnchor.constraint(equalTo: separator.leftAnchor, constant: 0).isActive = true
//        separatorLeft.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        separatorLeft.backgroundColor = .lightGray
//        separatorLeft.centerYAnchor.constraint(equalTo: separator.centerYAnchor, constant: 0).isActive = true
//
//        let separatorRight = UIView()
//        audioContainer.addSubview(separatorRight)
//        separatorRight.translatesAutoresizingMaskIntoConstraints = false
//        separatorRight.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        separatorRight.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        separatorRight.rightAnchor.constraint(equalTo: separator.rightAnchor, constant: 0).isActive = true
//        separatorRight.backgroundColor = .lightGray
//        separatorRight.centerYAnchor.constraint(equalTo: separator.centerYAnchor, constant: 0).isActive = true

//        self.audioDurationView.backgroundColor = .gray//.white//AppConstants.colorGreen
//        audioContainer.addSubview(audioDurationView)
//        audioDurationView.translatesAutoresizingMaskIntoConstraints = false
//        audioDurationView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 25).isActive = true
//        audioDurationView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -15).isActive = true
//        audioLeft = audioDurationView.leftAnchor.constraint(equalTo: audioContainer.leftAnchor, constant: EditedVideo.shared.audioDelay)
//        audioLeft.isActive = true
////        audioRight = audioDurationView.rightAnchor.constraint(equalTo: audioContainer.rightAnchor, constant: )
////        audioRight.isActive = true
//        audioWidth = audioDurationView.widthAnchor.constraint(equalToConstant: EditedVideo.shared.audioDuration)
//        audioWidth.isActive = true
//        audioDurationView.layer.cornerRadius = 7
//        audioDurationView.clipsToBounds = true

//        audioDurationView.addSubview(leftArrowView)
//        audioDurationView.addSubview(rightArrowView)
//        leftArrowView.translatesAutoresizingMaskIntoConstraints = false
//        rightArrowView.translatesAutoresizingMaskIntoConstraints = false
//        leftArrowView.image = #imageLiteral(resourceName: "leftArrow").withRenderingMode(.alwaysTemplate)
//        rightArrowView.image = #imageLiteral(resourceName: "rightArrow").withRenderingMode(.alwaysTemplate)
//        leftArrowView.tintColor = .white
//        rightArrowView.tintColor = .white
//        leftArrowView.isUserInteractionEnabled = true
//        rightArrowView.isUserInteractionEnabled = true
//        leftArrowView.topAnchor.constraint(equalTo: audioDurationView.topAnchor).isActive = true
//        rightArrowView.topAnchor.constraint(equalTo: audioDurationView.topAnchor).isActive = true
//        leftArrowView.leftAnchor.constraint(equalTo: audioDurationView.leftAnchor).isActive = true
//        rightArrowView.rightAnchor.constraint(equalTo: audioDurationView.rightAnchor).isActive = true
//        leftArrowView.bottomAnchor.constraint(equalTo: audioDurationView.bottomAnchor).isActive = true
//        rightArrowView.bottomAnchor.constraint(equalTo: audioDurationView.bottomAnchor).isActive = true
//        leftArrowView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        rightArrowView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        audioContainer.addSubview(audioView)
        audioView.doesAllowStretch = false
        audioView.translatesAutoresizingMaskIntoConstraints = false
        audioView.topAnchor.constraint(equalTo: audioContainer.topAnchor, constant: 10).isActive = true
        audioView.bottomAnchor.constraint(equalTo: audioContainer.bottomAnchor, constant: -10).isActive = true
//        audioView.leftAnchor.constraint(equalTo: audioContainer.leftAnchor).isActive = true
//        audioView.rightAnchor.constraint(equalTo: audioContainer.rightAnchor).isActive = true
//        audioView.isUserInteractionEnabled = false

        audioLeft = audioView.leftAnchor.constraint(equalTo: audioContainer.leftAnchor)
        audioLeft.isActive = true
        audioWidth = audioView.widthAnchor.constraint(equalToConstant: 0)
        audioWidth.isActive = true
//        audioView.rightAnchor.constraint(equalTo: rightArrowView.leftAnchor).isActive = true


        separator.centerYAnchor.constraint(equalTo: audioView.centerYAnchor).isActive = true

        audioView.wavesColor = AppConstants.colorMimGreen
        audioView.progressColor = AppConstants.colorMimGreen
        
//        let panLeftGesture = UIPanGestureRecognizer()
//        panLeftGesture.addTarget(self, action: #selector(leftPan(_:)))
//        let panRightGesture = UIPanGestureRecognizer()
//        panRightGesture.addTarget(self, action: #selector(rightPan(_:)))
//        leftArrowView.addGestureRecognizer(panLeftGesture)
//        rightArrowView.addGestureRecognizer(panRightGesture)

        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(audioDragged(_:)))
        audioView.addGestureRecognizer(panGesture)
        audioView.isUserInteractionEnabled = true
        
        //        let nextButton = UIButton()
        //        self.view.addSubview(nextButton)
        //        nextButton.translatesAutoresizingMaskIntoConstraints = false
        //        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        //        nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        //        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //        nextButton.backgroundColor = AppConstants.colorGreen
        //        nextButton.layer.cornerRadius = 20
        //        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        //        nextButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        
        
        if #available(iOS 11, *) {
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        }
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: audioContainerVisible.topAnchor, constant: -20).isActive = true
        
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.clipsToBounds = true
        videoContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        videoContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        videoContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        videoContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
        //        videoContainer.bottomAnchor.constraint(equalTo: audioContainer.topAnchor, constant: -30).isActive = true
        videoContainer.backgroundColor = .white
        videoContainer.layer.cornerRadius = 5
        
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 0).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 5).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: -5).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: EditedVideo.shared.titleHeight).isActive = true
        titleTextField.backgroundColor = .white
        titleTextField.textColor = .black
        titleTextField.font = UIFont(name: "Helvetica", size: 22)
        titleTextField.placeholder = ""
        titleTextField.isScrollEnabled = true
        titleTextField.isEditable = false
        titleTextField.returnKeyType = .done
        
        videoContainer.addSubview(self.player.view)
        player.view.translatesAutoresizingMaskIntoConstraints = false
        player.view.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 0).isActive = true
        player.view.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 0).isActive = true
        player.view.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: 0).isActive = true
        player.view.heightAnchor.constraint(equalTo: player.view.widthAnchor, multiplier: 1).isActive = true
        player.view.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -8).isActive = true
        player.view.backgroundColor = .clear
        //        player.view.layer.cornerRadius = 5
        player.view.clipsToBounds = true
        player.shouldAutoplay = true
        player.shouldAutorepeat = true
        player.resetToPlaceholder()
        player.muted = true
        player.delegate = self
        
        setupCaption()
        
        let screenHeight = UIScreen.main.bounds.height
        var buttonSize = CGFloat(70)
        if screenHeight <= 568 {
            buttonSize = CGFloat(50)
        }
        
        let audioButton = UIButton()
        self.view.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor, constant: 0).isActive = true
        audioButton.topAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -10).isActive = true
        audioButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        audioButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        audioButton.setTitleColor(.white, for: .normal)
        audioButton.backgroundColor = AppConstants.colorGreen
        audioButton.layer.cornerRadius = buttonSize * 0.5
        audioButton.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
        self.view.bringSubview(toFront: audioContainerVisible)
        //        audioButton.addTarget(self, action: #selector(audioTapped), for: .touchUpInside)
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
        captionLabel.textColor = EditedVideo.shared.captionColor
        captionLabel.font = EditedVideo.shared.captionFont
        captionLabel.text = ""
        captionLabel.numberOfLines = 0
        captionLabel.minimumScaleFactor = 0.5
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.baselineAdjustment = .alignCenters
        captionLabel.textAlignment  = .center
        captionLabel.isUserInteractionEnabled = true
        //captionLabel.center = CGPoint(x: topLayerView.center.x, y: topLayerView.center.y)
        captionLabel.centerXAnchor.constraint(equalTo: self.player.view.centerXAnchor).isActive = true
        let screenBounds = UIScreen.main.bounds
        captionLabel.bottomAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -20).isActive = true
        captionLabel.heightAnchor.constraint(lessThanOrEqualTo: player.view.heightAnchor, multiplier: 0.95).isActive = true
        captionLabel.widthAnchor.constraint(equalTo: topLayerView.widthAnchor, multiplier: 0.95).isActive = true
        //captionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: <#T##CGFloat#>)
        //captionY.isActive = true
        //let panGesture = UIPanGestureRecognizer()
        //panGesture.addTarget(self, action: #selector(captionDragged(_:)))
        //captionLabel.addGestureRecognizer(panGesture)
    }
}

