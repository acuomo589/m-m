import UIKit
import SVProgressHUD

class UserEmailViewController: UIViewController {
    let emailField = UITextField()
    let subtitle = UIButton()
    let header = UILabel()
    let textLabel = UILabel()
    let phoneCodeLabel = UILabel()
    var phoneCodeWidth = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardOnTap()
        emailField.text = UserDefaults.standard.string(forKey: AppConstants.nsudUserEmail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
        print(UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername))
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        
        if let text = emailField.text {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: text) {
                UserDefaults.standard.set(text, forKey: AppConstants.nsudUserEmail)
                UserDefaults.standard.set("+380980111111", forKey: AppConstants.nsudUserPhone)
                let vc = UserPasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }






    }

    @objc func switchMode() {
        if phoneCodeWidth.constant == 0 {
            // show phone
            phoneCodeWidth.constant = 25
            header.text = "What is your phone number?"
            subtitle.setTitle("Sign up with email instead", for: .normal)
            textLabel.text = "Phone Number"
            emailField.keyboardType = .numberPad
        } else {
            // show email
            phoneCodeWidth.constant = 0
            header.text = "What is your email?"
            subtitle.setTitle("Sign up with phone instead", for: .normal)
            textLabel.text = "Email Address"
            emailField.keyboardType = .emailAddress
        }
        self.view.layoutIfNeeded()
    }
}
