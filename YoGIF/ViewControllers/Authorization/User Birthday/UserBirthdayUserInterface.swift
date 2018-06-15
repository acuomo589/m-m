import UIKit

extension UserBirthdayViewController {
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
        header.text = "When were you born?"

        let padding = CGFloat(70)

        let birthdayLabel = UILabel()
        self.view.addSubview(birthdayLabel)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        birthdayLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 55).isActive = true
        birthdayLabel.font = UIFont(name: "Helvetica", size: 16)
        birthdayLabel.textColor = .lightGray
        birthdayLabel.text = "Birthday"

        self.view.addSubview(birthdayField)
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        birthdayField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        birthdayField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 5).isActive = true
        birthdayField.font = UIFont(name: "Helvetica", size: 20)
        birthdayField.textColor = .white
        birthdayField.delegate = self

        let birthdayBorder = UIView()
        self.view.addSubview(birthdayBorder)
        birthdayBorder.translatesAutoresizingMaskIntoConstraints = false
        birthdayBorder.leftAnchor.constraint(equalTo: birthdayField.leftAnchor, constant: 0).isActive = true
        birthdayBorder.rightAnchor.constraint(equalTo: birthdayField.rightAnchor, constant: 0).isActive = true
        birthdayBorder.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: 1).isActive = true
        birthdayBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        birthdayBorder.backgroundColor = AppConstants.colorGreen

        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: padding).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -padding).isActive = true
        button.topAnchor.constraint(equalTo: birthdayBorder.bottomAnchor, constant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppConstants.colorGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 16)

        self.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        picker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 250).isActive = true
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
//        picker.maximumDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())
        self.dateChanged(picker)
    }
}
