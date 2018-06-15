import UIKit
import BMPlayer
import AVFoundation

extension HowItWorksViewController {
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = AppConstants.colorDarkBlue

        let navHeader = UIView()
        let titleLabel = UILabel()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = self.isYouWon ? "Yo Won!" : "How Mīm Works?"
        self.navigationItem.titleView = navHeader
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil

        

//        self.player.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(player)
//        self.player.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        self.player.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//        self.player.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        self.player.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//
//        BMPlayerConf.shouldAutoPlay = false
//        BMPlayerConf.topBarShowInCase = .none
//
//        player.delegate = self
//
//        player.backBlock = { [unowned self] (isFullScreen) in
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.skipButton.isHidden = false
//            self.playButton.isHidden = false
//        }

        asPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(asPlayer.view)
        asPlayer.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        asPlayer.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        asPlayer.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        asPlayer.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true

        asPlayer.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-20).isActive = true
        asPlayer.view.backgroundColor = .black
        asPlayer.shouldAutoplay = false
        asPlayer.shouldAutorepeat = true
        asPlayer.muted = false
        asPlayer.delegate = self

        let resName = self.isYouWon ? "YouWon" : "howTo"
        guard let path = Bundle.main.path(forResource: resName, ofType:"mov") else {
            debugPrint("video.m4v not found")
            return
        }
        let asset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
        asPlayer.asset = asset

        if self.isYouWon {
            self.navigationController?.navigationBar.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.asPlayer.play()
                self.playButton.isHidden = true
            })
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.playButton.isHidden = false
        }
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skipButton)
        skipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        skipButton.backgroundColor = UIColor(white: 1, alpha: 0.4)
        skipButton.setTitle(self.isYouWon ? "Collect prize" : "Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 24)
        skipButton.layer.cornerRadius = 20
        skipButton.addTarget(self, action: #selector(hide), for: .touchUpInside)

        
        playButton.setImage(#imageLiteral(resourceName: "playButtonHowTo"), for: .normal)
        self.view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    }
}

