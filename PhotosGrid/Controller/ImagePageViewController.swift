

import UIKit

var selectedItem_image = ""

class ImagePageViewController: UIViewController {
    
    fileprivate let kMaxImageScale: CGFloat = 10.0
    fileprivate let kMinImageScale: CGFloat = 1.0
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var panOrigin: CGPoint!
    
    fileprivate var isAnimating = false
    fileprivate var isLoaded = false
    fileprivate let windowBounds = UIScreen.main.bounds
    
    
    @IBOutlet weak var scrollview: UIScrollView?
    @IBOutlet weak var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview?.delegate = self
        configureScrollView()
        configureImageView()
    }

    func configureScrollView() {
        scrollview?.minimumZoomScale = kMinImageScale
        scrollview?.maximumZoomScale = kMaxImageScale
        scrollview?.zoomScale = 0.5
    }
    
    func configureImageView() {
        imageView?.kf.setImage(with: URL(string: selectedItem_image))
        addPanGestureToView()
        addGestures()
        centerScrollViewContents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension ImagePageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        panOrigin = imageView?.frame.origin
        gestureRecognizer.isEnabled = true
        return !isAnimating
    }
    
    // MARK: - Gestures
    func addPanGestureToView() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(ImagePageViewController.gestureRecognizerDidPan(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        
        imageView?.addGestureRecognizer(panGesture)
    }
    
// MARK : TapGestur for Zoom
    func addGestures() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImagePageViewController.didSingleTap(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        scrollview?.addGestureRecognizer(singleTapRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImagePageViewController.didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollview?.addGestureRecognizer(doubleTapRecognizer)
        
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
    }
 
    @objc func gestureRecognizerDidPan(_ recognizer: UIPanGestureRecognizer) {
        if scrollview?.zoomScale != 1.0 || isAnimating {
            return
        }
        scrollview?.bounces = false
        let currentPoint = panGesture.translation(in: scrollview)
        let y = currentPoint.y + panOrigin.y
        
        imageView?.frame.origin = CGPoint(x: currentPoint.x + panOrigin.x, y: y)
        
    }
    
    @objc func didSingleTap(_ recognizer: UITapGestureRecognizer) {
        scrollview?.setZoomScale(1.0, animated: true)
    }
    
    @objc func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: imageView)
        zoomInZoomOut(pointInView)
    }
}
// MARK : ScrollView Delegate
extension ImagePageViewController: UIScrollViewDelegate {
    
    fileprivate func centerScrollViewContents() {
        let boundsSize = self.view.bounds.size
        var contentsFrame = imageView?.frame ?? self.view.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView?.frame = contentsFrame
    }
    
    func zoomInZoomOut(_ point: CGPoint) {
        let newZoomScale = (scrollview?.zoomScale ?? 250) > ((scrollview?.maximumZoomScale ?? 250) / 2) ? scrollview?.minimumZoomScale : scrollview?.maximumZoomScale ?? 250
        
        let scrollViewSize = scrollview?.bounds.size ?? self.view.bounds.size
        let w = scrollViewSize.width / (newZoomScale ?? 200)
        let h = scrollViewSize.height / (newZoomScale ?? 50)
        let x = point.x - (w / 2.0)
        let y = point.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
        
        scrollview?.zoom(to: rectToZoomTo, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        isAnimating = true
        centerScrollViewContents()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        isAnimating = false
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
