import UIKit
import QuartzCore
import AsyncDisplayKit

extension ProfileViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.visuals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                                                      for: indexPath) as! GifListCollectionCell
        let gif = self.visuals[indexPath.row]
        cell.photo.image = nil
        if self.previewImages.count > indexPath.row {
            cell.photo.image = self.previewImages[indexPath.row]
        } else {
            if let username = self.getUsername() {
            GeneralMethods.loadImage(visual: gif, username: username, callback: { (image) in
                    cell.photo.image = image
                })
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GifInfoViewController()
        let visual = self.visuals[indexPath.row]
        print(visual)
        vc.visual = visual
        vc.titleLabel.text = visual.preferredUsername ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if #available(iOS 11.0, *) {
            return CGSize(width: 320, height: 120)
        } else {
            return CGSize(width: 320, height: 180)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: self.headerReuseId,
                for: indexPath) as! ProfileHeaderView

            header.followersCount.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                              action: #selector(self.showFolowers(_:))))
            header.followingsCount.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                               action: #selector(self.showFollowings(_:))))
            header.editProfile.addTarget(self, action: #selector(showEditDialog(_:)), for: .touchUpInside)
            header.followersCount.text = "\(self.followers.count)"
            header.followingsCount.text = "\(self.followings.count)"


            var url: String?
            var picUsername: String?
            if self.isMe() {
                header.editProfile.isHidden = true // TODO: make visible when ready
                header.followButton.isHidden = true
                header.profileImage.addTarget(self, action: #selector(onProfilePicChange), for: .touchUpInside)
                if let username = User.myUsername() {
                    url = User.profilePuctureFor(username)
                    picUsername = username
                    header.profileImage.setImage(User.localProfilePictureFor(username), for: .normal)
                }
            } else {
                header.editProfile.isHidden = true
                if let username = User.myUsername() {

                    let follows = self.followers.filter { $0.username == username }
                    header.followButton.isHidden = false
                    if follows.count > 0 {
                        header.followButton.setImage(#imageLiteral(resourceName: "unfollowButton"), for: .normal)
                    } else {
                        header.followButton.setImage(#imageLiteral(resourceName: "followButton"), for: .normal)
                    }
                    header.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
                }
                if let username = self.username {
                    header.profileImage.setImage(User.localProfilePictureFor(username), for: .normal)
                    url = User.profilePuctureFor(username)
                    picUsername = username
                }
            }
            if let _ = url, let username = picUsername {
                header.profilePicLoading.startAnimating()
                FileDownloader().downloadAwsImage(username: username, completion: {
                    (error) in
                    header.profilePicLoading.stopAnimating()
                    if error == nil {
                        header.profileImage.setImage(User.localProfilePictureFor(username), for: .normal)
                    }
                })
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    
}
