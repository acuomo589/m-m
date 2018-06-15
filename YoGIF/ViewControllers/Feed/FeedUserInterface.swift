import UIKit

extension FeedViewController {

    func setupUI() {
        self.view.backgroundColor = AppConstants.colorDarkBlue

        let navHeader = UIView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        navHeader.widthAnchor.constraint(equalToConstant: 150).isActive = true
        navHeader.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navHeader.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        segmentControl.topAnchor.constraint(equalTo: navHeader.topAnchor, constant: 0).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: navHeader.bottomAnchor, constant: 0).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: navHeader.leftAnchor, constant: 0).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: navHeader.rightAnchor, constant: 0).isActive = true
        segmentControl.segmentControl.insertSegment(withTitle: "Feed", at: 0, animated: false)
        segmentControl.segmentControl.insertSegment(withTitle: "Contest", at: 1, animated: false)
        segmentControl.segmentControl.selectedSegmentIndex = 0
        segmentControl.redraw(animated: false)
        segmentControl.delegate = self
        self.navigationItem.titleView = navHeader

        let background = UIImageView()
        self.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        background.backgroundColor = .lightGray
        background.image = #imageLiteral(resourceName: "loginBg")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        

        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: GifView.gifViewHeight()+36)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 72
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0)
        layout.sectionHeadersPinToVisibleBounds = true
        
        //self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.isPagingEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.tag = 1
        self.collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.collectionView.register(GifCollectionCell.self, forCellWithReuseIdentifier: self.reuseId)
        self.collectionView.register(WeeklyInfoHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                     withReuseIdentifier: self.headerReuseId)
        self.collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        loadingIndicator.tintColor = .white
        loadingIndicator.color = .white
    }
}
