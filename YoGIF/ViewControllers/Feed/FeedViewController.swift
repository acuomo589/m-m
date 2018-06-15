import UIKit
import SVProgressHUD

class FeedViewController: UIViewController, YoSegmentControlControlDelegate {
    let segmentControl = YoSegmentControl()
    var collectionView = UICollectionView(frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout.init())
    let loadingIndicator = UIActivityIndicatorView()
    let reuseId = "feedReuseId"
    let headerReuseId = "headerReuseId"
    var gifs = [Visual]()
    var feed = [Visual]()
    var weekly = [Visual]()
    var weeklyInfo: NSDictionary?
    var yoWeekly: YoWeeklyView?
    var yoGifWeeklyTitle: String?
    
    var scrollPosition = CGPoint()

    override func viewDidLoad() {
        super.viewDidLoad()

        if  UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId) == nil {
            User.getPersonalS3Access(completionHandler: { (error) in
                if let error = error {
                    print("failed to restore session: \(error)")
                } else {
                    Visual.getWeeklyInfo { (infoDict, error) in
                        if let infoDict = infoDict {
                            print(infoDict)
                            self.weeklyInfo = infoDict
                            self.updateWeekly()
                        } else if let error = error {
                            _ = SimpleAlert.showAlert(alert: "Weekly Contest Error #150: " + error, delegate: self)
                        } else {
                            _ = SimpleAlert.showAlert(alert: "Unexpected error: Weekly Contest #182", delegate: self)
                        }
                    }
                    print("got s3 access")
                }
            })
        }
        setupUI()
        segmentControl.segmentControl.selectedSegmentIndex = 1

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControl.redraw(animated: false)
        if UserDefaults.standard.bool(forKey: AppConstants.nsudCognitoSessionRefreshing) == false {
            updateData()
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onSessionRestored),
            name: AppConstants.notificationSessionRestored,
            object: nil)
        
        checkForFirstTime()
        
//        let vc = HowItWorksViewController()
//        vc.isYouWon = true
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
    }

    func checkForFirstTime() {
        if self.segmentControl.segmentControl.selectedSegmentIndex == 1 {
            if let _ = self.tabBarController?.view, User.me()?.weaklyVideo == nil,
                !UserDefaults.standard.bool(forKey: AppConstants.nsudYGW){
                if let title = weeklyInfo?["title"] as? String, let expireDate = weeklyInfo?["expire"] as? String, let prize = weeklyInfo?["copy"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: expireDate) {
                        showWeeklyView(title, prize: prize, date: date)
                    } else {
                        showWeeklyView(title, prize: prize, date: Date())
                    }
                } else {
                    _ = SimpleAlert.showAlert(alert: "Still downloding Weekly info", delegate: self)
                    segmentControl.segmentControl.selectedSegmentIndex = 0
                    segmentControl.redraw(animated: true)
                }
            }
        }
    }
    
    @objc func onSessionRestored() {
        updateData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // we don't want sounds to play when user leaves the screen. clear the CollectionView
        for cell in self.collectionView.visibleCells {
            if let cell = cell as? GifCollectionCell {
                self.mutePlayer(cell: cell)
            }
        }
        //self.gifs = []
        //self.collectionView.reloadData()
        NotificationCenter.default.removeObserver(self, name: AppConstants.notificationSessionRestored, object: nil)
    }

    func mutePlayer(cell: GifCollectionCell) {
        cell.gifView.muted = true
    }
    
    func updateData() {
        Visual.listVisuals(tag: nil) { visuals, error in
            if let visuals = visuals {
                let sortedVisuals = visuals.sorted(by: { (v1, v2) -> Bool in
                    if let v1c = v1.createdAt, let v2c = v2.createdAt {
                        return v1c > v2c
                    } else {
                        return false
                    }
                })
                print(sortedVisuals)
                if self.segmentControl.segmentControl.selectedSegmentIndex == 0 {
                    self.gifs = sortedVisuals
                    self.collectionView.reloadData()
                }
                self.feed = sortedVisuals
            } else if let error = error {
                _ = SimpleAlert.showAlert(alert: "GIF Feed Error: " + error, delegate: self)
            } else {
                _ = SimpleAlert.showAlert(alert: "Unexpected error: Gif Feed", delegate: self)
            }
        }
        if weeklyInfo == nil {
            loadingIndicator.startAnimating()
        } else {
            SVProgressHUD.show()
        }
        Visual.getWeeklyInfo { (infoDict, error) in
            self.loadingIndicator.stopAnimating()
            SVProgressHUD.dismiss()
            if let infoDict = infoDict {
                print(infoDict)
                self.weeklyInfo = infoDict
//                self.collectionView.reloadData()
                self.updateWeekly()
            } else if let error = error {
                _ = SimpleAlert.showAlert(alert: "Weekly Contest Info Error #1209: " + error, delegate: self)
            } else {
                _ = SimpleAlert.showAlert(alert: "Unexpected error: Weekly Contest Error #0931", delegate: self)
            }
        }
    }

    func updateWeekly() {
        print("weeklyArray")
        //print(weeklyInfo)
        if let title = weeklyInfo?["title"] as? String {
            // first, manually update rankings,
            // then get weekly visuals
            Visual.calculateRanking(title: title) { error in
                if let error = error {
                    _ = SimpleAlert.showAlert(alert: "Ranking Calculation Error: " + error, delegate: self)
                } else {
                    Visual.getWeekly(title: title, start: 0) {
                        [unowned self] visuals, error in
                        if let visuals = visuals {
                            // server does not filter duplicates, so we will
                            // handle it here
//                            self.collectionView.reloadSections(IndexSet(0 ..< 2))
                            var filteredVisuals = [Visual]()
                            visuals.forEach { (visual) -> () in
                                if !filteredVisuals.contains (where: { $0.username == visual.username }) {
                                    filteredVisuals.append(visual)
                                }
                            }
                            // sort by position
                            filteredVisuals = filteredVisuals.sorted(by: { $0.YGWplace < $1.YGWplace })

                            if self.segmentControl.segmentControl.selectedSegmentIndex == 1 {
                                self.gifs = filteredVisuals
                                self.collectionView.reloadData()
                            }
                            self.weekly = filteredVisuals
                        } else if let error = error {
                            _ = SimpleAlert.showAlert(alert: "Weekly Contest Feed Error #1901: " + error, delegate: self)
                        } else {
                            _ = SimpleAlert.showAlert(alert: "Unexpected error: Weekly Contest Feed #01481", delegate: self)
                        }
                    }
                }
            }
        }
    }

    @objc func onGoTapped() {
        if let yoWeeklyLocal = self.yoWeekly, let weeklyTitle = yoGifWeeklyTitle {
            yoWeeklyLocal.close()
            let vc = CameraViewController()
            YOLog.Log(message: weeklyTitle, from: "weeklyTitle", category: "Contest")
            EditedVideo.shared.weeklyTitle = weeklyTitle
            vc.yoGifWeeklyTitle = weeklyTitle
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }

    func selectedItem(index: Int) {
        for cell in self.collectionView.visibleCells {
            if let cell = cell as? GifCollectionCell {
                cell.muted = true
            }
        }
        if index == 1 {
            self.gifs = self.weekly
            self.collectionView.reloadData()
            if let _ = self.tabBarController?.view, User.me()?.weaklyVideo == nil,
                !UserDefaults.standard.bool(forKey: AppConstants.nsudYGW){
                if let title = weeklyInfo?["title"] as? String, let expireDate = weeklyInfo?["expire"] as? String, let prize = weeklyInfo?["copy"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: expireDate) {
                        showWeeklyView(title, prize: prize, date: date)
                    } else {
                        showWeeklyView(title, prize: prize, date: Date())
                    }
                } else {
                    _ = SimpleAlert.showAlert(alert: "Still downloding Weekly info", delegate: self)
                    segmentControl.segmentControl.selectedSegmentIndex = 0
                    segmentControl.redraw(animated: true)
                }
            }
            self.scrollToSavedPosition()
        } else {
            self.gifs = self.feed
            self.collectionView.reloadData()
            self.scrollToSavedPosition()
        }
    }
    
    func scrollToSavedPosition() {
        let containerPoint = self.collectionView.contentOffset
        self.collectionView.setContentOffset(containerPoint, animated: false)
        self.collectionView.setContentOffset(self.scrollPosition, animated: false)
        self.scrollPosition = containerPoint
    }
    
    func showWeeklyView( _ title: String, prize: String, date: Date) {
        self.yoGifWeeklyTitle = title
        let yoWeeklyLocal = YoWeeklyView()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        yoWeeklyLocal.setup(superview: (self.tabBarController?.view)!, topicString: title, prizeString: prize, expiresString: formatter.string(from: date))
        yoWeeklyLocal.button.addTarget(self, action: #selector(onGoTapped), for: .touchUpInside)
        self.yoWeekly = yoWeeklyLocal
        UserDefaults.standard.set(true, forKey: AppConstants.nsudYGW)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let screenCenterY = self.view.bounds.height / 2
        for cell in self.collectionView.visibleCells {
            
            let point = CGPoint(x: cell.bounds.origin.x, y: cell.bounds.origin.y)
            let pointInView = cell.convert(point, to: self.view)

            if let cell = cell as? GifCollectionCell {
                if pointInView.y < -80 {
                    cell.muted = true
                    cell.gifView.player.pause()
                } else {
                    if pointInView.y < screenCenterY {
                        cell.gifView.player.play()
                    } else {
                        cell.muted = true
                        cell.gifView.player.pause()
                    }
                }
            }
        }
    }
}
