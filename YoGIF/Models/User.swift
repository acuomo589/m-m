import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var email: String?
    @objc dynamic var username = String()
    @objc dynamic var preferredUsername = String()
    @objc dynamic var weaklyVideo: Visual?
    
    let following = List<User>()
    let followers = List<User>()
    let liked = List<Visual>()
    let bookmarked = List<Visual>()
    var notifications = List<AppNotification>()
    
    var JSON: [String: Any] {
        var json = [
            "username": self.username
        ] as [String: Any]
        
        if let email = self.email {
            json["email"] = email
        }
        return json
    }

    override static func primaryKey() -> String? {
        return "username"
    }
    
    static func toRealm(data: NSDictionary) -> User {
        let realm = try! Realm()
        print(data)
        let username = data["username"] as! String
        var user: User
        if let userOptional = realm.objects(User.self).filter("username = %@", username).first {
            user = userOptional
        } else {
            user = User()
            user.username = username
        }
        
        try! realm.write {
            if let email = data["email"] as? String {
                user.email = email
            }
            if let preferredUsername = data["publicUsername"] as? String {
                user.preferredUsername = preferredUsername
            }
        }
        
        if let bookmarksData = data["bookmarkedVisuals"] as? NSDictionary,
            let bookmarks = bookmarksData["contents"] as? [NSDictionary] {
            
            try! realm.write {
                user.bookmarked.removeAll()
            }
            for visual in bookmarks {
                let visual = Visual.toRealm(data: visual)
                try! realm.write {
                    if !user.bookmarked.contains(visual) {
                        user.bookmarked.append(visual)
                    }
                    realm.add(user, update: true)
                    realm.add(visual, update: true)
                }
            }
        }

        if let followersData = data["followers"] as? NSDictionary, let followers = followersData["users"] as? [NSDictionary] {
            try! realm.write {
                user.followers.removeAll()
            }
            for userDict in followers {
                let follower = User.toRealm(data: userDict)
                try! realm.write {
                    if !user.followers.contains(follower) {
                        user.followers.append(follower)
                    }
                    realm.add(user, update: true)
                    realm.add(follower, update: true)
                }
            }
        }
        if let followingData = data["following"] as? NSDictionary, let following = followingData["users"] as? [NSDictionary] {
            try! realm.write {
                user.following.removeAll()
            }
            for userDict in following {
                let following = User.toRealm(data: userDict)
                try! realm.write {
                    if !user.following.contains(following) {
                        user.following.append(following)
                    }
                    realm.add(user, update: true)
                    realm.add(following, update: true)
                }
            }
        }
        try! realm.write{
            realm.add(user, update: true)
        }
        return user
    }
    
    static func myUsername() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername)
    }
    
    static func myPublicUsername() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.nsudCognitoPublicUsername)
    }
    
    static func me() -> User? {
        if let username = User.myUsername() {
            let realm = try! Realm()
            if let user = realm.objects(User.self).filter("username = %@", username).first {
                return user
            }
        }
        return nil
    }
    
    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.nsudCognitoToken)
    }
    
    static func getPersonalS3Access(completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "getPersonalS3Access",
                                     method: "GET", completionHandler: {(result, error) in
                                      //  print(result)
                                      //  print(error)
                                        if let credentials = result?["Credentials"] as? NSDictionary, let keyId = credentials["AccessKeyId"] as? String, let accessKey = credentials["SecretAccessKey"], let token = credentials["SessionToken"] {
                                            
                                            UserDefaults.standard.set(keyId, forKey: AppConstants.nsudS3AccessKeyId)
                                            UserDefaults.standard.set(accessKey, forKey: AppConstants.nsudS3SecretAccessKey)
                                            UserDefaults.standard.set(token, forKey: AppConstants.nsudS3SessionToken)
                                            completionHandler(nil)
                                        } else if let error = error {
                                            completionHandler(error.localizedDescription)
                                        } else {
                                            completionHandler("Failed to get S3 access")
                                        }
        })
    }
    
    func getProfileUrl() -> String {
        return User.profilePuctureFor(self.username)
    }
    
    static func profilePuctureFor(_ username: String) -> String {
        return "user/\(username)/profile.png"
    }
    
    func localProfilePicture() -> UIImage {
        return User.localProfilePictureFor(self.username)
    }
    
    static func localProfilePictureFor(_ username: String) -> UIImage {
        let url = User.localProfilePictureUrlFor(username)
        if let image = UIImage(contentsOfFile: url.path) {
            return image
        } else {
            return #imageLiteral(resourceName: "emptyUser")
        }
    }
    
    func localProfilePictureUrl() -> URL {
        return User.localProfilePictureUrlFor(self.username)
    }
    
    static func localProfilePictureUrlFor(_ username: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(username + ".png")
    }
    
    static func findUsers(query: String, completionHandler: @escaping ([User]?, String?) -> Void) {
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "findUsers?fragment=\(query)",
            method: "GET", completionHandler: {(result, error) in
                print(result)
                if let users = result?["users"] as? [NSDictionary] {
                    var resultUsers: [User] = []
                    for user in users {
                        let userObject = User.toRealm(data: user as NSDictionary)
                        resultUsers.append(userObject)
                    }
                    completionHandler(resultUsers, nil)
                } else if let error = error {
                    completionHandler(nil, error.localizedDescription)
                } else {
                    completionHandler(nil, "Unexpected error")
                }
        })
    }
    
    static func follow(_ username: String, completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: ["person": username] as NSDictionary,
                                     to: "follow",
                                     method: "POST", completionHandler: {(result, error) in
                                        
                                        print(result)
                                        print(error)
                                        if let result = result as? NSDictionary {
                                            completionHandler(nil)
                                        } else if let error = error {
                                            completionHandler(error.localizedDescription)
                                        } else {
                                            completionHandler("Unexpected error")
                                        }
        })
    }
    
    static func unfollow(_ username: String, completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: ["person": username] as NSDictionary,
                                     to: "unfollow",
                                     method: "POST", completionHandler: {(result, error) in
                                        if let result = result as? NSDictionary {
                                            completionHandler(nil)
                                        } else if let error = error {
                                            completionHandler(error.localizedDescription)
                                        } else {
                                            completionHandler("Unexpected error")
                                        }
        })
    }
    
    static func getProfile(_ username: String, completionHandler: @escaping (User?, String?) -> Void) {
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "getProfile?username=\(username)&also=following,followers,bookmarkedVisuals",
            method: "GET", completionHandler: {(result, error) in
                print(result)
                print(error)
                print(username)
                if let user = result as? NSDictionary, let username = user["username"] as? String {
                    let userObject = User.toRealm(data: user)
                    completionHandler(userObject, nil)
                } else if let error = error {
                    completionHandler(nil, error.localizedDescription)
                } else {
                    completionHandler(nil, "Unexpected error")
                }
        })
    }
    
    static func getWonContest(completionHandler: @escaping (Bool, String?) -> Void) {
        let user = User.me() ?? User()
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "getProfile?username=\(user.username)&also=wonContests",
            method: "GET", completionHandler: {(result, error) in
                print(result)
                print(error)
               
                if let user = result as? NSDictionary {
                    let res = isWinner(data: user)
                    //postWinnerSendCollectPrize(title: res.1)
                    completionHandler(res.0, res.1)
                } else if let _ = error {
                    completionHandler(false, nil)
                } else {
                    completionHandler(false, nil)
                }
        })
    }
    
    static func postWinnerSendCollectPrize(title: String?) {
        let path = "contestPrizeEmailSent"
        if let title = title {
            let _ = Session().sessionPushNotificationRequest(data: ["title": title], to: path, method: "POST") { (result, error) in
                if let error = error {
                    
                    YOLog.Log(error: error.localizedDescription, from: "Contest Winner Sent Email Error")
                } else if let res = result {
                    YOLog.Log(message: res, from: "Contest Winner Sent Email Result", category: "User")
                } else {
                    YOLog.Log(error: "Unexpected Error", from: "Contest Winner Sent Email Error")
                }
            }
        }
    }
    
    static func isWinner(data: NSDictionary) -> (Bool, String) {
        if let wonContest = data["wonContests"] as? [NSDictionary] {
            for obj in wonContest {
                if let _ = obj["prizeEmailSentAt"] as? String {
                    return (false,"")
                } else {
                    let isNotified = obj["snsNotified"] as? Bool ?? false
                    if isNotified {
                        return (true, obj["contestTitle"] as? String ?? "")
                    }
                }
            }
        }
        return (false,"")
    }

    static func updateProfile(_ data: NSDictionary, completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: data,
                                     to: "updateProfile",
            method: "PUT", completionHandler: {(result, error) in

                print(result)
                print(error)
                if let error = error {
                    completionHandler(error.localizedDescription)
                } else if let result = result as? NSDictionary {
                    completionHandler(nil)
                } else {
                    completionHandler("Unexpected error")
                }
                
        })
    }
    
    //MARK:  createdAt is Unique for notification. Make sort by this, now just rewrites previous one. If its OK. Delete this comment
    static func getNotifications(completionHandler: @escaping ([AppNotification]?, String?) -> Void) {
        if let username = User.myUsername(), let userData = User.me(){
            _ = Session().sessionRequest(data: [:] as NSDictionary,
                                         to: "getProfile?username=\(username)&also=notifications",
                method: "GET", completionHandler: {(result, error) in
                    if let notifications = result?["notifications"] as? [NSDictionary] {
                        print(notifications)
                        let notificationsArr = List<AppNotification>()
                        for notification in notifications {
                            if let notification = AppNotification.toRealm(data: notification) {
                                if userData.notifications.index(of: notification) == nil {
                                    notificationsArr.append(notification)
                                }
                            }
                        }
                        if notificationsArr.count > 0 {
                            let realm = try! Realm()
                            try! realm.write {
                                userData.notifications = notificationsArr
                                realm.add(userData, update: true)
                            }
                        }
                        completionHandler(Array(userData.notifications), nil)
                    } else if let error = error {
                        completionHandler(nil, error.localizedDescription)
                    } else if let username = result?["username"] as? String {
                        // consider request succesfully finished, without any notifications
                        completionHandler([], nil)
                    } else {
                        completionHandler(nil, "Unexpected error")
                    }
            })
        }
    }
}
