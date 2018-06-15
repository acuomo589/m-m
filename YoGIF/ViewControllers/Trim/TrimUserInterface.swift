import UIKit
import AsyncDisplayKit
import PryntTrimmerView

extension TrimViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        background.backgroundColor = .lightGray
        background.image = #imageLiteral(resourceName: "loginBg")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true

        let container = UIView()
        self.view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        container.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6).isActive = true
        container.backgroundColor = .white
        container.layer.cornerRadius = 6

        player.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(player.view)
        player.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        player.view.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        player.view.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        player.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        player.view.backgroundColor = .white
        player.shouldAutoplay = true
        player.shouldAutorepeat = true
        player.muted = true

        self.view.addSubview(trimmer)
        trimmer.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        trimmer.translatesAutoresizingMaskIntoConstraints = false
        trimmer.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        trimmer.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        trimmer.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20).isActive = true
        trimmer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        trimmer.delegate = self

        trimmer.handleColor = .white
        trimmer.mainColor = AppConstants.colorGreen
        trimmer.positionBarColor = UIColor(white: 0, alpha: 0)
    }
}
