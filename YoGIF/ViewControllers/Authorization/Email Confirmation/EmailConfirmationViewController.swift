import UIKit
import SVProgressHUD

class EmailConfirmationViewController: UIViewController {
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardOnTap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        print(UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername))
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        if let code = textField.text,
           let email = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername) {
            if code.characters.count != 6 {
                _ = SimpleAlert.showAlert(alert: "Please enter correct code", delegate: self)
            } else {
                SVProgressHUD.show(withStatus: "Loading")
                User.confirm(username: email, code: code) { error in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        _ = SimpleAlert.showAlert(alert: "Email Confirmation Error: " + error, delegate: self)
                    } else {
                        self.onSuccess()
                    }
                }
            }
        }
    }

    func onSuccess() {
        if let username = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername),
           let pass = UserDefaults.standard.string(forKey: AppConstants.nsudUserPassword) {
            SVProgressHUD.show(withStatus: "Loading")
            UserDefaults.standard.set(true, forKey: AppConstants.nsudConfirmationSuccesful)
            User.login(username: username, password: pass) { user, error in
                SVProgressHUD.dismiss()
                if user != nil {
                    // we have to set PublicUsername in User.login
                    // but in our current case, we just logged in with
                    // a private username (.username) instead of public (.preferredUsername)
                    // so we need to clear it from memory, so it won't confuse us
                    UserDefaults.standard.set(nil, forKey: AppConstants.nsudCognitoPublicUsername)
                    
                    let vc = UserNicknameViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if let error = error {
                    _ = SimpleAlert.showAlert(alert: error, delegate: self)
                } else {
                    _ = SimpleAlert.showAlert(alert: "Unexpected error", delegate: self)
                }
            }
        }
    }
}
