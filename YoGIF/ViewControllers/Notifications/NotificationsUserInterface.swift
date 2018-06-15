import UIKit

extension NotificationsViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue

        let navHeader = UIView()
        let titleLabel = UILabel()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = "NOTIFICATIONS"
        self.navigationItem.titleView = navHeader

        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        background.backgroundColor = .lightGray
        background.image = #imageLiteral(resourceName: "loginBg")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        
        self.view.addSubview(self.tableView)
        self.tableView.separatorColor = AppConstants.separatorGrayColor
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(NotificationTableCell.self, forCellReuseIdentifier: self.reuseId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 50, right: 0)
        }
        
        self.refresh.addTarget(self, action: #selector(updateNotifications), for: .allEvents)
        self.tableView.addSubview(self.refresh)
        
    }
}
