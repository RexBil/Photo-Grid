

import UIKit



class IntroPageViewController: UIPageViewController{
    
    // Page View Controller init
	fileprivate(set) lazy var contentViewControllers: [UIViewController] = {
        var viewControllrsArr = [UIViewController]()
        var selectedIndex = 1
        for item in 0..<imageArr.count {
            viewControllrsArr.append(self.contentViewController(withIdentifier: "ImagePageViewController"))
        }
		return viewControllrsArr
	}()
    
	fileprivate var allowRotate: Bool = false
	
	override func viewDidLoad(){
		super.viewDidLoad()
		delegate = self
		dataSource = self
        self.view.backgroundColor = UIColor.black
        let initialViewController = contentViewControllers[SELECTINDEX]
        let controller = ImagePageViewController()
        selectedItem_image = (imageArr[SELECTINDEX] as? image)?.url ?? ""
        controller.viewDidLoad()
        contentViewController(followingViewController: initialViewController)
	}
    
	override func didReceiveMemoryWarning(){
		super.didReceiveMemoryWarning()
	}
}

// MARK : Page View Controller Navigation
extension IntroPageViewController{
	fileprivate func contentViewController(withIdentifier identifier: String) -> UIViewController{
		return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(identifier)")
	}
	
    fileprivate func contentViewController(followingViewController viewController: UIViewController, to direction: UIPageViewController.NavigationDirection = .forward){
		setViewControllers([viewController], direction: direction, animated: false){
			(finished) -> Void in
		}
	}
}

// MARK : Page View Controller Datasource & Delegate 
extension IntroPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
		
		let previous = index - 1
		
		guard previous >= 0 else { return nil }
		guard contentViewControllers.count > previous else { return nil }
        
        let controller = ImagePageViewController()
        selectedItem_image = (imageArr[previous] as? image)?.url ?? ""
        controller.viewDidLoad()
		return contentViewControllers[previous]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let index = contentViewControllers.firstIndex(of: viewController) else { return nil }
		
		let next = index + 1
		let count = contentViewControllers.count

		guard count != next else { return nil }
		guard count > next else { return nil }
        
        let controller = ImagePageViewController()
        selectedItem_image = (imageArr[next] as? image)?.url ?? ""
        controller.viewDidLoad()
		return contentViewControllers[next]
	}
}
