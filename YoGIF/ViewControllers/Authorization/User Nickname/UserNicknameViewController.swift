import UIKit
import SVProgressHUD

class UserNicknameViewController: UIViewController {

    let userNameField = UITextField()
    let usernameIcon = UIImageView()
    let notAvailContainer = UIView()
    var usernameAvailable = true
    var facebookMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        refreshUsername()
        hideKeyboardOnTap()
        userNameField.text = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameField.becomeFirstResponder()
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextTapped() {
        if let text = userNameField.text,
            text.trimmingCharacters(in: .whitespaces).characters.count > 2 {
            UserDefaults.standard.set(text, forKey: AppConstants.nsudCognitoPublicUsername)

            SVProgressHUD.show(withStatus: "Loading")
            User.updateProfile(["publicUsername": text]) { error in
                SVProgressHUD.dismiss()
                if let error = error {
                    _ = SimpleAlert.showAlert(alert: "Update Username Error: " + error, delegate: self)
                } else {

                    // // Temporarily disabled Find Friends Screen
                    // if self.facebookMode {
                    //     // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //     // appDelegate.openApp()
                    //     let vc = HowItWorksViewController()
                    //     self.navigationController?.pushViewController(vc, animated: true)
                    // } else {
                    //     let vc = FindFriendsViewController()
                    //     self.navigationController?.pushViewController(vc, animated: true)
                    // }
                    let vc = HowItWorksViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
//            if usernameAvailable {
//
//            } else {
//                _ = SimpleAlert.showAlert(alert: "Unfortunately, username is not available", delegate: self)
//            }
        } else {
            _ = SimpleAlert.showAlert(alert: "Please enter a correct username", delegate: self)
        }
    }

    @objc func refreshUsername() {
        if usernameAvailable {
            usernameIcon.image = #imageLiteral(resourceName: "signupUsernameOk")
            notAvailContainer.isHidden = true
        } else {
            usernameIcon.image = #imageLiteral(resourceName: "signupUsernameExists")
            notAvailContainer.isHidden = false
        }
    }
}
