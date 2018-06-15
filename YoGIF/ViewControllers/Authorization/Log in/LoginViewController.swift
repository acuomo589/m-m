import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    let usernameField = UITextField()
    let passwordField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardOnTap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        if let username = usernameField.text, let pass = passwordField.text {
            SVProgressHUD.show(withStatus: "Loading")
            User.login(username: username, password: pass) { (user, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    _ = SimpleAlert.showAlert(alert: "Login Error: " + error, delegate: self)
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.restoreUserSession(openAppOnDone: true, continueSignup: false)
//                    appDelegate.openApp()
                }
             }
        }
    }
}
