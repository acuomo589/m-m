
//
// Created by Kyrylo Savytskyi on 10/3/17.
// Copyright (c) 2017 YoGIF. All rights reserved.
//

import Foundation
import RealmSwift

class Visual: Object {

    @objc dynamic var filename = String()
    @objc dynamic var username: String?
    @objc dynamic var preferredUsername: String?
    @objc dynamic var title: String?
    @objc dynamic var totalLikes: Int = 0
    @objc dynamic var totalDislikes: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var location: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var permission: String?
    @objc dynamic var tags: String?
    @objc dynamic var audioUid: String?
    @objc dynamic var audioDelay: Double = 0
    @objc dynamic var YGWplace: Int = 0
    @objc dynamic var audioMuted: Bool = false
    //Text Animation
    @objc dynamic var animText:String?
    @objc dynamic var animColor: Data?
    @objc dynamic var animStartAt: Double = 0
    @objc dynamic var animEndAt: Double = 0
    @objc dynamic var animType = 0
    @objc dynamic var animYPoint: Double = 0

    let likedByUsers = List<User>()
    let dislikedByUsers = List<User>()

    enum AnimationTypes {
        case fadeOut
        case fadeIn
    }
    
    enum PostOperations: String {
        case like =  "likeVisual",
        unlike = "unlikeVisual",
        dislike = "dislikeVisual",
        undislike = "undislikeVisual",
        bookmark = "bookmarkVisual",
        unbookmark = "unbookmarkVisual"
    }
    enum VisualOperations: String {
        case update = "updateVisual",
        create = "uploadVisual"
    }
    var rank: String {
        if YGWplace == 1 {
            return "\(YGWplace)st"
        } else if YGWplace == 2 {
            return "\(YGWplace)nd"
        } else if YGWplace == 3 {
            return "\(YGWplace)rd"
        } else {
            return "\(YGWplace)th"
        }
    }
    
    var passedTime: String {
        guard let creationTime = createdAt else { return "a lot of time" }
        let minutes = Calendar.current.dateComponents([.minute], from: creationTime, to: Date()).minute
        let hours = Calendar.current.dateComponents([.hour], from: creationTime, to: Date()).hour
        let days = Calendar.current.dateComponents([.day], from: creationTime, to: Date()).day
        let years = Calendar.current.dateComponents([.year], from: creationTime, to: Date()).year
        if let minutesPassed = minutes, minutesPassed < 60 {
            if minutesPassed < 1 {
                return "just now"
            }
            else if minutesPassed == 1 {
                return "\(minutesPassed) minute ago"
            }
            return "\(minutesPassed) minutes ago"
        }
        if let hoursPassed = hours, hoursPassed < 24 {
            if hoursPassed == 1 {
                return "\(hoursPassed) hour ago"
            }
            return "\(hoursPassed) hours ago"
        }
        if let daysPassed = days, daysPassed < 365 {
            if daysPassed == 1 {
                return "\(daysPassed) day ago"
            }
            return "\(daysPassed) days ago"
        }
        if let yearsPassed = years {
            if yearsPassed == 1 {
                return "\(yearsPassed) year ago"
            }
            return "\(yearsPassed) years ago"
        }
        return "Long time ago"
    }
    var isPublic: Bool {
        if let permission = self.permission {
            return permission == "shared"
        } else {
            return true
        }
    }
    var tagsArray: [String] {
        if let tags = self.tags {
            let arr = tags.split(separator: ",")
            var strArr = [String]()
            for str in arr {
                strArr.append(String(str))
            }
            return strArr
        } else {
            return []
        }
    }
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()

    override static func primaryKey() -> String? {
        return "filename"
    }

    func toJSON() -> [String: Any] {
        var json = [
            "filename": self.filename
            ] as [String: Any]

        if let username = self.username {
            json["username"] = username
        }
        if let title = self.title {
            json["title"] = title
        }
        return json
    }

    func file() -> URL? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.filename + ".mp4")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            return url
        } else {
            return nil
        }
    }

    func audioFile() -> URL? {
        if let audioUid = self.audioUid {
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(audioUid + ".m4a")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: url.path) {
                return url
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    static func toRealm(data: NSDictionary) -> Visual {
        let realm = try! Realm()
        
        let filename: String
        if let f = data["filename"] as? String {
            filename = f
        } else {
            guard let uId = data["uid"] as? String else {
                return Visual()
            }
            filename = uId
        }

        var visual: Visual
        if let visualOptional = realm.objects(Visual.self).filter("filename = %@", filename).first {
            visual = visualOptional
        } else {
            visual = Visual()
            visual.filename = filename
        }
        
        try! realm.write {
            if let username = data["username"] as? String {
                visual.username = username
            } else if let username = data["owner"] as? String {
                visual.username = username
            }
            visual.audioMuted = data["audioMuted"] as? Bool ?? false
            if let preferredUsername = data["publicUsername"] as? String {
                visual.preferredUsername = preferredUsername
            }
            if let title = data["title"] as? String {
                visual.title = title
            }
//            if let uid = data["uid"] as? String {
//                visual.uid = uid
//            }
            if let audioUid = data["audioUID"] as? String {
                visual.audioUid = audioUid
            }
            if let totalLikes = data["totalLikes"] as? Float {
                visual.totalLikes = Int(totalLikes)
            }
            if let totalDislikes = data["totalDislikes"] as? Float {
                visual.totalDislikes = Int(totalDislikes)
            }
            if let views = data["views"] as? Float {
                visual.views = Int(views)
            }
            if let location = data["location"] as? String {
                visual.location = location
            }
            if let permission = data["permission"] as? String {
                visual.permission = permission
            }
            if let tags = data["tags"] as? [String] {
                visual.tags = tags.joined(separator: ",")
            } else if let tags = data["tags"] as? String, tags.count == 0 {
                visual.tags = tags
            }
            if let createdAtString = data["createdAt"] as? String {
                if let createdAt = Visual.dateFormatter.date(from: createdAtString) {
                    visual.createdAt = createdAt
                }
            }
            if let rank = data["rank"] as? Int {
                visual.YGWplace = rank
            }
            if let additionalData = data["additionalData"] as? [String: Any], !additionalData.isEmpty {
                if let createdAtString = additionalData["createdAt"] as? String {
                    if let createdAt = Visual.dateFormatter.date(from: createdAtString) {
                        visual.createdAt = createdAt
                    }
                }
                if let permission = additionalData["permission"] as? String {
                    visual.permission = permission
                }
            }
            
            if let animDict = data["animation"] as? NSDictionary {
                visual.animText = animDict["text"] as? String ?? ""
                visual.animStartAt = animDict["begin_at"] as? Double ?? 0.0
                visual.animEndAt = animDict["end_at"] as? Double ?? 0.0
                visual.animYPoint = animDict["y_point"] as? Double ?? 0.0
                let animTypeInt = animDict["type"] as? Int ?? 0
                visual.animType = animTypeInt
                let colorDict = animDict["color"] as? NSDictionary ?? ["red":0,"green":0,"blue":0,"alpha":1] as NSDictionary
                print(colorDict)
                let animColorDict = NSKeyedArchiver.archivedData(withRootObject: colorDict)
                visual.animColor = animColorDict
            }
            realm.add(visual, update: true)
        }
        
        func contentsParser(_ data: NSDictionary?, _ likes: Bool) {
            if let data = data,
                let contents = data["contents"] as? [String] {
                try! realm.write {
                    if likes {
                        visual.likedByUsers.removeAll()
                    } else {
                        visual.dislikedByUsers.removeAll()
                    }
                }
                for username in contents {
                    let user = User.toRealm(data: ["username": username] as NSDictionary)
                    try! realm.write {
                        if !visual.likedByUsers.contains(user) && likes {
                            visual.likedByUsers.append(user)
                        } else if !visual.dislikedByUsers.contains(user) && !likes {
                            visual.dislikedByUsers.append(user)
                        }
                        realm.add(user, update: true)
                        realm.add(visual, update: true)
                    }
                }
            }
        }
        contentsParser(data["likes"] as? NSDictionary, true)
        contentsParser(data["dislikes"] as? NSDictionary, false)

        return visual
    }

    static func getFor(_ username: String, completionHandler: @escaping ([Visual]?, String?) -> Void) {
        var url: String
        print(username)
        if let user = User.myUsername(), user == username {
            url = "getVisuals?owner=\(username)"
        } else {
            url = "getVisuals?owner=\(username)&permission=shared"
        }

        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: url,
                                     method: "GET", completionHandler: {(result, error) in
//                                        print(result)
//                                        print(error)
                                        var visualsDictionary = result?["visuals"] as? [[String: Any]]
                                        if let visuals = result?["filenames"] as? [String] {
                                            var resultVisuals: [Visual] = []
                                            for (index, visual) in visuals.enumerated() {
                                                let visualObject = Visual.toRealm(data: ["filename": visual, "additionalData": visualsDictionary?[index] ?? [], "username": username] as NSDictionary)
                                                resultVisuals.append(visualObject)
                                            }
                                            completionHandler(resultVisuals, nil)
                                        } else if let error = error {
                                            completionHandler(nil, error.localizedDescription)
                                        } else {
                                            completionHandler(nil, "Unexpected error")
                                        }
        })
    }

    func delete(_ handler: @escaping (Error?) -> (Void)) {
        if self.filename == User.me()?.weaklyVideo?.filename {
            try! Realm().write {
                User.me()?.weaklyVideo = nil
            }
        }
        _ = Session().sessionRequest(data: [:], to: "deleteVisual?uid=\(self.filename)", method: "DELETE", completionHandler: { result, error in
                handler(error)
        })
    }
    
    func getInfo(completionHandler: @escaping (Visual?, String?) -> Void) {
        if let username = self.username {
            _ = Session().sessionRequest(data: [:] as NSDictionary,
                                         to: "getVisual?owner=\(username)&uid=\(self.filename)&also=totalLikes,comments,likes,dislikes,totalDislikes",
                method: "GET", completionHandler: {
                    (result, error) in
                    if let result = result, error == nil {
                        if !Visual.isFilenameEmpty(visual: result) {
                            let visualObject = Visual.toRealm(data: result as NSDictionary)
                            completionHandler(visualObject, nil)
                        }
                    } else if let error = error {
                        if let statusCode = result?["statusCode"] as? Int64,
                            statusCode == 404 {
                            completionHandler(nil, "Seems that content does not exist on server =(")
                        }else {
                            completionHandler(nil, error.localizedDescription)
                        }
                    } else {
                        completionHandler(nil, "Unexpected error")
                    }
            })
        }

    }

    func likedByMe() -> Bool {
        return post(is: PostOperations.like)
    }

    func dislikedByMe() -> Bool {
        return post(is: PostOperations.dislike)
    }

    func make(operation: PostOperations, with completionHandler: @escaping (String?) -> Void) {
        print("101")
        guard let username = self.username else { return }
        onPostActionRequest(to: operation.rawValue, userName: username, with: completionHandler)
    }

    static func make( _ operation: VisualOperations,
                      _ videoUrl: URL,
                      _ filename: String?,
                      isMuted: Bool,
                      audioUid: String?,
                      audioStartsAt: Double,
                      title: String?,
                      tags: String?,
                      isPublic: Bool,
                      inContest: Bool = false,
                      completionHandler: @escaping (Visual?, String?) -> Void) {
        print("2")
        guard let username = User.myUsername() else { return }
        print("3")
        sendVisual( withOperation: operation, videoUrl, filename, isMuted: isMuted, audioUid: audioUid, audioStartsAt: audioStartsAt, title: title,
                    tags: tags, isPublic: isPublic, userName: username, inContest: inContest, completionHandler: completionHandler)

    }
    
    static func make( _ operation: VisualOperations,
                      _ videoUrl: URL,
                      _ filename: String?,
                      visual: Visual,
                      isPublic: Bool,
                      inContest: Bool = false,
                      completionHandler: @escaping (Visual?, String?) -> Void) {
        guard let username = User.myUsername() else { return }
        visual.filename = filename ?? UUID().uuidString
        testSendVisual(withOperation: operation, videoUrl, userName: username, visual: visual, inContest: inContest,isPublic: isPublic , completionHandler: completionHandler)
        
        if let username = UserDefaults.standard.string(forKey: AppConstants.nsudCognitoUsername) {
            User.getProfile(username) { user, error in
            }
        }
        
    }
    
    //MARK: - Refactor here!

    static func listVisuals(tag: String?, completionHandler: @escaping ([Visual]?, String?) -> Void) {

        var url = "listVisuals"
        if let tag = tag {
            url += "?tags=\(tag)&scope=global_shared"
        }
        _ = Session().sessionRequest(data: [:] as NSDictionary, to: url, method: "GET", completionHandler: {(result, error) in
            if let visuals = result?["visuals"] as? [NSDictionary] {
                var resultVisuals: [Visual] = []
                
                for visual in visuals {
                    if !isFilenameEmpty(visual: visual) {
                        let visualObject = Visual.toRealm(data: visual)
                        resultVisuals.append(visualObject)
                    }
                }
                
                completionHandler(resultVisuals, nil)
            } else if let error = error {
                completionHandler(nil, error.localizedDescription)
            } else {
                completionHandler(nil, "Unexpected error")
            }
        })
    }

    static func getWeekly(title: String?, start: Int, completionHandler: @escaping ([Visual]?, String?) -> Void) {
        let currentUserName = User.myUsername()
        var url = "getContestRange?start=\(start)&count=10"
        if let title = title {
            url += "&title=\(title)"
        }
        print(url)
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: url,
                                     method: "GET", completionHandler: {(result, error) in
                                        if let visuals = result?["visuals"] as? [NSDictionary] {
                                            var resultVisuals: [Visual] = []
                                            for visual in visuals {
                                                let visualObject = Visual.toRealm(data: visual as NSDictionary)
                                                resultVisuals.append(visualObject)
                                                if visualObject.username == currentUserName {
                                                    try? Realm().write {
                                                        User.me()?.weaklyVideo = visualObject
                                                    }
                                                }
                                            }
                                            completionHandler(resultVisuals, nil)
                                        } else if let error = error {
                                            completionHandler(nil, error.localizedDescription)
                                        } else {
                                            completionHandler(nil, "Unexpected error")
                                        }
        })
    }

    static func getWeeklyInfo(completionHandler: @escaping (NSDictionary?, String?) -> Void) {

        FileDownloader().downloadJSONFile {
            (errorDesk) in
            if let error = errorDesk {
                completionHandler(nil, error)
            } else {
                let downloadedFileURL =  URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("weekly-config.json")
                if let downloadedData = try? Data(contentsOf: downloadedFileURL) {
                    let dataString = String(data: downloadedData, encoding: .utf8)!
                    let validString = dataString.replacingOccurrences(of: "“", with: "\"").replacingOccurrences(of: "”", with: "\"")
                    let JSONData = validString.data(using: .utf8)
                    do {
                        let json = try JSONSerialization.jsonObject(with: JSONData!, options: [])
                        if let config = json as? NSDictionary{
                            completionHandler(config, nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completionHandler(nil, error.localizedDescription)
                    }
                }
            }
        }
    }

    func incrementViews(completionHandler: @escaping (String?) -> Void) {
        if let username = self.username {
            _ = Session().sessionRequest(data: ["owner": username, "uid": self.filename] as NSDictionary,
                                         to: "incrementViewsCounter",
                                         method: "POST", completionHandler: {
                                            (result, error) in
                                            if let _ = result {
                                                completionHandler(nil)
                                            } else if let error = error {
                                                completionHandler(error.localizedDescription)
                                            } else {
                                                completionHandler("Unexpected error")
                                            }
            })
        }
    }
    //MARK: - Private methods
    private func post(is postStatus: PostOperations) -> Bool {
        switch postStatus{
        case .like:
            return !Array(self.likedByUsers).filter { $0.username == User.myUsername() }.isEmpty
        case .dislike:
            return !Array(self.dislikedByUsers).filter { $0.username == User.myUsername() }.isEmpty
        default:
            fatalError("UnsupportedType!")
        }
    }
    private func onPostActionRequest( to requestStr: String, userName: String,
                                      with completionHandler: @escaping (String?) -> Void){

        _ = Session().sessionRequest(data: ["owner": userName, "uid": self.filename] as NSDictionary,
                                     to: requestStr,
                                     method: "POST", completionHandler: {(result, error) in
                                        if let _ = result {
                                            completionHandler(nil)
                                        } else if let error = error {
                                            completionHandler(error.localizedDescription)
                                        } else {
                                            completionHandler("Unexpected error")
                                        }
        })
    }
    private static func sendVisual( withOperation operation: VisualOperations, _ videoUrl: URL, _ filename: String?, isMuted: Bool, audioUid: String?, audioStartsAt: Double, title: String?, tags: String?, isPublic: Bool, userName: String, inContest: Bool = false, completionHandler: @escaping (Visual?, String?) -> Void) {
        
        FileUploader().uploadFile(filePath: videoUrl, type: "video", username: userName) {
            url, task in
            guard url != nil else {
                completionHandler(nil, "Unexpected error")
                return
            }
            
            let uid = filename ?? UUID().uuidString
            let json = [
                "uid": uid,
                "permission": isPublic ? "shared" : "private",
                ] as NSMutableDictionary
            if let title = title {
                json["title"] = title
            }
            if let audioUid = audioUid {
                json["audioUID"] = audioUid
                json["audioStartsAt"] = audioStartsAt * 1000
            }
            if let tags = tags {
                json["tags"] = tags
            }
            if inContest {
                json["inContest"] = inContest
            }
            json["audioMuted"] = isMuted
                
            _ = Session().sessionRequest(data: json,
                                         to: operation.rawValue,
                                         method: "POST", completionHandler: {
                                            (result, error) in
                                            if let _ = result {
                                                let visualData = [
                                                    "filename": uid,
                                                    "title": title,
                                                    "tags": tags,
                                                    "permission": isPublic ? "shared" : "private",
                                                    "username": userName,
                                                    "audioUID": audioUid
                                                ]
                                                
                                                let visualObject = Visual.toRealm(data: visualData as NSDictionary)
                                                completionHandler(visualObject, nil)
                                            } else if let error = error {
                                                completionHandler(nil, error.localizedDescription)
                                            } else {
                                                completionHandler(nil, "Unexpected error")
                                            }
            })
        }
    }
    
    //MARK: - new send visual method
    
    private static func testSendVisual( withOperation operation: VisualOperations, _ videoUrl: URL, userName: String, visual: Visual,inContest: Bool = false, isPublic: Bool, completionHandler: @escaping (Visual?, String?) -> Void) {
        
        FileUploader().uploadFile(filePath: videoUrl, type: "video", username: userName) {
            url, task in
            
            guard url != nil else {
                completionHandler(nil, "Unexpected error")
                return
            }
            
            let json = visual.toJson(inContest: inContest)
            json["permission"] = isPublic ? "shared" : "private"
            _ = Session().sessionRequest(data: json, to: operation.rawValue, method: "POST", completionHandler: { (result, error) in
        
                if let _ = result {
                    
                    let visualData = json
                    visualData["username"] = userName
                    let visualObject = Visual.toRealm(data: visualData)
                    completionHandler(visualObject, nil)
                    
                } else if let error = error {
                    completionHandler(nil, error.localizedDescription)
                } else {
                    completionHandler(nil, "Unexpected error")
                }
            })
        }
    }

    static func calculateRanking(title: String, completionHandler: @escaping (String?) -> Void) {
        _ = Session().sessionRequest(data: ["title": title] as NSDictionary, to: "calculateContestRankings", method: "POST", completionHandler: { (result, error) in
            if let _ = result {
                completionHandler(nil)
            } else if let error = error {
                completionHandler(error.localizedDescription)
            } else {
                completionHandler("Unexpected error")
            }
        })

    }
    
    func getEstimatedHeaderHeight() -> CGFloat {
        let size = CGSize(width: UIScreen.main.bounds.width - 40, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Light", size: 24)!]
        let title = self.title ?? " "
        let rectangleHeight = title.boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        print(rectangleHeight)
        return rectangleHeight
    }
    
    func getEstimatedFooterHeight() -> CGFloat {
        if let tags = self.tags {
            let arr = tags.split(separator: ",")
            if !arr.isEmpty {
                let tagsStr = convert(array: arr)
                let rectangleHeight = tagsStr.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: UIFont(name: "Helvetica-Light", size: 14)!)
                return rectangleHeight + 85
            } else {
                return 60
            }
        } else {
            return 60
        }
    }
    // MARK: Helpers
    func convert(array: [String.SubSequence]) -> String {
        var strArr = [String]()
        var tagsStr = String()
        for str in array {
            strArr.append(String(str))
        }
        for tag in strArr {
            tagsStr += "#" + tag + " "
        }
        return tagsStr
    }
    
    func toJson(inContest: Bool) -> NSMutableDictionary {
        
        let visual = self
        let uid = visual.filename
        let json = [
            "uid": uid,
            "permission": visual.isPublic ? "shared" : "private",
            ] as NSMutableDictionary
        
        
        
        if let title = visual.title {
            json["title"] = title
        }
        if let audioUid = visual.audioUid {
            json["audioUID"] = audioUid
            json["audioStartsAt"] = visual.audioDelay * 1000
        }
        if let tags = visual.tags {
            json["tags"] = tags
        }
        if inContest {
            json["inContest"] = inContest
        }
        
        let defColorDict = ["red":0,"green":0,"blue":0,"alpha":0]
        
        let colorDict = NSKeyedUnarchiver.unarchiveObject(with: visual.animColor ?? Data()) as? NSDictionary
        
        let animationData = ["text": visual.animText ?? " ",
                             "color": colorDict ?? defColorDict,
                             "begin_at": visual.animStartAt,
                             "end_at": visual.animEndAt,
                             "y_point": visual.animYPoint,
                             "type": visual.animType] as NSMutableDictionary
        if let _ = visual.animText {
            json["animation"] = animationData
        }
        json["audioMuted"] = visual.audioMuted
        YOLog.Log(message: json, from: "toJson", category: "Visual")
        return json
    }
    
    private static func isFilenameEmpty(visual: NSDictionary) -> Bool {
        if let _ = visual["filename"] {
            return false
        } else if let _ = visual["uid"] {
            return false
        }
        return true
    }
}
