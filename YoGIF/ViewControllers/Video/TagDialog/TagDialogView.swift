import UIKit
import WSTagsField

class TagDialogView: UIView, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var delegate: VideoViewController?
    let tagsField = WSTagsField()
    var buttons = ["LOL", "WTF", "OMG", "FML", "SMH", "YAS"]
    var colors = [
        AppConstants.colorGreen,
        AppConstants.colorRed,
        AppConstants.colorYellow,
        AppConstants.colorDarkBlueBG,
        AppConstants.colorGray,
        AppConstants.colorPink
    ]
    let reuseId = "tagreuseId"
    var currentUrl: URL?
    let holderView = UIImageView(image: #imageLiteral(resourceName: "hashTagHolder"))
    let topBar = UIView()

    func setup(sv: UIView, anchorTo: UIButton, delegate: VideoViewController, tags: [String]) {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.delegate = delegate
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: anchorTo.topAnchor, constant: -4).isActive = true
        self.heightAnchor.constraint(equalToConstant: 260).isActive = true
        self.leftAnchor.constraint(equalTo: sv.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: sv.rightAnchor, constant: 0).isActive = true
        self.clipsToBounds = false
        self.backgroundColor = .clear
        
        self.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        holderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        holderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        holderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        self.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: holderView.rightAnchor).isActive = true
        topBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topBar.backgroundColor = AppConstants.colorGreen
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 16).isActive = true
        closeButton.rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        closeButton.setImage(#imageLiteral(resourceName: "weeklyClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.contentMode = .scaleAspectFit
        
        
        let title = UILabel()
        topBar.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: topBar.centerXAnchor).isActive = true
        title.text = "TAGS"
        title.font = UIFont(name: "Helvetica-Bold", size: 20)
        title.textColor = .white

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 30)
        layout.scrollDirection          = .horizontal
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing       = 10
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GifTagCollectionView.self, forCellWithReuseIdentifier: self.reuseId)
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -42).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let suggestedMoodsLabel = UILabel()
        suggestedMoodsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(suggestedMoodsLabel)
        suggestedMoodsLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -3).isActive = true
        suggestedMoodsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        suggestedMoodsLabel.heightAnchor.constraint(equalToConstant: 14)
        suggestedMoodsLabel.text = "Suggested Moods"
        suggestedMoodsLabel.textColor = .lightGray
        suggestedMoodsLabel.font = UIFont(name: "Helvetica", size: 12)

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separator)
        separator.bottomAnchor.constraint(equalTo: suggestedMoodsLabel.bottomAnchor, constant: 3).isActive = true
        separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        separator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = UIColor(white: 0, alpha: 0.2)


        tagsField.backgroundColor = UIColor.clear
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tagsField)
        tagsField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        tagsField.rightAnchor.constraint(equalTo: holderView.rightAnchor).isActive = true
        tagsField.heightAnchor.constraint(equalToConstant: 110).isActive = true
        tagsField.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 5).isActive = true

        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFont(ofSize: 12.0)
        tagsField.tintColor = AppConstants.colorGray
        tagsField.textColor = .white
        tagsField.fieldTextColor = .black
        tagsField.delimiter = ""
        tagsField.font = .systemFont(ofSize: 16.0)
        tagsField.returnKeyType = .done

        for tag in tags {
            tagsField.text = tag
            tagsField.tokenizeTextFieldText()
        }

        tagsField.onShouldReturn = {
            [weak self]_ in
            self?.tagsField.endEditing()
            return true
        }
        tagsField.onDidChangeText = {_, text in
            if text?.last == "," || text?.last == " " {
                self.tagsField.tokenizeTextFieldText()
            }
        }

        let doneButton = UIButton()
        self.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -26).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.setImage(#imageLiteral(resourceName: "rightArrowWhite"), for: .normal)
        doneButton.backgroundColor = AppConstants.colorGreen
        doneButton.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        doneButton.layer.cornerRadius = 20
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topBar.roundTopCorners(20.0)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.buttons.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                                                      for: indexPath) as! GifTagCollectionView
        let button = self.buttons[indexPath.row]
        cell.title.text = button
        cell.container.backgroundColor = self.colors[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let button = self.buttons[indexPath.row]
        if let text = tagsField.text {
            tagsField.text = text + "" + button
            tagsField.tokenizeTextFieldText()
        }

    }

    @objc func close() {
        delegate?.hashtagTapped()
    }

    @objc func onDone() {
        if let delegate = delegate {
            var tags = [String]()
            for t in tagsField.tags {
                tags.append(t.text)
            }
            delegate.saveTags(tags)
        }
        self.close()
    }
}


class GifTagCollectionView: UICollectionViewCell {
    let title = UILabel()
    let container = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        container.layer.cornerRadius = 5

        container.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        title.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
        title.textAlignment = .center
        title.textColor = .white
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

