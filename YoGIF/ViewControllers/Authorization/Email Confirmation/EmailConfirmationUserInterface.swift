import UIKit

extension EmailConfirmationViewController {
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
        header.text = "Confirm your email"

        let padding = CGFloat(70)

        let confirmationCode = UILabel()
        self.view.addSubview(confirmationCode)
        confirmationCode.translatesAutoresizingMaskIntoConstraints = false
        confirmationCode.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        confirmationCode.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 55).isActive = true
        confirmationCode.font = UIFont(name: "Helvetica", size: 16)
        confirmationCode.textColor = .lightGray
        confirmationCode.text = "Confirmation code:"

        let iconSize = CGFloat(30)
        let textPadding = (padding + 2 * iconSize + 3)

        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -textPadding).isActive = true
        textField.topAnchor.constraint(equalTo: confirmationCode.bottomAnchor, constant: 5).isActive = true
        textField.font = UIFont(name: "Helvetica", size: 20)
        textField.textColor = AppConstants.colorGreen
        textField.keyboardType = .decimalPad

        let usernameBorder = UIView()
        self.view.addSubview(usernameBorder)
        usernameBorder.translatesAutoresizingMaskIntoConstraints = false
        usernameBorder.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        usernameBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        usernameBorder.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3).isActive = true
        usernameBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        usernameBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
    }
}
