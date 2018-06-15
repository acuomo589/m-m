import UIKit
import RealmSwift
import QuartzCore
import AsyncDisplayKit
import SVProgressHUD

class NotificationTableCell: UITableViewCell {
    let leftImage           = UIButton()
    let leftImageView       = UIImageView()
    let rightImage          = UIImageView()
    let followButton        = UIButton()
    let notificationText    = UILabel()
    let realm               = try! Realm()
    var followRequestActive = false
    var viewController: NotificationsViewController?
    var index: Int?
    var userToFollow: String? {
        didSet {
            if let username = self.userToFollow, let me = User.me() {
                let follows = me.following.filter { $0.username == username }
                if follows.count == 0 {
                    // show +
                    followButton.setImage(#imageLiteral(resourceName: "followButton"), for: .normal)
                } else {
                    followButton.setImage(#imageLiteral(resourceName: "unfollowButton"), for: .normal)
                }
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.contentView.backgroundColor = UIColor(white: 0, alpha: 0)
        let imageSize = CGFloat(50)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.layer.cornerRadius = imageSize * 0.5
        leftImageView.layer.masksToBounds = true
        contentView.addSubview(leftImageView)
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        leftImage.layer.cornerRadius = imageSize * 0.5
        leftImage.layer.masksToBounds = true
        contentView.addSubview(leftImage)
        leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        leftImageView.backgroundColor = .lightGray
        leftImageView.contentMode = .scaleAspectFill
        leftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        leftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        leftImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        leftImage.backgroundColor = .clear
        leftImage.addTarget(self, action: #selector(profilePictureTapped), for: .touchUpInside)
        leftImage.contentMode = .scaleAspectFill

        rightImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.layer.masksToBounds = true
        rightImage.backgroundColor = .lightGray
        contentView.addSubview(rightImage)
        rightImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        rightImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        rightImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        rightImage.contentMode = .scaleAspectFill

        contentView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setImage(#imageLiteral(resourceName: "followButton"), for: .normal)
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.contentMode = .scaleAspectFill
        followButton.contentVerticalAlignment = .fill
        followButton.contentHorizontalAlignment = .fill
        followButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        notificationText.translatesAutoresizingMaskIntoConstraints = false
        notificationText.font = UIFont(name: "Helvetica", size: 16)
        notificationText.numberOfLines = 0
        notificationText.text = "Text"
        notificationText.textColor = .white
        contentView.addSubview(notificationText)
        notificationText.leftAnchor.constraint(equalTo: leftImage.rightAnchor, constant: 10).isActive = true
        notificationText.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        notificationText.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        notificationText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        notificationText.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -10).isActive = true
    }

    @objc func followButtonTapped() {
        if followRequestActive {
            return
        }
        if let username = self.userToFollow {
            if followButton.currentImage == #imageLiteral(resourceName: "followButton") {
                followRequestActive = true
                if let me = User.me() {
                    let realm = try! Realm()
                    try! realm.write {
                        let follows = me.following.filter { $0.username == username }

                        if let user = follows.first, let index = me.following.index(of: user) {
                            me.following.remove(at: index)
                            realm.add(me, update: true)
                        }
                        self.userToFollow = username
                    }
                }
                User.follow(username, completionHandler: { (error) in
                    self.followRequestActive = false
                    if let error = error {
                        SVProgressHUD.dismiss()
                        if let vc = self.viewController {
                            _ = SimpleAlert.showAlert(alert: "Follow User Error: " + error, delegate: vc)
                        }
                    } else {
                        self.getProfile()
                    }
                })
            } else {
//                SVProgressHUD.show(withStatus: "Unfollowing")
                followRequestActive = true
                if let me = User.me() {
                    let realm = try! Realm()
                    try! realm.write {
                        var user: User
                        if let userOptional = realm.objects(User.self).filter("username = %@", username).first {
                            user = userOptional
                        } else {
                            user = User()
                            user.username = username
                            realm.add(user, update: true)
                        }
                        if !me.following.contains(user) {
                            me.following.append(user)
                            realm.add(me, update: true)
                        }
                        self.userToFollow = username
                    }
                }
                User.unfollow(username, completionHandler: { (error) in
                    self.followRequestActive = false
                    if let error = error {
                        SVProgressHUD.dismiss()
                        if let vc = self.viewController {
                            _ = SimpleAlert.showAlert(alert: "Unfollow User Error: " + error, delegate: vc)
                        }
                    } else {
                        self.getProfile()
                    }
                })
            }
        }
    }

    func getProfile() {
        if let u = User.myUsername() {
            User.getProfile(u) { user, error in
                SVProgressHUD.dismiss()
                if let username = self.userToFollow {
                    self.userToFollow = username
                }
            }
        }
    }

    func loadUserPicture(_ username: String) {
        self.leftImageView.image = User.localProfilePictureFor(username)//.setImage(User.localProfilePictureFor(username), for: .normal)
        let fd = FileDownloader()
        fd.downloadAwsImage(username: username, completion: { (error) in
            if error == nil {
                self.leftImageView.image = User.localProfilePictureFor(username)//setImage(User.localProfilePictureFor(username), for: .normal)
            }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showGif(filename: String, username: String) {
        if let visual = realm.objects(Visual.self).filter("filename = %@", filename).first {
            self.loadImage(visual: visual, username: username)
        } else {
            let visual = Visual.toRealm(data: ["uid": filename, "username": username] as NSDictionary)
            self.loadImage(visual: visual, username: username)
        }
    }

    func loadImage(visual: Visual, username: String) {
        // TODO: copied code. Refactor
        let filename = visual.filename
        if let file = visual.file() {
            let asset = AVURLAsset(url: file, options: nil)// AVURLAsset(URL: file, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
                rightImage.image = UIImage(cgImage: cgImage)
            } else {
                rightImage.image = nil
            }
            // !! check the error before proceeding
        } else {
            let fd = FileDownloader()
            fd.downloadAwsVideo(username: username, filename: filename, isPublic: visual.isPublic) { error in
                if let error = error {
                    print(error)
                } else {
                    self.loadImage(visual: visual, username: username)
                }
            }
        }
    }

    @objc func profilePictureTapped() {
        if let index = self.index, let viewController = self.viewController {
            viewController.profilePictureTapped(index: index)
        }
    }

}
