import UIKit
import Player
import AsyncDisplayKit

extension CaptionViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        scrollView.addSubview(videoContainer)

        let yoBackButton = UIButton()
        yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        yoBackButton.setImage(#imageLiteral(resourceName: "backArrowWhiteBold"), for: .normal)
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
        let audioViewHeight = CGFloat(66)

        let audioContainerVisible = UIView()
        self.view.addSubview(audioContainerVisible)
        audioContainerVisible.translatesAutoresizingMaskIntoConstraints = false
        audioContainerVisible.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        audioContainerVisible.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        audioContainerVisible.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        audioContainerVisible.heightAnchor.constraint(equalToConstant: audioViewHeight).isActive = true
        audioContainerVisible.backgroundColor = .clear
        audioContainerVisible.clipsToBounds = false

        let holderView = UIImageView(image: #imageLiteral(resourceName: "audioShifterModal"))
        audioContainerVisible.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.topAnchor.constraint(equalTo: audioContainerVisible.topAnchor, constant: -10).isActive = true
        holderView.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 0).isActive = true
        holderView.rightAnchor.constraint(equalTo: audioContainerVisible.rightAnchor, constant: 0).isActive = true
        holderView.heightAnchor.constraint(equalToConstant: audioViewHeight).isActive = true

        audioContainerVisible.addSubview(textSpinnerContainer)
        textSpinnerContainer.translatesAutoresizingMaskIntoConstraints = false
        textSpinnerContainer.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 10).isActive = true
        textSpinnerContainer.rightAnchor.constraint(equalTo: audioContainerVisible.rightAnchor, constant: -10).isActive = true
        textSpinnerContainer.bottomAnchor.constraint(equalTo: audioContainerVisible.bottomAnchor, constant: -5).isActive = true
        textSpinnerContainer.topAnchor.constraint(equalTo: audioContainerVisible.topAnchor, constant: 0).isActive = true
        textSpinnerContainer.backgroundColor = .clear

        let separator = UIView()
        textSpinnerContainer.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leftAnchor.constraint(equalTo: textSpinnerContainer.leftAnchor, constant: 0).isActive = true
        separator.rightAnchor.constraint(equalTo: textSpinnerContainer.rightAnchor, constant: 0).isActive = true
        separator.backgroundColor = .lightGray
        separator.centerYAnchor.constraint(equalTo: holderView.centerYAnchor, constant: 5).isActive = true
        
        let separatorLeft = UIView()
        textSpinnerContainer.addSubview(separatorLeft)
        separatorLeft.translatesAutoresizingMaskIntoConstraints = false
        separatorLeft.heightAnchor.constraint(equalToConstant: 20).isActive = true
        separatorLeft.leftAnchor.constraint(equalTo: separator.leftAnchor, constant: 0).isActive = true
        separatorLeft.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLeft.backgroundColor = .lightGray
        separatorLeft.centerYAnchor.constraint(equalTo: separator.centerYAnchor, constant: 0).isActive = true
        
        let separatorRight = UIView()
        textSpinnerContainer.addSubview(separatorRight)
        separatorRight.translatesAutoresizingMaskIntoConstraints = false
        separatorRight.heightAnchor.constraint(equalToConstant: 20).isActive = true
        separatorRight.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorRight.rightAnchor.constraint(equalTo: separator.rightAnchor, constant: 0).isActive = true
        separatorRight.backgroundColor = .lightGray
        separatorRight.centerYAnchor.constraint(equalTo: separator.centerYAnchor, constant: 0).isActive = true

        textSpinnerContainer.addSubview(durationView)
        durationView.translatesAutoresizingMaskIntoConstraints = false
        durationView.centerYAnchor.constraint(equalTo: separator.centerYAnchor, constant: 0).isActive = true
        durationView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        durationText.translatesAutoresizingMaskIntoConstraints = false
        durationText.text = "slide for timing"
        durationText.textColor = .white
        durationText.font = UIFont.systemFont(ofSize: 13)
        durationView.addSubview(durationText)
        durationText.centerXAnchor.constraint(equalTo: durationView.centerXAnchor).isActive = true
        durationText.centerYAnchor.constraint(equalTo: durationView.centerYAnchor).isActive = true
        
        textDurationLeftConstraint = durationView.leftAnchor.constraint(equalTo: textSpinnerContainer.leftAnchor, constant: EditedVideo.shared.textDelay)
        textDurationLeftConstraint.isActive = true
        textDurationSpinnerWidth = durationView.widthAnchor.constraint(equalToConstant: EditedVideo.shared.textDuration)
        textDurationSpinnerWidth.isActive = true
        
        durationView.backgroundColor = AppConstants.colorGreen
        durationView.layer.cornerRadius = 7
        durationView.clipsToBounds = true
        durationView.addSubview(leftArrowView)
        durationView.addSubview(rightArrowView)
        leftArrowView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowView.translatesAutoresizingMaskIntoConstraints = false
        leftArrowView.image = #imageLiteral(resourceName: "leftArrow").withRenderingMode(.alwaysTemplate)
        rightArrowView.image = #imageLiteral(resourceName: "rightArrow").withRenderingMode(.alwaysTemplate)
        leftArrowView.tintColor = .white
        rightArrowView.tintColor = .white
        leftArrowView.isUserInteractionEnabled = true
        rightArrowView.isUserInteractionEnabled = true
        leftArrowView.topAnchor.constraint(equalTo: durationView.topAnchor).isActive = true
        rightArrowView.topAnchor.constraint(equalTo: durationView.topAnchor).isActive = true
        leftArrowView.leftAnchor.constraint(equalTo: durationView.leftAnchor).isActive = true
        rightArrowView.rightAnchor.constraint(equalTo: durationView.rightAnchor).isActive = true
        leftArrowView.bottomAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        rightArrowView.bottomAnchor.constraint(equalTo: durationView.bottomAnchor).isActive = true
        leftArrowView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightArrowView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(textDragged(_:)))
        durationView.addGestureRecognizer(panGesture)

        let panLeftGesture = UIPanGestureRecognizer()
        panLeftGesture.addTarget(self, action: #selector(leftPan(_:)))
        let panRightGesture = UIPanGestureRecognizer()
        panRightGesture.addTarget(self, action: #selector(rightPan(_:)))
        leftArrowView.addGestureRecognizer(panLeftGesture)
        rightArrowView.addGestureRecognizer(panRightGesture)
        
//        let pinchGesture = UIPinchGestureRecognizer()
//        pinchGesture.addTarget(self, action: #selector(durationChanged(_:)))
//        durationView.addGestureRecognizer(pinchGesture)

        //
        // T E X T   S E T T I N G S
        //
        let textColorSize = CGFloat(40)
        self.view.addSubview(textColorView)
        textColorView.translatesAutoresizingMaskIntoConstraints = false
        textColorView.rightAnchor.constraint(equalTo: textSpinnerContainer.rightAnchor, constant: 0).isActive = true
        textColorView.topAnchor.constraint(equalTo: audioContainerVisible.bottomAnchor, constant: 10).isActive = true
        textColorView.heightAnchor.constraint(equalToConstant: textColorSize).isActive = true
        textColorView.widthAnchor.constraint(equalToConstant: textColorSize).isActive = true
        textColorView.backgroundColor = EditedVideo.shared.captionColor
        textColorView.layer.cornerRadius = textColorSize * 0.5
        textColorView.layer.borderColor = UIColor.white.cgColor
        textColorView.layer.borderWidth = 2
        let colorTap = UITapGestureRecognizer()
        colorTap.addTarget(self, action: #selector(colorChanged))
        textColorView.addGestureRecognizer(colorTap)

//        let textContainer = UIView()
//        self.view.addSubview(textContainer)
//        textContainer.translatesAutoresizingMaskIntoConstraints = false
//        textContainer.backgroundColor = .white
//        textContainer.topAnchor.constraint(equalTo: textSpinnerContainer.bottomAnchor, constant: 10).isActive = true
////        textContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
//        self.captionTextFieldHeightConstraint = textContainer.heightAnchor.constraint(equalToConstant: 30)
//        self.captionTextFieldHeightConstraint.isActive = true
//        textContainer.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 10).isActive = true
//        textContainer.rightAnchor.constraint(equalTo: textColorView.leftAnchor, constant: -20).isActive = true
//        textContainer.layer.cornerRadius = 5

        switch UIScreen.main.bounds.height {
        case 568:
            animatedText.font = UIFont.systemFont(ofSize: 19)
        case 736:
            animatedText.font = UIFont.systemFont(ofSize: 22)
        case 812:
            animatedText.font = UIFont.systemFont(ofSize: 23)
        default:
            animatedText.font = UIFont.systemFont(ofSize: 21)
        }
        
        self.view.addSubview(animatedText)
        animatedText.translatesAutoresizingMaskIntoConstraints = false
        animatedText.leftAnchor.constraint(equalTo: audioContainerVisible.leftAnchor, constant: 0).isActive = true
        animatedText.rightAnchor.constraint(equalTo: textColorView.leftAnchor, constant: -10).isActive = true
        animatedText.topAnchor.constraint(equalTo: audioContainerVisible.bottomAnchor, constant: 10).isActive = true
        self.captionTextFieldHeightConstraint = animatedText.heightAnchor.constraint(equalToConstant: 45)
        animatedText.bottomAnchor.constraint(equalTo/*lessThanOrEqualTo*/: self.view.bottomAnchor, constant: -10).isActive = true
        self.captionTextFieldHeightConstraint.isActive = true
        animatedText.layer.cornerRadius = 5
        animatedText.autocorrectionType = .no
        animatedText.textContainer.maximumNumberOfLines = 4
        animatedText.isScrollEnabled = true
        animatedText.returnKeyType = .done
        animatedText.text = self.captionLabel.text
        animatedText.placeholder = "Animated caption"
        animatedText.delegate = self
        animatedText.text = EditedVideo.shared.captionText
        //animatedText.textAlignment = .center
        animatedText.scrollRangeToVisible(NSMakeRange(0, 0))

        //
        // V I D E O
        //

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
        videoContainer.backgroundColor = .white
        videoContainer.layer.cornerRadius = 5

        videoContainer.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 0).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 5).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: -5).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: EditedVideo.shared.titleHeight).isActive = true
        titleTextField.backgroundColor = .white
        titleTextField.textColor = .black
        titleTextField.font = UIFont.systemFont(ofSize: 22)
        titleTextField.placeholder = ""
        titleTextField.isScrollEnabled = true
        titleTextField.isEditable = false

        setupPlayer()

        _ = UIScreen.main.bounds.height
    }

    func setupPlayer() {
        if let url = EditedVideo.shared.videoUrl {
            self.player = ASVideoNode()
            videoContainer.addSubview(self.player.view)
            player.view.translatesAutoresizingMaskIntoConstraints = false
            player.view.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 0).isActive = true
            player.view.leftAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: 0).isActive = true
            player.view.rightAnchor.constraint(equalTo: videoContainer.rightAnchor, constant: 0).isActive = true
            player.view.heightAnchor.constraint(equalTo: player.view.widthAnchor, multiplier: 1).isActive = true
            player.view.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -8).isActive = true
            //player.view.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -50).isActive = true
            setupCaption()
            player.view.backgroundColor = .clear
            player.view.clipsToBounds = true
            player.shouldAutoplay = true
            player.shouldAutorepeat = true
            player.delegate = self
            player.asset = AVURLAsset(url: url, options: nil)
            player.muted = true
            player.pause()
            player.resetToPlaceholder()
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
        captionLabel.textColor = EditedVideo.shared.captionColor
        captionLabel.font = EditedVideo.shared.captionFont
        captionLabel.numberOfLines = 0
        captionLabel.minimumScaleFactor = 0.5
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.baselineAdjustment = .alignBaselines
        captionLabel.textAlignment  = .center
        captionLabel.isUserInteractionEnabled = true
        //captionLabel.center = CGPoint(x: topLayerView.center.x, y: topLayerView.center.y)
        captionX = captionLabel.centerXAnchor.constraint(equalTo: topLayerView.centerXAnchor)
//        let screenBounds = UIScreen.main.bounds
//        captionLabel.centerYAnchor.constraint(equalTo: player.view.centerYAnchor, constant: screenBounds.height / 6).isActive = true
        captionLabel.widthAnchor.constraint(equalTo: topLayerView.widthAnchor, multiplier: 0.95).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: player.view.bottomAnchor, constant: -20).isActive = true
        captionLabel.heightAnchor.constraint(lessThanOrEqualTo: player.view.heightAnchor, multiplier: 0.95).isActive = true
        //captionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: <#T##CGFloat#>)
        captionX.isActive = true
        //captionY.isActive = true
        //let panGesture = UIPanGestureRecognizer()
        //panGesture.addTarget(self, action: #selector(captionDragged(_:)))
        //captionLabel.addGestureRecognizer(panGesture)
    }
}

