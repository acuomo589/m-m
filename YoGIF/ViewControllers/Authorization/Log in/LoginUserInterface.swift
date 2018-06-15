import UIKit

extension LoginViewController {
    func setupUI() {
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
        header.text = "Who are you?"

        let padding = CGFloat(70)

        let usernameLabel = UILabel()
        self.view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 55).isActive = true
        usernameLabel.font = UIFont(name: "Helvetica", size: 16)
        usernameLabel.textColor = .lightGray
        usernameLabel.text = "Username"

        self.view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        usernameField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        usernameField.font = UIFont(name: "Helvetica", size: 20)
        usernameField.textColor = .white
        usernameField.autocapitalizationType = .none

        let usernameBorder = UIView()
        self.view.addSubview(usernameBorder)
        usernameBorder.translatesAutoresizingMaskIntoConstraints = false
        usernameBorder.leftAnchor.constraint(equalTo: usernameField.leftAnchor, constant: 0).isActive = true
        usernameBorder.rightAnchor.constraint(equalTo: usernameField.rightAnchor, constant: 0).isActive = true
        usernameBorder.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 1).isActive = true
        usernameBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        usernameBorder.backgroundColor = AppConstants.colorGreen

        let passwordLabel = UILabel()
        self.view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: usernameBorder.bottomAnchor, constant: 35).isActive = true
        passwordLabel.font = UIFont(name: "Helvetica", size: 16)
        passwordLabel.textColor = .lightGray
        passwordLabel.text = "Password"

        self.view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        passwordField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5).isActive = true
        passwordField.font = UIFont(name: "Helvetica", size: 20)
        passwordField.textColor = .white
        passwordField.isSecureTextEntry = true

        let passwordBorder = UIView()
        self.view.addSubview(passwordBorder)
        passwordBorder.translatesAutoresizingMaskIntoConstraints = false
        passwordBorder.leftAnchor.constraint(equalTo: passwordField.leftAnchor, constant: 0).isActive = true
        passwordBorder.rightAnchor.constraint(equalTo: passwordField.rightAnchor, constant: 0).isActive = true
        passwordBorder.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 1).isActive = true
        passwordBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passwordBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: passwordBorder.bottomAnchor, constant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
    }
}
