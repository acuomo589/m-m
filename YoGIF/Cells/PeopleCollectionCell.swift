import UIKit
import QuartzCore
import AsyncDisplayKit

class PeopleCollectionCell: UICollectionViewCell {
    let userName = UILabel()
    let followButton = UIButton()
    let userPhoto = UIImageView(image: #imageLiteral(resourceName: "emptyUser"))
    var user: User?
    weak var delegate: SearchViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        container.backgroundColor = .white
        container.layer.cornerRadius = 15
        container.clipsToBounds = true

        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(userPhoto)
        userPhoto.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        userPhoto.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        userPhoto.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        userPhoto.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -38).isActive = true
        userPhoto.backgroundColor = .lightGray
        userPhoto.contentMode = .scaleAspectFill
        userPhoto.clipsToBounds = true

        container.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setImage(#imageLiteral(resourceName: "followButton"), for: .normal)
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followButton.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        followButton.bottomAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 0).isActive = true
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.contentMode = .scaleAspectFit
        followButton.contentVerticalAlignment = .fill
        followButton.contentHorizontalAlignment = .fill
        followButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)


        userName.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(userName)
        userName.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 3).isActive = true
        userName.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -3).isActive = true
        userName.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -7).isActive = true
        userName.font = UIFont(name: "SanFranciscoText", size: 16)
        userName.textColor = AppConstants.colorGreen
        userName.textAlignment = .center
        userName.text = "Title"
        userName.adjustsFontSizeToFitWidth = true
    }

    @objc func followButtonTapped() {
        if let user = self.user, let delegate = self.delegate {
            delegate.onFollowTap(user)
        }
    }

    func showImage(newUrl: String) {
//        self.url = newUrl
//        self.loadImage(urlString: url)
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
