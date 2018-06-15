import UIKit

extension FeedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifs.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gif = self.gifs[indexPath.row]
        //TODO: Need to update height after loading gif in gifview
        let headerHeight = gif.getEstimatedHeaderHeight()
        //let gifHeight = GifView.gifHeight()
        //let footerHeight = gif.getEstimatedFooterHeight()
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth, height: /*footerHeight*/headerHeight + GifView.gifViewHeight()/*gifHeight + headerHeight*/ + 36)
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                                                      for: indexPath) as! GifCollectionCell
        
        let gif = self.gifs[indexPath.row]
        cell.gifView.viewController = self
        cell.gifView.showDislikes = self.segmentControl.segmentControl.selectedSegmentIndex == 1
        cell.placeLabel.isHidden = self.segmentControl.segmentControl.selectedSegmentIndex == 0
        cell.showVisual(gif)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.segmentControl.segmentControl.selectedSegmentIndex == 1 {
            return CGSize(width: 320, height: 30)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 72
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader && self.segmentControl.segmentControl.selectedSegmentIndex == 1 {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind  : UICollectionElementKindSectionHeader,
                withReuseIdentifier: self.headerReuseId,
                for: indexPath) as! WeeklyInfoHeaderView
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(headerClicked))
            header.addGestureRecognizer(gesture)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            if let place = User.me()?.weaklyVideo?.rank {
                header.setup(text: "\(place) place", icon: #imageLiteral(resourceName: "participant"))
            } else if let infoTitle = weeklyInfo?["title"] as? String, let expireDate = weeklyInfo?["expire"] as? String, let date = dateFormatter.date(from: expireDate)  {
                print(date)
                let calendar = NSCalendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: Date())
                let date2 = calendar.startOfDay(for: date)
                
                
                
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                if let days = components.day {
                    if days >= 0 {
                        header.setup(text: "Tap here to submit", icon: #imageLiteral(resourceName: "ygwDaysCounter"))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.animate(headerView: header)
                        })
                    } else {
                        header.setup(text: "Contest has ended", icon: #imageLiteral(resourceName: "ygwDaysCounter"))
                    }
                } else {
                    header.setup(text: "Tap here to submit", icon: #imageLiteral(resourceName: "ygwDaysCounter"))
                }
            } else {
                header.setup(text: "Tap here to submit", icon: #imageLiteral(resourceName: "ygwDaysCounter"))
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    @objc func headerClicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let expireDate = weeklyInfo?["expire"] as? String, let date = dateFormatter.date(from: expireDate) {
            print(date)
            let calendar = NSCalendar.current
            let date1 = calendar.startOfDay(for: Date())
            let date2 = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let days = components.day {
                if days >= 0 {
                    if let userWeaklyVideo = User.me()?.weaklyVideo {
                        SimpleAlert.showAlert(title: "Sorry", alert: "Only one submission accepted to contest right now", actionTitles: "OK", delegate: self, callback: { (actionTag) in
                            let vc = GifInfoViewController()
                            vc.visual = userWeaklyVideo
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    } else if let infoTitle = weeklyInfo?["title"] as? String, let expireDate = weeklyInfo?["expire"] as? String, let prize = weeklyInfo?["copy"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        if let date = dateFormatter.date(from: expireDate) {
                            showWeeklyView(infoTitle, prize: prize, date: date)
                        } else {
                            showWeeklyView(infoTitle, prize: prize, date: Date())
                        }
                    }
                }
            }
        }
    }
    
    func animate(headerView: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: headerView.center.x - 6, y: headerView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: headerView.center.x + 6, y: headerView.center.y))
        headerView.layer.add(animation, forKey: "position")
    }
    
    
    
}


