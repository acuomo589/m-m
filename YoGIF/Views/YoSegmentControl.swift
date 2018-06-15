import Foundation
import UIKit

@objc protocol YoSegmentControlControlDelegate {
    func selectedItem(index: Int)
}

class YoSegmentControl: UIView {
    let segmentControl = UISegmentedControl()
    let bar = UIView()
    let selection = UIView()
    var selectionLeft = NSLayoutConstraint()
    var selectionWidth = NSLayoutConstraint()
    weak var delegate: YoSegmentControlControlDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        self.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bar.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        bar.layer.cornerRadius = 2

        self.addSubview(selection)
        selection.translatesAutoresizingMaskIntoConstraints = false
        selectionLeft = selection.leftAnchor.constraint(equalTo: self.leftAnchor)
        selectionLeft.isActive = true
        selectionWidth = selection.widthAnchor.constraint(equalToConstant: 44)
        selectionWidth.isActive = true
        selection.topAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
        selection.heightAnchor.constraint(equalToConstant: 3).isActive = true
        selection.backgroundColor = .white
        selection.layer.cornerRadius = 1

        self.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 0).isActive = true
        segmentControl.addTarget(self, action: #selector(onSegmentUpdate(_:)), for: .valueChanged)
        segmentControl.setDividerImage(UIImage(),
                forLeftSegmentState: .normal,
                rightSegmentState: .normal,
                barMetrics: .default)
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    }

    @objc func onSegmentUpdate(_ segment: UISegmentedControl) {
        changeSelection(animated: true)
        if let delegate = delegate {
            delegate.selectedItem(index: segment.selectedSegmentIndex)
        }
    }

    func changeSelection(animated: Bool) {
        let selected = segmentControl.selectedSegmentIndex
        let width = segmentControl.frame.width
        let segmentWith = width / CGFloat(segmentControl.numberOfSegments == 0 ? 1 : segmentControl.numberOfSegments)
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            self.selectionLeft.constant = segmentWith * CGFloat(selected)
            self.selectionWidth.constant = segmentWith
            self.layoutIfNeeded()
        }
    }

    func redraw(animated: Bool) {
        changeSelection(animated: false)
    }
}
