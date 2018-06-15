import UIKit

extension SettingsViewController {
    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue

        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = "SETTINGS"
        self.navigationItem.titleView = navHeader

        let yoBackButton = UIButton()
        yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        yoBackButton.setImage(#imageLiteral(resourceName: "backArrowWhiteBold"), for: .normal)
        yoBackButton.sizeToFit()
        yoBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        yoBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        yoBackButton.contentHorizontalAlignment = .left
        let myCustomBackButtonItem = UIBarButtonItem(customView: yoBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem

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
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(SettingsTableCell.self, forCellReuseIdentifier: self.reuseId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = AppConstants.separatorGrayColor
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 66).isActive = true
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
    }
}
