import UIKit

class UserNameViewController: UIViewController, UITextFieldDelegate {
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    var facebookMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.text = UserDefaults.standard.string(forKey: AppConstants.nsudUserFirstName)
        lastNameField.text = UserDefaults.standard.string(forKey: AppConstants.nsudUserLastName)
        
        setupUI()
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameField.becomeFirstResponder()
        print(UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername))
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        if let firstName = firstNameField.text?.trimmingCharacters(in: .whitespaces), firstName.characters.count >= 2 {
            UserDefaults.standard.set(firstName, forKey: AppConstants.nsudUserFirstName)
        } else {
            _ = SimpleAlert.showAlert(alert: "Please enter correct first name", delegate: self)
            return
        }
        if let lastName = lastNameField.text?.trimmingCharacters(in: .whitespaces), lastName.characters.count >= 2 {
            UserDefaults.standard.set(lastName, forKey: AppConstants.nsudUserLastName)
        } else {
            _ = SimpleAlert.showAlert(alert: "Please enter correct last name", delegate: self)
            return
        }

        let vc = UserBirthdayViewController()
        vc.facebookMode = self.facebookMode
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            nextTapped()
        }
        return true
    }
}
