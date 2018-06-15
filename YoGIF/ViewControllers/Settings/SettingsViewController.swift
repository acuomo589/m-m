import UIKit
import SafariServices
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate {
    let reuseId = "reuseIdSettings"
    let tableView = UITableView()
    let titleLabel = UILabel()
    let settings = [
        ["type": "arrow", "text": "Invite your Facebook friends"],
//        ["type": "arrow", "text": "Change password"],
//        ["type": "switch", "text": "Private account"],
        ["type": "switch", "text": "Push notifications"],
        ["type": "arrow", "text": "Report a problem"],
        ["type": "arrow", "text": "Privacy policy"],
        ["type": "arrow", "text": "Terms"],
        ["type": "arrow", "text": "Log out"],
        ["type": "arrow", "text": "Deactivate account"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
