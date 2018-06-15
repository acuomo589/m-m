import UIKit
import SVProgressHUD
import RealmSwift

class SearchViewController: UIViewController, YoSegmentControlControlDelegate {
    let segmentControl = YoSegmentControl()
    var collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let placeholderLabel = UILabel()
    
    let reuseId = "searchReuseId"
    var searchField: UITextField?
    let reuseIdPeople = "peopleReuseId"
    let headerReuseId = "headerReuseId"
    let visualReuseID = "visualsByTag"
    var mode = 0
    var tagsSearch = false
    var following = [User]()
    var visuals = [Visual]()
    var firstOpen = true
    let moods = [
        ["title": "LOL", "image": #imageLiteral(resourceName: "Group 7") , "color": AppConstants.colorLol],
        ["title": "WTF", "image": #imageLiteral(resourceName: "Group 10") , "color": AppConstants.colorWtf],
        ["title": "OMG", "image": #imageLiteral(resourceName: "Group 8") , "color": AppConstants.colorOmg ],
        ["title": "FML", "image": #imageLiteral(resourceName: "Group 12") , "color": AppConstants.colorFml] ,
        ["title": "SMH", "image": #imageLiteral(resourceName: "Group 9") , "color": AppConstants.colorSmh],
        ["title": "YAS", "image": #imageLiteral(resourceName: "Group 18"), "color": AppConstants.colorYas]
    ]
    var users = [User]()
    //        ["username": "@username", "name": "John Smith", "isFriend": false],
    //        ["username": "@username", "name": "John Smith", "isFriend": false],
    //        ["username": "@username", "name": "John Smith", "isFriend": true],
    //        ["username": "@username", "name": "John Smith", "isFriend": true],
    //        ["username": "@username", "name": "John Smith", "isFriend": true],
    //        ["username": "@username", "name": "John Smith", "isFriend": true]
    //    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControl.redraw(animated: false)
        if !firstOpen {
            // we can't access server when this screen is just rendered - we are still waiting
            // for a new Access Token from server.
            getFollowings()
        } else {
            firstOpen = false
        }
    }

    func selectedItem(index: Int) {
        
        if index == 0 {
            self.placeholderLabel.isHidden = true
        }
        
        tagsSearch = false
        if let textField = self.searchField {
            textField.text = ""
        }
        mode = index
        self.collectionView.reloadData()
    }

    func getFollowings() {
        if let username = User.myUsername() {
            User.getProfile(username) { (user, error) in
                if let user = user {
                    self.following = Array(user.following)
                    self.collectionView.reloadSections(IndexSet(integer: 1))
                } else if let error = error {
                    _ = SimpleAlert.showAlert(alert: "Get User Profile Error #195: " + error, delegate: self)
                } else {
                    _ = SimpleAlert.showAlert(alert: "Unexpected error: Get User Profile #196", delegate: self)
                }
            }
        }
    }

    func onSearch(_ string: String) {
        if mode == 0 {
            if string.count < 1 {
                return
            }
            // If we want to open results in new screen, use this:
            let vc = GifsListViewController()
            vc.moodTag = string
            vc.color = AppConstants.colorGreen
            self.navigationController?.pushViewController(vc, animated: true)

            // If we want to show results in current screen, use this:
//            if string.count == 0 {
//                tagsSearch = false
//                self.visuals.removeAll()
//                self.collectionView.reloadSections(IndexSet(integer: 1))
//                return
//            } else if string.count >= 3 {
//                tagsSearch = true
//                Visual.listVisuals(tag: string.uppercased()) {
//                    visuals, error in
//                    if let visuals = visuals {
//                        if let text = self.searchField?.text, text.count > 0 {
//                            self.visuals = visuals
//                            self.collectionView.reloadSections(IndexSet(integer: 1))
//                        }
//                    } else if let error = error {
//                        _ = SimpleAlert.showAlert(alert: error, delegate: self)
//                    } else {
//                        _ = SimpleAlert.showAlert(alert: "Unexpected error", delegate: self)
//                    }
//                }
//            }
        } else {
            placeholderLabel.isHidden = true
            if string.count == 0 {
                self.users.removeAll()
                self.collectionView.reloadSections(IndexSet(integer: 1))
                return
            } else if string.count >= 3 {
                // search users
                User.findUsers(query: string) { users, error in
                    if let users = users {
                        if users.count > 0 {
                            self.placeholderLabel.isHidden = true
                        } else {
                            self.placeholderLabel.isHidden = false
                        }
                        if let text = self.searchField?.text, text.count > 0 {
                            self.users = users.filter({ (user) -> Bool in
                                user.username != User.myUsername()
                            })
                            self.collectionView.reloadSections(IndexSet(integer: 1))
                        }
                    } else if let error = error {
                        self.placeholderLabel.isHidden = false
                        _ = SimpleAlert.showAlert(alert: "User Search Error: " + error, delegate: self)
                    } else {
                        self.placeholderLabel.isHidden = false
                        _ = SimpleAlert.showAlert(alert: "Unexpected error: User Search", delegate: self)
                    }
                }
            }
        }
    }

    
    
    func onFollowTap(_ user: User) {

        if let me = User.me() {
            let realm = try! Realm()
            try! realm.write {
                if !me.following.contains(user) {
                    me.following.append(user)
                    realm.add(me, update: true)
                }
                if !user.followers.contains(me) {
                    user.followers.append(me)
                    realm.add(user, update: true)
                }
            }
            self.following = Array(me.following)
            self.collectionView.reloadData()//reloadSections(IndexSet(integer: 1))
        }


        User.follow(user.username) { error in
            SVProgressHUD.dismiss()
            if let error = error {
                _ = SimpleAlert.showAlert(alert: "User Follow Error #960: " + error, delegate: self)
            } else {
                self.following.append(user)
                self.collectionView.reloadData()//reloadSections(IndexSet(integer: 1))
            }
        }

    }
}
