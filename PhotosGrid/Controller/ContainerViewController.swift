

import UIKit

class ContainerViewController: UIViewController {
    //ContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
       

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerView" {
          if let childVC = segue.destination as? IntroPageViewController {
          }
        }
    }
}
