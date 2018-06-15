import UIKit
extension UIViewController {
    
    func show(failure: String?, with title: String?, actionHandler: (() ->())? = nil) {
        let baseAlert = UIAlertController(title: title ?? "Error",
                                          message: failure ?? "Unexpected Error",
                                          preferredStyle: .alert)
        func alerActionHandler (_ action: UIAlertAction) {
            actionHandler?()
        }
        baseAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: alerActionHandler))
        self.present(baseAlert, animated: true, completion: nil)
    }
    
    func error(handler: (()->())?, for error: Error?) {
        
        if handler != nil {
            handler!()
        } else {
            self.show(failure: error?.localizedDescription , with: "Error")
        }
        
    }
    
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func showEngagement() {
        SimpleAlert.showInviteOffer(.toStore, message: "Know someone perfect for mīm?", delegate: self, dismissAfter: false)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension UILabel {
    
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    
}

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}

