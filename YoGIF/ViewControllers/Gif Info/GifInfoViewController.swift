import UIKit
import SVProgressHUD
import RealmSwift

class GifInfoViewController: UIViewController {

    //MARK: - Properties
    let gifView = GifViewSingle.shared.gifView
    var visual: Visual?
    let titleLabel = UILabel()
    var editButton: UIBarButtonItem!
    
    var gifInfoHeightConstraint = NSLayoutConstraint()

    //MARK: - Lifecycle evnets
    override func viewDidLoad() {
        super.viewDidLoad()
        //gifView.removePlayer()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let visual = self.visual {
            registerObservers()
            if visual.filename == User.me()?.weaklyVideo?.filename {
                editButton.tintColor = UIColor.clear
            }
            self.gifView.muted = false
            gifView.loadVisual(visual)
            self.setGifViewHeight(visual: visual)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.gifView.player.muted = false
            })
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        gifView.muted = true
        removeObservers()
    }

    //MARK: - Actions
    @objc func visualDidLoad(notification: Notification) {
        if let uInfo = notification.userInfo {
            if let visual = uInfo["Visual"] as? Visual {
                if visual.filename == self.visual?.filename {
                    self.setGifViewHeight(visual: visual)
                }
            }
        }
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onEditTapped() {
        if let visual = self.visual {
            if let _ = visual.file() {
                let vc = VideoViewController()
                EditedVideo.shared.videoUrl = visual.file()
                EditedVideo.shared.audioUrl = visual.audioFile()
                vc.visual = visual
                vc.visualName = gifView.title.text
                vc.navigationItem.title = "EDIT"
                vc.titleLabel.text = "EDIT"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @objc func onDeleteGifTapped() {
        let warning = UIAlertController(title: "Warning", message: "Are you sure you want to delete this Mīm?", preferredStyle: .alert)
        warning.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        warning.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [unowned self] _ in
            SVProgressHUD.show(withStatus: "Deleting your Mīm")
            self.visual?.delete() {
                error in
                if let errorString = error?.localizedDescription {
                    SVProgressHUD.showError(withStatus: errorString)
                } else {
                    try! Realm().write { User.me()?.weaklyVideo = nil}
                    SVProgressHUD.showSuccess(withStatus: "All clear")

                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        present(warning, animated: true, completion: nil)
    }
    //MARK: Helpers
    func setGifViewHeight(visual: Visual) {
        let headerHeight = visual.getEstimatedHeaderHeight()
        let gifHeight = GifView.gifHeight()
        let footerHeight = visual.getEstimatedFooterHeight()
        let height = GifView.gifViewHeight() + headerHeight + 36
        self.gifInfoHeightConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(visualDidLoad), name: AppConstants.notificationVisualLoaded, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: AppConstants.notificationVisualLoaded, object: nil)
    }
}
