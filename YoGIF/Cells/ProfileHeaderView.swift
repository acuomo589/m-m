import UIKit
import QuartzCore
import AsyncDisplayKit

class ProfileHeaderView: UICollectionReusableView {

    let followersCount = UILabel()
    let followingsCount = UILabel()
    let followButton = UIButton()
    let editProfile = UIButton()
    let profileImage = UIButton()
    let profilePicLoading = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0, alpha: 0)

        let header = UIView()
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.heightAnchor.constraint(equalToConstant: 110).isActive = true
        header.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        header.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        header.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        header.clipsToBounds = true

        let imageSize = CGFloat(90)
        header.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        profileImage.layer.cornerRadius = imageSize * 0.5
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.clipsToBounds = true
        profileImage.imageView?.contentMode = .scaleAspectFill
        profileImage.setImage(#imageLiteral(resourceName: "emptyUser"), for: .normal)


        header.addSubview(profilePicLoading)
        profilePicLoading.translatesAutoresizingMaskIntoConstraints = false
        profilePicLoading.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor, constant: 0).isActive = true
        profilePicLoading.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 0).isActive = true

        header.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setImage(#imageLiteral(resourceName: "followButton"), for: .normal)
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        followButton.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0).isActive = true
        followButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -20).isActive = true
        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.contentMode = .scaleAspectFit
        followButton.contentVerticalAlignment = .fill
        followButton.contentHorizontalAlignment = .fill

        header.addSubview(editProfile)
        editProfile.translatesAutoresizingMaskIntoConstraints = false
        editProfile.heightAnchor.constraint(equalToConstant: 26).isActive = true
        editProfile.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editProfile.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0).isActive = true
        editProfile.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -20).isActive = true
//        editProfile.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        editProfile.contentMode = .scaleAspectFit
        editProfile.backgroundColor = AppConstants.colorGreen
        editProfile.layer.cornerRadius = 13
        editProfile.layer.borderWidth = 1
        editProfile.layer.borderColor = UIColor.white.cgColor
        editProfile.setTitleColor(.white, for: .normal)
        editProfile.setTitle("EDIT PROFILE", for: .normal)
        editProfile.titleLabel?.font = UIFont(name: "Helvetica", size: 12)

        header.addSubview(followersCount)
        followersCount.translatesAutoresizingMaskIntoConstraints = false
        followersCount.centerXAnchor.constraint(
                equalTo: header.leftAnchor,
                constant: UIScreen.main.bounds.width * 0.15).isActive = true
        followersCount.topAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -10).isActive = true
        followersCount.textColor = .white
        followersCount.font = UIFont(name: "Helvetica-Bold", size: 22)
        followersCount.text = "0"
        followersCount.isUserInteractionEnabled = true

        let followersLabel = UILabel()
        header.addSubview(followersLabel)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.centerXAnchor.constraint(equalTo: followersCount.centerXAnchor, constant: 0).isActive = true
        followersLabel.topAnchor.constraint(equalTo: followersCount.bottomAnchor, constant: 2).isActive = true
        followersLabel.textColor = .lightGray
        followersLabel.font = UIFont(name: "Helvetica", size: 12)
        followersLabel.text = "FOLLOWERS"
        followersLabel.isUserInteractionEnabled = true

        header.addSubview(followingsCount)
        followingsCount.translatesAutoresizingMaskIntoConstraints = false
        followingsCount.centerXAnchor.constraint(
                equalTo: header.leftAnchor,
                constant: UIScreen.main.bounds.width * 0.8).isActive = true
        followingsCount.topAnchor.constraint(equalTo: followersCount.topAnchor, constant: 0).isActive = true
        followingsCount.textColor = .white
        followingsCount.font = UIFont(name: "Helvetica-Bold", size: 22)
        followingsCount.text = "0"
        followingsCount.isUserInteractionEnabled = true

        let followingsLabel = UILabel()
        header.addSubview(followingsLabel)
        followingsLabel.translatesAutoresizingMaskIntoConstraints = false
        followingsLabel.centerXAnchor.constraint(equalTo: followingsCount.centerXAnchor, constant: 0).isActive = true
        followingsLabel.topAnchor.constraint(equalTo: followingsCount.bottomAnchor, constant: 2).isActive = true
        followingsLabel.textColor = .lightGray
        followingsLabel.font = UIFont(name: "Helvetica", size: 12)
        followingsLabel.text = "FOLLOWING"
        followingsLabel.isUserInteractionEnabled = true
    }

}
