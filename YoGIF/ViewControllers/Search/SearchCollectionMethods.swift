import UIKit

extension SearchViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        if self.mode == 0 && !tagsSearch{
            return self.moods.count
        }else if self.mode == 0 && tagsSearch {
            return visuals.count
        } else {
            return self.users.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.mode == 0 && !tagsSearch {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                                                          for: indexPath) as! MoodCollectionCell
            let mood = self.moods[indexPath.row]
            if let title = mood["title"] as? String {
                cell.title.text = title
            }
            if let image = mood["image"] as? UIImage {
                cell.background.image = image
            }
            return cell
        } else if self.mode == 0 && tagsSearch { 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.visualReuseID,
                                                          for: indexPath) as! GifListCollectionCell
            let gif = self.visuals[indexPath.row]
            if let username = gif.username {
                cell.loadImage(visual: gif, username: username)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdPeople,
                                                          for: indexPath) as! PeopleCollectionCell
            let user = self.users[indexPath.row]

            cell.userName.text = user.preferredUsername
            cell.loadUserPicture(user.username)
            cell.delegate = self
            cell.user = user
            let follows = self.following.filter { $0.username == user.username }
            var hideFollowButton = follows.count > 0
            if let username = User.myUsername() {
                if user.username == username {
                    hideFollowButton = true
                }
            }
            cell.followButton.isHidden = hideFollowButton
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.mode == 0 && !tagsSearch {
            let vc = GifsListViewController()
            let mood = self.moods[indexPath.row]
            if let title = mood["title"] as? String {
                vc.moodTag = title
            }
            vc.color = mood["color"] as! UIColor
            self.navigationController?.pushViewController(vc, animated: true)
        } else if self.mode == 0 && tagsSearch {
            let vc = GifInfoViewController()
            vc.visual = self.visuals[indexPath.row]
            vc.titleLabel.text = visuals[indexPath.row].username
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = ProfileViewController()
            vc.username = self.users[indexPath.row].username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if #available(iOS 11.0, *) {
                return CGSize(width: 320, height: 60)
            } else {
                return CGSize(width: 320, height: 120)
            }
        } else {
            return CGSize(width: 0, height: 0)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader && indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: self.headerReuseId,
                for: indexPath) as! SearchHeaderView
            header.mode = self.mode
            header.delegate = self
            self.searchField = header.searchBar
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
