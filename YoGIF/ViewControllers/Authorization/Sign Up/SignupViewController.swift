import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD
import AWSCognitoAuth
import AWSCore
import AWSCognito

class SignupViewController: UIViewController, AWSCognitoAuthDelegate {
    func getViewController() -> UIViewController {
        return self
    }

    var auth: AWSCognitoAuth = AWSCognitoAuth.default()
    var session: AWSCognitoAuthUserSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardOnTap()
        setupCognito()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupCognito() {
        self.auth.delegate = self
        print(self.auth.authConfiguration.appClientId)
        print(self.auth.authConfiguration.webDomain)
        print(self.auth.authConfiguration.webDomain)
    }

    @objc func signupWithEmail() {
        let vc = UserNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func signInTapped() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func facebookTapped() {
        self.auth.getSession  { (session:AWSCognitoAuthUserSession?, error:Error?) in
            OperationQueue.main.addOperation {

                if let session = session, let idToken = session.idToken, let username = session.username {
                    self.session = session

                    let token = idToken.tokenString
                    UserDefaults.standard.set(token, forKey: AppConstants.nsudCognitoToken)
                    UserDefaults.standard.set(username, forKey: AppConstants.nsudCognitoUsername)
                    UserDefaults.standard.set(username, forKey: AppConstants.nsudCognitoFacebookUsername)

                    SVProgressHUD.show(withStatus: "Logging in")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate

                    User.getCognitoPrefferedUserame(username: username, completionHandler: { (preferredUsername, error) in
                        if let error = error {
                            _ = SimpleAlert.showAlert(alert: "Getting Username Error: " + error, delegate: self)
                        } else if let preferredUsername = preferredUsername {
                            UserDefaults.standard.set(preferredUsername, forKey: AppConstants.nsudCognitoPublicUsername)
                            appDelegate.restoreUserSession(openAppOnDone: true, continueSignup: false)
                        } else {
                            appDelegate.restoreUserSession(openAppOnDone: true, continueSignup: true)
                        }
                    })
                } else if let error = error as? NSError, let errorString = error.userInfo["error"] as? String {
                    _ = SimpleAlert.showAlert(alert: "Get Session Error: " + errorString, delegate: self)
                } else {
                    _ = SimpleAlert.showAlert(alert: "Unexpected error: Get Session #129f", delegate: self)
                }
            }
        }
    }

    //    func onLogin(user: User) {
    //        User.signUp(data: [:], completionHandler:
    //            {
    //                user, error in
    //                if let error = error{
    //                    _ = SimpleAlert.showAlert(alert: error, delegate: self)
    //                    #if DEBUG
    //                        print(error)
    //                    #endif
    //                    return
    //                }
    //                guard let authUser = user else {
    //                    _ = SimpleAlert.showAlert(alert: "Unexpected Error", delegate: self)
    //                    #if DEBUG
    //                        print("Unexpected Error")
    //                    #endif
    //                    return
    //                }
    //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //                appDelegate.openApp()
    //        })
    //    }
}
