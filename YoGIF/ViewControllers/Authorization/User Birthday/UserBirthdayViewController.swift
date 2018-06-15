import UIKit

class UserBirthdayViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    let birthdayField = UITextField()
    private let formatter = DateFormatter()
    let picker = UIDatePicker()
    var facebookMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        formatter.dateFormat = "MMM dd, YYYY"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if let savedDate = UserDefaults.standard.object(forKey: AppConstants.nsudUserBirthday) as? Date{
            picker.date = savedDate
            dateChanged(picker)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        birthdayField.becomeFirstResponder()
        print(UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername))
    }
    
    @objc func dismissPicker() {
        picker.isHidden = true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        picker.isHidden = false
        return false
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        
        if let birthday = birthdayField.text, birthday.isEmpty {
            _ = SimpleAlert.showAlert(alert: "Please enter correct birthday", delegate: self)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"


        UserDefaults.standard.set(dateFormatter.string(from: picker.date),
                                  forKey: AppConstants.nsudUserBirthday)

        let date = picker.date
        if date.age < 12 {
            _ = SimpleAlert.showAlert(alert: "Only 12+ can sign up", delegate: self)
        } else if date.age > 100 {
            _ = SimpleAlert.showAlert(alert: "Please provide correct birthday date", delegate: self)
        }

        if facebookMode {
            let vc = UserNicknameViewController()
            vc.facebookMode = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UserEmailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        birthdayField.text = formatter.string(from: datePicker.date)
    }
}
