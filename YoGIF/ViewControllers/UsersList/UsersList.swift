//
//  UsersTableViewController.swift
//  YoGIF
//
//  Created by Богдан Мигилев on 11/13/17.
//  Copyright © 2017 YoGIF. All rights reserved.
//

import UIKit

class UsersList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users: [User]!
    var navTitle = ""
    private let tableView = UITableView()
    private let reuseIdPeople = "userCell"
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpUI()
        titleLabel.text = navTitle
        self.navigationItem.title = navTitle
    }

    // MARK: - Collection  view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdPeople,
                                                              for: indexPath) as! UserCollectionViewCell
                let user = self.users[indexPath.row]
            print (user.username)
        print (user.preferredUsername)
                cell.userName.text = user.preferredUsername
//                cell.userName.text = user.username
                cell.loadUserPicture(user.username)
                cell.user = user
                return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController()
        print(self.users[indexPath.row])
        vc.username = self.users[indexPath.row].username
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    private func settingUpUI() {
        let yoBackButton = UIButton()
        yoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        yoBackButton.setImage(#imageLiteral(resourceName: "backArrowWhiteBold"), for: .normal)
        yoBackButton.sizeToFit()
        yoBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        yoBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        yoBackButton.contentHorizontalAlignment = .left
        let myCustomBackButtonItem = UIBarButtonItem(customView: yoBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem

        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        navHeader.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navHeader.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navHeader.centerYAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        titleLabel.textColor = .white
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
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UserCollectionViewCell.self, forCellReuseIdentifier: reuseIdPeople)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = AppConstants.separatorGrayColor
        self.tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    }
}
