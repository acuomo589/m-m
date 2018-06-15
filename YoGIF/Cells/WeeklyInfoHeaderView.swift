import UIKit
import QuartzCore
import AsyncDisplayKit

class WeeklyInfoHeaderView: UICollectionReusableView {
    let ygwDaysCounter = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup(text:String = "Tap here to submit", icon: UIImage = #imageLiteral(resourceName: "ygwDaysCounter")) {
        self.clipsToBounds = true
        let bottomAnchor: CGFloat = icon == #imageLiteral(resourceName: "ygwDaysCounter") ? -4 : -6
        let ygwDaysCounterContainer = UIView()
        self.addSubview(ygwDaysCounterContainer)
        ygwDaysCounterContainer.translatesAutoresizingMaskIntoConstraints = false
        ygwDaysCounterContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: -10).isActive = true
        ygwDaysCounterContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        ygwDaysCounterContainer.widthAnchor.constraint(equalToConstant: 160).isActive = true
        ygwDaysCounterContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ygwDaysCounterContainer.backgroundColor = .white
        ygwDaysCounterContainer.layer.cornerRadius = 10

        self.addSubview(ygwDaysCounter)
        ygwDaysCounter.translatesAutoresizingMaskIntoConstraints = false
        ygwDaysCounter.bottomAnchor.constraint(equalTo: ygwDaysCounterContainer.bottomAnchor, constant: -5).isActive = true
        ygwDaysCounter.centerXAnchor.constraint(equalTo: ygwDaysCounterContainer.centerXAnchor, constant: 12).isActive = true
        ygwDaysCounter.backgroundColor = .clear
        ygwDaysCounter.layer.cornerRadius = 5
        ygwDaysCounter.text = text
        ygwDaysCounter.font = UIFont(name: "Helvetica", size: 14)

        let ygwDaysIcon = UIImageView(image: #imageLiteral(resourceName: "ygwDaysCounter"))
        ygwDaysIcon.image = icon
        self.addSubview(ygwDaysIcon)
        ygwDaysIcon.translatesAutoresizingMaskIntoConstraints = false
        ygwDaysIcon.bottomAnchor.constraint(equalTo: ygwDaysCounterContainer.bottomAnchor, constant: bottomAnchor).isActive = true
        ygwDaysIcon.centerXAnchor.constraint(equalTo: ygwDaysCounterContainer.centerXAnchor, constant: -60).isActive = true

        ygwDaysIcon.backgroundColor = .clear
    }
}

