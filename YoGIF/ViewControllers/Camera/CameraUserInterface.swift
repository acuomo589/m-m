import UIKit

extension CameraViewController {
    func setupUI() {
        self.view.backgroundColor = .white

        self.view.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        topContainer.backgroundColor = UIColor(white: 0, alpha: 0.5)

        self.view.addSubview(self.cameraView)
        self.cameraView.backgroundColor = .black
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0).isActive = true
        cameraView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        cameraView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        cameraView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1).isActive = true

        self.view.addSubview(bottomContainer)
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        bottomContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        bottomContainer.topAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
//        bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: UIScreen.main.bounds.width).isActive = true
        bottomContainer.backgroundColor = UIColor(white: 0, alpha: 0.5)


        recordButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(recordButton)
        recordButton.isUserInteractionEnabled = true
//        recordButton.alpha = 0.3
        recordButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor, constant: 0).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: 0).isActive = true
        recordButton.setImage(#imageLiteral(resourceName: "recordButton"), for: .normal)
        recordButton.addTarget(self, action: #selector(startVideo), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopVideo), for: .touchUpInside)

        let imageSize = CGFloat(40)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(flashButton)
        flashButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        flashButton.isUserInteractionEnabled = true
//        flashButton.alpha = 0.3
        flashButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        flashButton.centerXAnchor.constraint(
                equalTo: bottomContainer.leftAnchor,
                constant: UIScreen.main.bounds.width * 0.25).isActive = true
        flashButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor, constant: 0).isActive = true
        flashButton.setImage(#imageLiteral(resourceName: "cameraFlash"), for: .normal)
        flashButton.addTarget(self, action: #selector(flashTapped), for: .touchUpInside)

        switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(switchCameraButton)
        switchCameraButton.isUserInteractionEnabled = true
//        switchCameraButton.alpha = 0.3
        switchCameraButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        switchCameraButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        switchCameraButton.centerXAnchor.constraint(
                equalTo: bottomContainer.leftAnchor,
                constant: UIScreen.main.bounds.width * 0.75).isActive = true
        switchCameraButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor, constant: 0).isActive = true
        switchCameraButton.setImage(#imageLiteral(resourceName: "cameraSwitch"), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(cameraSwitchTapped), for: .touchUpInside)


        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        closeButton.leftAnchor.constraint(
                equalTo: topContainer.leftAnchor,
                constant: 20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor, constant: 0).isActive = true
        closeButton.setImage(#imageLiteral(resourceName: "cameraClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        topContainer.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor, constant: 0).isActive = true
        segmentControl.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor, constant: 10).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        segmentControl.segmentControl.insertSegment(withTitle: "Camera", at: 0, animated: false)
        segmentControl.segmentControl.insertSegment(withTitle: "Roll", at: 1, animated: false)
        segmentControl.segmentControl.selectedSegmentIndex = 0
        segmentControl.redraw(animated: false)
        segmentControl.delegate = self
        segmentControl.segmentControl.setTitleTextAttributes(
            [NSAttributedStringKey.foregroundColor: UIColor.white],
                for: .normal)

        self.view.addSubview(recordContainer)
        recordContainer.translatesAutoresizingMaskIntoConstraints = false
        recordContainer.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -10).isActive = true
        recordContainer.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor, constant: -5).isActive = true
        recordContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        recordContainer.isHidden = true

        let dotSize = CGFloat(20)
        recordContainer.addSubview(redDot)
        redDot.translatesAutoresizingMaskIntoConstraints = false
        redDot.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
        redDot.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
        redDot.leftAnchor.constraint(equalTo: recordContainer.leftAnchor).isActive = true
        redDot.centerYAnchor.constraint(equalTo: recordContainer.centerYAnchor).isActive = true
        redDot.backgroundColor = .red
        redDot.layer.cornerRadius = dotSize * 0.5

        recordContainer.addSubview(recordTime)
        recordTime.translatesAutoresizingMaskIntoConstraints = false
        recordTime.leftAnchor.constraint(equalTo: redDot.rightAnchor, constant: 10).isActive = true
        recordTime.centerYAnchor.constraint(equalTo: recordContainer.centerYAnchor).isActive = true
        recordTime.rightAnchor.constraint(equalTo: recordContainer.rightAnchor, constant: 0).isActive = true
        recordTime.textColor = .red
        recordTime.text = "00:00"
    }
}
