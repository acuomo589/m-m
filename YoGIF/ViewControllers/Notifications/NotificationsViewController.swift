import UIKit
import RealmSwift
class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseId = "reuseIdNotification"
    let tableView = UITableView()
    var notifications = [AppNotification]()
    var refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
    }

    @objc func updateNotifications() {
        User.getNotifications {
            notifications, error in
            self.refresh.endRefreshing()
            if let notifications = notifications {
                self.notifications = notifications.reversed()
                self.tableView.reloadData()
            } else if let error = error {
                _ = SimpleAlert.showAlert(alert: "User Notifications Error: " + error, delegate: self)
            } else {
                _ = SimpleAlert.showAlert(alert: "Unexpected error: User Notifications", delegate: self)
            }
        }
    }
    
    func openProfileForUsername(_ username: String) {
        let vc = ProfileViewController()
        vc.username = username
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func profilePictureTapped(index: Int) {

        let notification = self.notifications[index]

        if let username = notification.by {
            openProfileForUsername(username)
        } else if let username = notification.bookmarkingUser {
            openProfileForUsername(username)
        } else if let username = notification.likingUser {
            openProfileForUsername(username)
        }
    }
}
