import UIKit
import QuartzCore
import AsyncDisplayKit

class GifCollectionCell: UICollectionViewCell {
    let gifView = GifView()
    let placeLabel = UILabel()

    var muted = true {
        didSet {
            gifView.muted = muted
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(placeLabel)
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        placeLabel.font = UIFont(name: "Helvetica-Light", size: 12)
        placeLabel.textColor = .white
        placeLabel.text = ""
        
        gifView.setup(sv: self.contentView)
        gifView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14).isActive = true
        gifView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        gifView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        gifView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        
    }
    
    func showVisual(_ visual: Visual) {
        print(visual.YGWplace)
        self.muted = true
        placeLabel.text = visual.rank
        self.gifView.loadVisual(visual)
    }
//    func showWeaklyVisula(_ visual: Visual) {
//        self.gifView.loadVisual(visual, place: true)
//    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
