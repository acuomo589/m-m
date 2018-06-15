import UIKit

class GifsListViewController: UIViewController {
    let titleLabel = UILabel()
    var collectionView = UICollectionView(frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout.init())
    let reuseId = "listReuseId"
    var moodTag: String?
    var gifs = [Visual]()
    var color = AppConstants.colorGreen
    
    let placeholderLabel = UILabel()
    
    var previewImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = color
        if let tag = moodTag {
            titleLabel.text = tag
            Visual.listVisuals(tag: tag) { visuals, error in
                if let visuals = visuals {
                    if visuals.count > 0 {
                        self.placeholderLabel.isHidden = true
                    } else {
                        self.placeholderLabel.isHidden = false
                    }
                    self.gifs = visuals
                    self.getPreviewImages(index: 0)
                    self.collectionView.reloadData()
                } else if let error = error {
                    self.placeholderLabel.isHidden = false
                    _ = SimpleAlert.showAlert(alert: "Failed to get GIFs for tag (#058): " + error, delegate: self)
                } else {
                    self.placeholderLabel.isHidden = false
                    _ = SimpleAlert.showAlert(alert: "Unexpected error: Failed to get GIFs for tag (#8AC)", delegate: self)
                }
            }
        }
    }

    func getPreviewImages(index: Int) {
        var idx = index
        if self.gifs.count > 0 {
            if let username = self.gifs[idx].username {
                GeneralMethods.loadImage(visual: self.gifs[idx], username: username, callback: { (image) in
                    self.previewImages.append(image)
                    if self.gifs.count - 1 > idx {
                        idx += 1
                        self.getPreviewImages(index: idx)
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorGreen
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
