import UIKit

extension UserPasswordViewController {
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = AppConstants.colorDarkBlue

        let backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.setImage(#imageLiteral(resourceName: "backArrowWhite"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let header = UILabel()
        self.view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        header.font = UIFont(name: "Helvetica", size: 24)
        header.textColor = AppConstants.colorGreen
        header.text = "Set your password"

        let subtitle = UILabel()
        self.view.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        subtitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        subtitle.font = UIFont(name: "Helvetica", size: 16)
        subtitle.textColor = .white
        subtitle.textAlignment = .center
        if UIScreen.main.nativeBounds.height < 1334 {
            subtitle.text = "Your password should be\nat least 8 characters"
        } else {
            subtitle.text = "Your password should be at least 8 characters"
        }

        subtitle.numberOfLines = 2

        let padding = CGFloat(70)
        let passwordLabel = UILabel()
        self.view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 35).isActive = true
        passwordLabel.font = UIFont(name: "Helvetica", size: 16)
        passwordLabel.textColor = .lightGray
        passwordLabel.text = "Password"

        self.view.addSubview(showButton)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        showButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        showButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        showButton.setTitleColor(.lightGray, for: .normal)
        showButton.setTitle("Show", for: .normal)
        showButton.addTarget(self, action: #selector(showTapped), for: .touchUpInside)

        self.view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        passwordField.rightAnchor.constraint(equalTo: showButton.leftAnchor, constant: -3).isActive = true
        passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5).isActive = true
        passwordField.font = UIFont(name: "Helvetica", size: 20)
        passwordField.textColor = .white
        passwordField.isSecureTextEntry = true

        showButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor, constant: 0).isActive = true

        let passwordBorder = UIView()
        self.view.addSubview(passwordBorder)
        passwordBorder.translatesAutoresizingMaskIntoConstraints = false
        passwordBorder.leftAnchor.constraint(equalTo: passwordField.leftAnchor, constant: 0).isActive = true
        passwordBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        passwordBorder.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 1).isActive = true
        passwordBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passwordBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: passwordBorder.bottomAnchor, constant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
    }
}
