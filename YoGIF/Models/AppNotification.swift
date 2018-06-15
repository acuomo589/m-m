import Foundation
import RealmSwift

class AppNotification: Object {
    @objc dynamic var id = String()
    @objc dynamic var likingUser: String?
    @objc dynamic var bookmarkingUser: String?
    @objc dynamic var dislikingUser: String?
    @objc dynamic var place: Int = -1
    @objc dynamic var count: Int = -1
    @objc dynamic var by: String?
    @objc dynamic var type = String()
    @objc dynamic var uid: String?
    @objc dynamic var username = String()
    @objc dynamic var createdAtStr = String()
    @objc dynamic var createdAt = Date()
    @objc dynamic var currentRank: Int = -1
    @objc dynamic var preferredUsername: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func toRealm(data: NSDictionary) -> AppNotification? {
        if let type = data["type"] as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let createdAt = data["createdAt"] as? String {
                if let date = dateFormatter.date(from: createdAt) {
                    if type == "contestRankChange" && !TimerHelper.isInCurrentWeek(date: date) {
                        return nil
                    }
                }
            }
            if let username = data["publicUsername"] as? String {
                print(username)
                if username == "DELETED" {
                    return nil
                }
            } else {
                return nil
            }
            if type == "uploadVisual", let username = data["username"] as? String,
                User.myUsername() == username { return nil}
            if type == "like", let username = data["likingUser"] as? String,
                User.myUsername() == username { return nil}
            if type == "dislike", let username = data["dislikingUser"] as? String,
                User.myUsername() == username { return nil}
            if type == "bookmark", let username = data["bookmarkingUser"] as? String,
                User.myUsername() == username  {return nil}

            let realm = try! Realm()

            
            
            var uLikingUser: String?
            var uDislikingUser: String?
            var uBookmarkingUser: String?
            var uPlace: Int? = -1
            var uCount: Int? = -1
            var followBy : String?
            var sUsername : String?
            var uCurrentRank: Int? = -1
            
            
            if type == "uploadVisual", let username = data["username"] as? String {
                sUsername = username
            }
            else if type == "like", let username = data["likingUser"] as? String {
                uLikingUser = username
            } else if type == "dislike", let username = data["dislikingUser"] as? String {
                uDislikingUser = username
            }
            else if type == "bookmark", let username = data["bookmarkingUser"] as? String {
                uBookmarkingUser = username
            } else if type == "weekly_up", let place = data["place"] as? Int {
                uPlace = place
            } else if type == "views", let count = data["count"] as? Int {
                // Your gif has 100 views
                uCount = count
            } else if type == "follow", let username = data["by"] as? String {
                followBy = username
            } else if type == "share", let username = data["username"] as? String {
                // username shared your gif
                sUsername = username
            } else if type == "facebook_join", let username = data["username"] as? String {
                // Your Facebook friend, username, is now on YoGif!
                sUsername = username
            } else if type == "contestRankChange", let currentRank = data["currentRank"] as? Int {
                uCurrentRank = currentRank
            } else {
                return nil
            }
            
            let id = data["id"] as! String
            var appNotification: AppNotification
            if let notificationOptional = realm.objects(AppNotification.self).filter("id = %@", id).first {
                appNotification = notificationOptional
            } else {
                appNotification = AppNotification()
                appNotification.id = id
            }
            
            try! realm.write {
                
                
                
                
                if let createdAt = data["createdAt"] as? String {
                    
                    if let date = dateFormatter.date(from: createdAt) {
                        dateFormatter.dateFormat = "MMM d, hh:mm"
                        appNotification.createdAtStr = dateFormatter.string(from: date)
                        appNotification.createdAt = date
                    }
                } else {
                    let current = Date()
                    appNotification.createdAt = current
                    appNotification.createdAtStr = dateFormatter.string(from: current)
                }
                
                appNotification.type = type
                if let uid = data["uid"] as? String {
                    appNotification.uid = uid
                }
                if let preferredUsername = data["publicUsername"] as? String {
                    appNotification.preferredUsername = preferredUsername
                }
                if let uName = sUsername {
                    appNotification.username = uName
                }
                if let lUser = uLikingUser {
                    appNotification.likingUser = lUser
                }
                if let dUser = uDislikingUser {
                    appNotification.dislikingUser = dUser
                }
                if let bUser = uBookmarkingUser {
                    appNotification.bookmarkingUser = bUser
                }
                if let uplace = uPlace {
                    appNotification.place = uplace
                }
                if let ucount = uCount {
                    appNotification.count = ucount
                }
                if let fBy = followBy {
                    appNotification.by = fBy
                }
                if let uRank = uCurrentRank {
                    appNotification.currentRank = uRank
                }
                
                
                realm.add(appNotification, update: true)
            }
            
            return appNotification
        } else {
            return nil
        }

    }

}
