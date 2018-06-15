import UIKit
import SafariServices
import MessageUI
import SVProgressHUD

extension SettingsViewController {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId,
                for: indexPath as IndexPath) as! SettingsTableCell
        let setting = self.settings[indexPath.row]
//        ["type": "arrow", "text": "Invite your Facebook friends"],
//        ["type": "arrow", "text": "Change password"],
//        ["type": "switch", "text": "Private account"],
//        ["type": "switch", "text": "Push notifications"],
//        ["type": "arrow", "text": "Report a problem"],
//        ["type": "arrow", "text": "Privacy policy"],
//        ["type": "arrow", "text": "Terms"],
//        ["type": "arrow", "text": "Log out"],
//        ["type": "arrow", "text": "Deactivate account"]
        if let type = setting["type"], let text = setting["text"] {
            cell.settingText.text = text
            if type == "arrow" {
                cell.arrowImage.isHidden = false
                cell.settingSwitch.isHidden = true
            } else {
                cell.arrowImage.isHidden = true
                cell.settingSwitch.isHidden = false
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.row]
        if let text = setting["text"] {
            if text == "Log out" {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                UserDefaults.standard.set(false, forKey: AppConstants.gifUploadedUD)
                if let signupVc = appDelegate.openAuth() as? SignupViewController {
                    User.logout(signupVc: signupVc)
                } else {
                    User.logout(signupVc: nil)
                }



            } else if text == "Deactivate account" {

                let alert = UIAlertController(title: "Are you sure?", message: "Deactivating your account will delete Mīm and all of its data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: {
                    [unowned self] _ in
                    SVProgressHUD.show(withStatus: "Deactivating")
                    User.deactivateAccount(completionHandler: { (error) in
                        SVProgressHUD.dismiss()
                        if let error = error {
                            _ = SimpleAlert.showAlert(alert: "Deactivate Account Error: " + error, delegate: self)
                        } else {
                            print("deactivated!")
                        }
                    })
                }))
                present(alert, animated: true, completion: nil)

            } else if text == "Terms" {
                let safariVC = SFSafariViewController(url: URL(string: "http://mim-app.com/terms")!)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            } else if text == "Privacy policy" {
                let safariVC = SFSafariViewController(url: URL(string: "http://mim-app.com/privacy")!)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            } else if text == "Report a problem" {
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(["info@mim-app.com"])
                    composeVC.setSubject("Mīm issue")
                    composeVC.setMessageBody("Hey Anthony, I found a problem with Mīm:", isHTML: false)

                    // Present the view controller modally.
                    self.present(composeVC, animated: true, completion: nil)

                }else {
                    show(failure: "Can't send email from this device", with: "eMail Error")
                }
            } else if text == "Change Password" {

            }

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
