import UIKit
import SVProgressHUD

class UserPasswordViewController: UIViewController {

    let passwordField = UITextField()
    let showButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardOnTap()
        passwordField.text = UserDefaults.standard.string(forKey: AppConstants.nsudUserPassword)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordField.becomeFirstResponder()
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        if let text = passwordField.text {
            if text.characters.count < 8 {
                _ = SimpleAlert.showAlert(alert: "Password should contain at least 8 characters", delegate: self)
                return
            }
//            let capitalLetterRegEx  = ".*[A-Z]+.*"
//            var regexp = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
//            var regexpResult = regexp.evaluate(with: text)
//            if regexpResult == false {
//                _ = SimpleAlert.showAlert(
//                    alert: "Password should contain at least one capital character", delegate: self)
//                return
//            }
//            let symbolLetterRegEx  = ".*[!&^%$#@()/]+.*"
//            regexp = NSPredicate(format:"SELF MATCHES %@", symbolLetterRegEx)
//            regexpResult = regexp.evaluate(with: text)
//            if regexpResult == false {
//                _ = SimpleAlert.showAlert(
//                    alert: "Password should contain at least one special character", delegate: self)
//                return
//            }
            UserDefaults.standard.set(text, forKey: AppConstants.nsudUserPassword)

            SVProgressHUD.show(withStatus: "Loading")
            User.signup { error in
                SVProgressHUD.dismiss()
                if let error = error {
                    _ = SimpleAlert.showAlert(alert: "Signup Error: " + error, delegate: self)
                } else {
                    let vc = EmailConfirmationViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

    }

    @objc func showTapped() {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        if passwordField.isSecureTextEntry {
            showButton.setTitle("Show", for: .normal)
        } else {
            showButton.setTitle("Hide", for: .normal)
        }
    }
}
