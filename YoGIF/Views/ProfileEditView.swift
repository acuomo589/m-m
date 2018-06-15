import Foundation
import UIKit

class ProfileEditView: UIView, UITextFieldDelegate {
    
    let container = UIView()
    let nameField = UITextField()
    let usernameField = UITextField()
    let emailField = UITextField()
    let phoneField = UITextField()

    func setup(sv: UIView, top: Int) {
        sv.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: sv.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: sv.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: sv.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: sv.bottomAnchor).isActive = true
        self.backgroundColor = UIColor(white: 0, alpha: 0)

        self.addSubview(container)
        self.container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: sv.topAnchor, constant: CGFloat(top)).isActive = true
        container.centerXAnchor.constraint(equalTo: sv.centerXAnchor, constant: 0).isActive = true
        container.heightAnchor.constraint(equalToConstant: 160).isActive = true
        container.widthAnchor.constraint(equalToConstant: 330).isActive = true
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 2

        let triangle = UIImageView(image: #imageLiteral(resourceName: "triangleTop"))
        triangle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(triangle)
        triangle.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        triangle.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: 27).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: 18).isActive = true
        triangle.contentMode = .scaleAspectFit

        let fieldHeight = CGFloat(36)
        let padding = CGFloat(30)
        let separatorPadding = CGFloat(-1)

        container.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        nameField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        nameField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: padding).isActive = true
        nameField.placeholder = "Your name"
        nameField.font = UIFont(name: "Helvetica", size: 14)
        nameField.delegate = self
        nameField.returnKeyType = .next

        let nameIcon = UIImageView(image: #imageLiteral(resourceName: "editNameIconGray"))
        nameIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 13)
        nameIcon.contentMode = .scaleAspectFit
        nameField.leftView = nameIcon
        nameField.leftViewMode = .always

        let nameSeparator = UIView()
        nameSeparator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(nameSeparator)
        nameSeparator.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        nameSeparator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -padding).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: separatorPadding).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeparator.backgroundColor = .lightGray

        usernameField.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(usernameField)
        usernameField.topAnchor.constraint(equalTo: nameSeparator.topAnchor, constant: 2).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        usernameField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        usernameField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: padding).isActive = true
        usernameField.placeholder = "@username"
        usernameField.font = UIFont(name: "Helvetica", size: 14)
        usernameField.delegate = self
        usernameField.returnKeyType = .next

        let usernameIcon = UIImageView(image: #imageLiteral(resourceName: "editUsernameIcon"))
        usernameIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 13)
        usernameIcon.contentMode = .scaleAspectFit
        usernameField.leftView = usernameIcon
        usernameField.leftViewMode = .always

        let usernameSeparator = UIView()
        usernameSeparator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(usernameSeparator)
        usernameSeparator.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        usernameSeparator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -padding).isActive = true
        usernameSeparator.topAnchor.constraint(
                equalTo: usernameField.bottomAnchor, constant: separatorPadding).isActive = true
        usernameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        usernameSeparator.backgroundColor = .lightGray

        emailField.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: usernameSeparator.topAnchor, constant: 2).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        emailField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        emailField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: padding).isActive = true
        emailField.placeholder = "email@example.com"
        emailField.keyboardType = .emailAddress
        emailField.font = UIFont(name: "Helvetica", size: 14)
        emailField.delegate = self
        emailField.returnKeyType = .next

        let emailIcon = UIImageView(image: #imageLiteral(resourceName: "editEmailIcon"))
        emailIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 13)
        emailIcon.contentMode = .scaleAspectFit
        emailField.leftView = emailIcon
        emailField.leftViewMode = .always

        let emailSeparator = UIView()
        emailSeparator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(emailSeparator)
        emailSeparator.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        emailSeparator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -padding).isActive = true
        emailSeparator.topAnchor.constraint(
                equalTo: emailField.bottomAnchor, constant: separatorPadding).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparator.backgroundColor = .lightGray

        phoneField.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(phoneField)
        phoneField.topAnchor.constraint(equalTo: emailSeparator.topAnchor, constant: 2).isActive = true
        phoneField.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        phoneField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        phoneField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: padding).isActive = true
        phoneField.placeholder = "+1 xxx xxx xx xx"
        phoneField.keyboardType = .phonePad
        phoneField.font = UIFont(name: "Helvetica", size: 14)
        phoneField.delegate = self
        phoneField.returnKeyType = .done

        let phoneIcon = UIImageView(image: #imageLiteral(resourceName: "editPhoneIcon"))
        phoneIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 13)
        phoneIcon.contentMode = .scaleAspectFit
        phoneField.leftView = phoneIcon
        phoneField.leftViewMode = .always

//        let phoneSeparator = UIView()
//        phoneSeparator.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(phoneSeparator)
//        phoneSeparator.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
//        phoneSeparator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -padding).isActive = true
//        phoneSeparator.topAnchor.constraint(
//                equalTo: phoneField.bottomAnchor, constant: separatorPadding).isActive = true
//        phoneSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        phoneSeparator.backgroundColor = .lightGray

        let onTap = UITapGestureRecognizer()
        onTap.addTarget(self, action: #selector(close))
        self.addGestureRecognizer(onTap)
    }

    @objc func close() {
        self.alpha = 0
        self.isHidden = true
        self.removeFromSuperview()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            phoneField.becomeFirstResponder()
        } else {
            close()
        }
        return true
    }
}
