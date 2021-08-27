
import Foundation
import UIKit

public extension UIImageView {
    
    func setupForImageViewer(_ backgroundColor: UIColor = UIColor.white) {
        isUserInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: #selector(UIImageView.didTap(_:)), backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc internal func didTap(_ recognizer: ImageViewerTapGestureRecognizer) {        

    }
}

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    let backgroundColor: UIColor
    
    init(target: AnyObject, action: Selector, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        super.init(target: target, action: action)
    }
}
