import UIKit

extension FindFriendsViewController {
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = AppConstants.colorDarkBlue
        let padding = CGFloat(70)

        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.setImage(#imageLiteral(resourceName: "backArrowWhite"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.isHidden = true

        self.view.addSubview(photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        photo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        photo.widthAnchor.constraint(equalToConstant: 240).isActive = true
        photo.heightAnchor.constraint(equalToConstant: 240).isActive = true
        photo.layer.cornerRadius = 120
        photo.backgroundColor = .lightGray

        let header = UILabel()
        self.view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        header.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 40).isActive = true
        header.font = UIFont(name: "Helvetica", size: 24)
        header.textColor = AppConstants.colorGreen
        header.text = "Find your friends!"

        let subtitle = UILabel()
        self.view.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        subtitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        subtitle.font = UIFont(name: "Helvetica", size: 16)
        subtitle.textColor = .white
        subtitle.textAlignment = .center
        subtitle.text = "See which of your friends are\nusing Mīm!"
        subtitle.numberOfLines = 2

        let privacyString = "Read our Privacy Policy"
        let privacyText = NSMutableAttributedString(string: privacyString)
        // black font
        privacyText.addAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font: (UIFont(name: "Helvetica", size: 15) ?? UIFont.systemFont(ofSize: 15))
        ], range: NSRange(location: 0, length: privacyString.characters.count))

        // blue font
        privacyText.addAttributes([
            NSAttributedStringKey.foregroundColor: AppConstants.colorBlueText
        ], range: NSRange(location: 9, length: 14))

        let privacyLabel = UILabel()
        self.view.addSubview(privacyLabel)
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 10).isActive = true
        privacyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        privacyLabel.attributedText = privacyText

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(onPrivacyTap))
        privacyLabel.isUserInteractionEnabled = true
        privacyLabel.addGestureRecognizer(gesture)

        let skipButton = UIButton()
        self.view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        skipButton.setTitleColor(.lightGray, for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)

        let button = UIButton()

        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)

    }
}
