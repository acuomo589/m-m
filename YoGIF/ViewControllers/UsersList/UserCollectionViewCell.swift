//
//  UserCollectionViewCell.swift
//  YoGIF
//
//  Created by Bohdan Mihiliev on 13.11.17.
//  Copyright © 2017 YoGIF. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UITableViewCell {
    let userName = UILabel()
    let userPhoto = UIImageView(image: #imageLiteral(resourceName: "emptyUser"))
    var user: User?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor(white: 0, alpha: 0)
        let imageSize = CGFloat(50)
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        userPhoto.layer.cornerRadius = imageSize * 0.5
        userPhoto.layer.masksToBounds = true
        contentView.addSubview(userPhoto)
        userPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        userPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        userPhoto.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        userPhoto.backgroundColor = .lightGray
        
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.font = UIFont(name: "Helvetica", size: 16)
        userName.numberOfLines = 2
        userName.text = "Text"
        userName.textColor = .white
        contentView.addSubview(userName)
        userName.leftAnchor.constraint(equalTo: userPhoto.rightAnchor, constant: 16).isActive = true
        userName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func loadUserPicture(_ username: String) {
        self.userPhoto.image = User.localProfilePictureFor(username)
        let fd = FileDownloader()
        fd.downloadAwsImage(username: username, completion: { (error) in
            if let curUsername = self.user?.username, error == nil, username == curUsername {
                self.userPhoto.image = User.localProfilePictureFor(username)
            }
        })
    }
}
