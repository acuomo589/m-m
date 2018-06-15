import UIKit

extension UserEmailViewController {
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

        self.view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        header.font = UIFont(name: "Helvetica", size: 24)
        header.textColor = AppConstants.colorGreen
        header.text = "What is your email?"

        self.view.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        subtitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        subtitle.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        subtitle.setTitleColor(AppConstants.colorBlueText, for: .normal)
        subtitle.setTitle("Sign up with phone instead", for: .normal)
        subtitle.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        subtitle.isHidden = true

        let padding = CGFloat(70)
        self.view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        textLabel.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 35).isActive = true
        textLabel.font = UIFont(name: "Helvetica", size: 16)
        textLabel.textColor = .lightGray
        textLabel.text = "Email Address"

        self.view.addSubview(phoneCodeLabel)
        phoneCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneCodeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        phoneCodeWidth = phoneCodeLabel.widthAnchor.constraint(equalToConstant: 0)
        phoneCodeWidth.isActive = true
        phoneCodeLabel.text = "+1"
        phoneCodeLabel.font = UIFont(name: "Helvetica", size: 20)
        phoneCodeLabel.textColor = AppConstants.colorBlueText

        self.view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.leftAnchor.constraint(equalTo: phoneCodeLabel.rightAnchor, constant: 0).isActive = true
        emailField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        emailField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
        emailField.font = UIFont(name: "Helvetica", size: 20)
        emailField.textColor = .white
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no

        phoneCodeLabel.centerYAnchor.constraint(equalTo: emailField.centerYAnchor, constant: 0).isActive = true

        let passwordBorder = UIView()
        self.view.addSubview(passwordBorder)
        passwordBorder.translatesAutoresizingMaskIntoConstraints = false
        passwordBorder.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        passwordBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        passwordBorder.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 1).isActive = true
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
