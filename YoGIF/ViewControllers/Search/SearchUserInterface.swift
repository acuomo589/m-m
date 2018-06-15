import UIKit

extension SearchViewController {
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
        segmentControl.segmentControl.insertSegment(withTitle: "Moods", at: 0, animated: false)
        segmentControl.segmentControl.insertSegment(withTitle: "People", at: 1, animated: false)
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
        let cellSize = (screenWidth - 30*2)/2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection          = .vertical
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing       = 0

        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        collectionView.isPagingEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.tag = 1
        self.collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.collectionView.register(SearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: self.headerReuseId)
        self.collectionView.register(PeopleCollectionCell.self, forCellWithReuseIdentifier: self.reuseIdPeople)
        self.collectionView.register(MoodCollectionCell.self, forCellWithReuseIdentifier: self.reuseId)
        self.collectionView.register(GifListCollectionCell.self, forCellWithReuseIdentifier: self.visualReuseID)

        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.collectionView.addSubview(self.placeholderLabel)
        self.placeholderLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        self.placeholderLabel.textColor = .white
        self.placeholderLabel.textAlignment = .center
        self.placeholderLabel.text = "No results"
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.isHidden = true
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.placeholderLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.placeholderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.placeholderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        
    }
}
