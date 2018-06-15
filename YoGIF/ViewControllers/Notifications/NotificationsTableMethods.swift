import UIKit

extension NotificationsViewController {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId,
                                                 for: indexPath as IndexPath) as! NotificationTableCell
        //        ["type": "bookmark", "username": "tonythetiger"],
        //        ["type": "like", "username": "crazydude921, jessie123"],
        //        ["type": "weekly_up", "place": 124],
        //        ["type": "views", "count": 124],
        //        ["type": "follow", "username": "goCeltics"],
        //        ["type": "share", "username": "otherGuy"],
        //        ["type": "facebook_join", "username": "otherGuy"]
        let notification = self.notifications[indexPath.row]
        cell.viewController = self
        cell.index = indexPath.row
        let userName = notification.username
        let preferredUsername = notification.preferredUsername ?? userName
        let notificationType = notification.type
        
        cell.notificationText.text = notification.createdAtStr

        if notificationType == "bookmark" {
            // username saved your gif
            if let username = notification.bookmarkingUser {
                cell.notificationText.text = "\(preferredUsername) saved your gif"
                cell.followButton.isHidden = true
                cell.rightImage.isHidden = false
                if let uid = notification.uid {
                    cell.showGif(filename: uid, username: username)
                }
                cell.loadUserPicture(username)
            }
        } else if notificationType == "like" || notificationType == "dislike"{
            // username liked your gif
            if let username = notification.likingUser ?? notification.dislikingUser {
                cell.notificationText.text = "\(preferredUsername) \(notificationType)d your post"
                cell.followButton.isHidden = true
                cell.rightImage.isHidden = false
                if let uid = notification.uid{
                    cell.showGif(filename: uid, username: username)
                }
                cell.loadUserPicture(username)
            }
        } else if notificationType == "contestRankChange" {
            // Moving on up! You just moved to XXXth in YoGif Weekly
            if TimerHelper.isInCurrentWeek(date: notification.createdAt) {
                if notification.currentRank > -1 {
                    var rank = "\(notification.currentRank)th"
                    if notification.currentRank == 1 {
                        rank = "\(notification.currentRank)st"
                    } else if notification.currentRank == 2 {
                        rank = "\(notification.currentRank)nd"
                    } else if notification.currentRank == 3 {
                        rank = "\(notification.currentRank)rd"
                    }
                    cell.notificationText.text = "Moving on up! You just moved to \(rank) in Mīm Weekly"
                    cell.followButton.isHidden = true
                    cell.rightImage.backgroundColor = AppConstants.emptyVideoHolder
                    if let username = User.myUsername(),
                        let gif = User.me()?.weaklyVideo {
                        cell.loadImage(visual: gif,
                                       username: username)
                    }
                    cell.rightImage.isHidden = false
                    cell.leftImage.isHidden = true
                }
            }
        } else if notificationType == "views" {
            // Your gif has 100 views
            if notification.count > -1 {
                cell.notificationText.text = "Your gif has \(notification.count) views"
                cell.followButton.isHidden = true
                cell.rightImage.isHidden = false
            }
        } else if notificationType == "follow" {
            // username is following you
            if let username = notification.by {
                cell.notificationText.text = "\(preferredUsername) is following you"
                cell.followButton.isHidden = false
                cell.rightImage.isHidden = true
                cell.userToFollow = username
                cell.loadUserPicture(username)
            }
        } else if notificationType == "share" {
            // username shared your gif
            cell.notificationText.text = "\(preferredUsername) shared your gif"
            cell.followButton.isHidden = true
            cell.rightImage.isHidden = false
            cell.loadUserPicture(userName)
        } else if notificationType == "facebook_join" {
            // Your Facebook friend, username, is now on YoGif!
            cell.notificationText.text = "Your Facebook friend, \(preferredUsername), is now on Mīm!"
            cell.followButton.isHidden = false
            cell.rightImage.isHidden = true
            cell.loadUserPicture(userName)
        } else if notificationType == "uploadVisual" {
            cell.notificationText.text = " \(preferredUsername) has posted a new GIF!"
            cell.followButton.isHidden = true
            cell.rightImage.isHidden = true
            if let uid = notification.uid {
                cell.showGif(filename: uid, username: userName)
                cell.rightImage.isHidden = false
            }
            cell.loadUserPicture(userName)
        } else {
            
        }
 
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = self.notifications[indexPath.row]
        if let uid = notification.uid {
            var userName = notification.username
            if userName == "" {
                userName = User.myUsername() ?? ""
            }
            let visual = Visual.toRealm(data: ["uid": uid, "username": userName])
            let vc = GifInfoViewController()
            vc.visual = visual
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let username = notification.by {
            openProfileForUsername(username)
        }else if let weaklyVideo = User.me()?.weaklyVideo{
            let vc = GifInfoViewController()
            vc.visual = weaklyVideo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
