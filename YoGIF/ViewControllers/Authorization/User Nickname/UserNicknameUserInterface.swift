import UIKit

extension UserNicknameViewController {
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = AppConstants.colorDarkBlue
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

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

        let header = UILabel()
        self.view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        header.font = UIFont(name: "Helvetica", size: 24)
        header.textColor = AppConstants.colorGreen
        header.text = "Pick your username"

        let padding = CGFloat(70)

        let usernameLabel = UILabel()
        self.view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 55).isActive = true
        usernameLabel.font = UIFont(name: "Helvetica", size: 16)
        usernameLabel.textColor = .lightGray
        usernameLabel.text = "Username"

        let iconSize = CGFloat(30)
        let textPadding = (padding + 2 * iconSize + 3)

        self.view.addSubview(userNameField)
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        userNameField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -textPadding).isActive = true
        userNameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        userNameField.font = UIFont(name: "Helvetica", size: 20)
        userNameField.textColor = AppConstants.colorGreen
        userNameField.autocorrectionType = .no
        userNameField.autocapitalizationType = .none

        let refreshButton = UIButton()
        self.view.addSubview(refreshButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.centerYAnchor.constraint(equalTo: userNameField.centerYAnchor).isActive = true
        refreshButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        refreshButton.setImage(#imageLiteral(resourceName: "signupRefresh"), for: .normal)
        refreshButton.contentMode = .scaleAspectFit
        refreshButton.addTarget(self, action: #selector(refreshUsername), for: .touchUpInside)

        self.view.addSubview(usernameIcon)
        usernameIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameIcon.centerYAnchor.constraint(equalTo: refreshButton.centerYAnchor).isActive = true
        usernameIcon.rightAnchor.constraint(equalTo: refreshButton.leftAnchor, constant: -3).isActive = true
        usernameIcon.widthAnchor.constraint(equalToConstant: iconSize-8).isActive = true
        usernameIcon.heightAnchor.constraint(equalToConstant: iconSize-8).isActive = true
        usernameIcon.contentMode = .scaleAspectFit
        usernameIcon.backgroundColor = UIColor(white: 0, alpha: 0)

        let usernameBorder = UIView()
        self.view.addSubview(usernameBorder)
        usernameBorder.translatesAutoresizingMaskIntoConstraints = false
        usernameBorder.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        usernameBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        usernameBorder.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 3).isActive = true
        usernameBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        usernameBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: usernameBorder.bottomAnchor, constant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)

        self.view.addSubview(notAvailContainer)
        notAvailContainer.translatesAutoresizingMaskIntoConstraints = false
        notAvailContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        notAvailContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        notAvailContainer.topAnchor.constraint(equalTo: usernameBorder.bottomAnchor, constant: 30).isActive = true
        notAvailContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        notAvailContainer.backgroundColor = AppConstants.colorDarkBlue
        notAvailContainer.layer.borderColor = UIColor.red.cgColor
        notAvailContainer.layer.borderWidth = 1
        notAvailContainer.isHidden = true

        let notAvailLabel = UILabel()
        notAvailContainer.addSubview(notAvailLabel)
        notAvailLabel.translatesAutoresizingMaskIntoConstraints = false
        notAvailLabel.centerXAnchor.constraint(equalTo: notAvailContainer.centerXAnchor, constant: 0).isActive = true
        notAvailLabel.centerYAnchor.constraint(equalTo: notAvailContainer.centerYAnchor, constant: 0).isActive = true
        notAvailLabel.font = UIFont(name: "Helvetica", size: 14)
        notAvailLabel.textColor = .red
        notAvailLabel.text = "That username is not available"
    }
}
