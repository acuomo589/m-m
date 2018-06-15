import UIKit
import SVProgressHUD
import RealmSwift

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let titleLabel = UILabel()
    let headerReuseId = "headerReuseId"
    var collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout.init())
    let reuseId = "profileReuseId"
    var followers = [User]()
    var followings = [User]()
    var username: String?
    var user: User?
    var visuals = [Visual]()
    var followRequestActive = false
    let imagePicker = UIImagePickerController()
    let usersLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    var previewImages = [UIImage]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func isMe() -> Bool {
        if let username = User.myUsername() {
            return self.username == nil || self.username == username
        } else {
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewImages = []
        getProfile()
        getVisuals()
    }

    func getUsername() -> String? {
        if let username = self.username {
            return username
        } else if let u = User.myUsername() {
            return u
        } else {
            return nil
        }
    }

    func getVisuals() {
        if let u = getUsername() {
            Visual.getFor(u) {
                visuals, error in
                if let visuals = visuals {
                    self.visuals = visuals
                    self.visuals.sort {
                        if $0.createdAt != nil, $1.createdAt != nil {
                            return $0.createdAt! > $1.createdAt!
                        }
                        return false
                    }
                    if self.visuals.count > 0 {
                        self.getPreviewImages(index: 0, username: u)
                    }
                    for v in self.visuals {
                        print(v.createdAt!)
                    }
                    self.collectionView.reloadData()
                } else if let error = error {
                    _ = SimpleAlert.showAlert(alert: "User GIFs Download Error (#80NB): " + error, delegate: self)
                } else {
                    _ = SimpleAlert.showAlert(alert: "Unexpected error: User GIFs Download Error #95AC", delegate: self)
                }
            }
        }
    }

    func getPreviewImages(index: Int, username: String) {
        var idx = index
        if self.visuals.count > 0 {
            GeneralMethods.loadImage(visual: self.visuals[idx], username: username, callback: { (image) in
                self.previewImages.append(image)
                if self.visuals.count - 1 > idx {
                    idx += 1
                    self.getPreviewImages(index: idx, username: username)
                }
            })
        }
    }
    
    func getProfile() {
        if let u = getUsername() {
            User.getProfile(u) { user, error in
                if let user = user {
                    self.user = user
                    self.titleLabel.text = user.preferredUsername
                    self.followings = Array(user.following)
                    self.followers = Array(user.followers)
                    self.collectionView.reloadData()
                } else if let error = error {
                    _ = SimpleAlert.showAlert(alert: "User Profile Error (#294): " + error, delegate: self)
                } else {
                    _ = SimpleAlert.showAlert(alert: "Unexpected error: User Profile #019N", delegate: self)
                }
            }
        }
    }

    @objc func showFolowers( _ sender: UITapGestureRecognizer ){
        let usersList = UsersList()
        usersList.users = followers
        usersList.navTitle = "FOLLOWERS"
        self.navigationController?.pushViewController(usersList, animated: true)
    }
    @objc func showFollowings(_ sender: UITapGestureRecognizer) {
        let usersList = UsersList()
        usersList.navTitle = "FOLLOWING"
        usersList.users = followings
        self.navigationController?.pushViewController(usersList, animated: true)
    }
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showEditDialog(_ sender: UIButton) {
        let v = ProfileEditView()
        v.setup(sv: self.view, top: 220)
    }

    @objc func settingsTapped() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func followButtonTapped() {
        SVProgressHUD.show()
        if followRequestActive {
            return
        }
        if let myUsername = User.myUsername(), let username = self.getUsername(), let me = User.me(), let user = self.user {

            let follows = self.followers.filter { $0.username == myUsername }
            if follows.count > 0 {
                
                self.followRequestActive = true
                // remove follower locally, and update table data
                let realm = try! Realm()
                try! realm.write {
                    if let index = me.following.index(of: user) {
                        me.following.remove(at: index)
                        realm.add(me, update: true)
                    }
                    if let index = user.followers.index(of: me) {
                        user.followers.remove(at: index)
                        realm.add(user, update: true)
                    }
                }
                self.followings = Array(user.following)
                self.followers = Array(user.followers)
                self.collectionView.reloadData()

                User.unfollow(username, completionHandler: { (error) in
                    SVProgressHUD.dismiss()
                    self.followRequestActive = false
                    if let error = error {
                        _ = SimpleAlert.showAlert(alert: "Unfollow User Error (#961):" + error, delegate: self)
                    } else {
                        self.getProfile()
                    }
                })
            } else {
                // add follower locally, and update table data
                self.followRequestActive = true
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
                self.followings = Array(user.following)
                self.followers = Array(user.followers)
                self.collectionView.reloadData()

                User.follow(username, completionHandler: { (error) in
                    SVProgressHUD.dismiss()
                    self.followRequestActive = false
                    if let error = error {
                        _ = SimpleAlert.showAlert(alert: "Follow User Error (#858):" + error, delegate: self)
                    } else {
                        self.getProfile()
                    }
                })
            }
        }
    }

    @objc func onProfilePicChange() {
        let alert = UIAlertController(title: "Choose photo source", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) {
            (action) in

            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary

            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        })

        alert.addAction( UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = UIImagePickerControllerSourceType.camera
                image.allowsEditing = false
                self.present(image, animated: true, completion: {
                })
            }
            else {
                let msg = "It seems that you can't use camera on your device."
                _ = SimpleAlert.showAlert(alert: msg, delegate: self)
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let data = UIImageJPEGRepresentation(image, 0.8), let username = User.myUsername() {
            SVProgressHUD.show(withStatus: "Uploading")
            let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let remoteFileName = NSUUID().uuidString.lowercased()
            let fileExtension = "png"
            let targetURL = tempDirectoryURL.appendingPathComponent("\(remoteFileName).\(fileExtension)")
            try? data.write(to: targetURL)
            let fu = FileUploader()
            fu.uploadFile(filePath: targetURL, type: "profile_pic", username: username, completion: { (url, task) in
                SVProgressHUD.dismiss()
                if url != nil {
                    self.collectionView.reloadData()
                } else {
                    _ = SimpleAlert.showAlert(alert: "Failed to upload a profile picture. Please try again", delegate: self)
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}
