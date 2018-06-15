import UIKit

extension UserNameViewController {
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
        header.text = "Who are you?"

        let padding = CGFloat(70)

        let firstNameLabel = UILabel()
        self.view.addSubview(firstNameLabel)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 55).isActive = true
        firstNameLabel.font = UIFont(name: "Helvetica", size: 16)
        firstNameLabel.textColor = .lightGray
        firstNameLabel.text = "First Name"

        self.view.addSubview(firstNameField)
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        firstNameField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        firstNameField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 5).isActive = true
        firstNameField.font = UIFont(name: "Helvetica", size: 20)
        firstNameField.textColor = .white
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .next
        firstNameField.delegate = self

        let firstNameBorder = UIView()
        self.view.addSubview(firstNameBorder)
        firstNameBorder.translatesAutoresizingMaskIntoConstraints = false
        firstNameBorder.leftAnchor.constraint(equalTo: firstNameField.leftAnchor, constant: 0).isActive = true
        firstNameBorder.rightAnchor.constraint(equalTo: firstNameField.rightAnchor, constant: 0).isActive = true
        firstNameBorder.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 1).isActive = true
        firstNameBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstNameBorder.backgroundColor = AppConstants.colorGreen

        let lastNameLabel = UILabel()
        self.view.addSubview(lastNameLabel)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameBorder.bottomAnchor, constant: 35).isActive = true
        lastNameLabel.font = UIFont(name: "Helvetica", size: 16)
        lastNameLabel.textColor = .lightGray
        lastNameLabel.text = "Last Name"

        self.view.addSubview(lastNameField)
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        lastNameField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        lastNameField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 5).isActive = true
        lastNameField.font = UIFont(name: "Helvetica", size: 20)
        lastNameField.textColor = .white
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .done
        lastNameField.delegate = self

        let lastNameBorder = UIView()
        self.view.addSubview(lastNameBorder)
        lastNameBorder.translatesAutoresizingMaskIntoConstraints = false
        lastNameBorder.leftAnchor.constraint(equalTo: lastNameField.leftAnchor, constant: 0).isActive = true
        lastNameBorder.rightAnchor.constraint(equalTo: lastNameField.rightAnchor, constant: 0).isActive = true
        lastNameBorder.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 1).isActive = true
        lastNameBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lastNameBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: lastNameBorder.bottomAnchor, constant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
    }
}
