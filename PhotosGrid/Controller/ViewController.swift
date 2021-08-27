


import UIKit
import Kingfisher

var imageArr:[Codable] = []
var SELECTINDEX:Int = 0

class ViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var actloder:UIActivityIndicatorView?
    
    var model:[Codable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        actloder?.startAnimating()
        
        guard ConnectionCheck.isConnectedToNetwork() else{
            let alert = UIAlertController(title: "Photo Grid", message: "Please check your internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        fetch()
    }
}

// MARK : Collection view Datasource & Delegate
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CustomCollectionViewCell
        let imageUrl = (model[indexPath.row] as? image)?.url
        if imageUrl != ""{
            
            cell?.imgPhoto?.kf.setImage(with: URL(string : imageUrl ?? ""), placeholder: UIImage(named: "noimmage"), options: [.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: { result in
            })
        }else{
            cell?.imgPhoto?.image = UIImage(named: "noimmage")
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CustomCollectionViewCell
        let popoverContent = storyboard?.instantiateViewController(withIdentifier: "ContainerViewControllerImage") as! ContainerViewController
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = cell
            popover.permittedArrowDirections = .any
            popover.sourceRect = cell?.bounds ?? CGRect()
            popoverContent.preferredContentSize = CGSize.init(width: self.view.frame.width-30, height: self.view.frame.width-30)
            popover.delegate = self
        }
        SELECTINDEX = indexPath.row
        self.present(popoverContent , animated: true, completion: nil)

            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 3) / 3, height: (collectionView.frame.width - 3) / 3)
    }
}

// MARK : Poponer Delegate
extension ViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
// MARK : API
extension ViewController{
    func fetch(){
        let urlString = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=42")
        print(urlString!)
        URLSession.shared.reuquest(url: urlString, expeating: [image].self) { (result) in
            switch result {
            case .success(let medicalData):
                
                self.model = medicalData
                imageArr = medicalData
                DispatchQueue.main.async {
                    self.actloder?.stopAnimating()
                    self.actloder?.isHidden = true
                    self.collectionView?.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
