//
//  WalletController.swift
//  NodaWallet

import UIKit
import XLPagerTabStrip

class WalletController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var buttonView: ButtonBarView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var buttonBarWidth: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#F2F2F2", "#000"]
        
        let device = "UIDevice.modelName"
        if device.contains("iPhone 6") {
           settings.style.buttonBarRightContentInset = -8
        }
        
        if Constants.User.isDarkMode {
            buttonView.backgroundColor = UIColor(red: 62/255, green: 61/255, blue: 58/255, alpha: 1.0)
            buttonView.layer.borderColor = UIColor(red: 62/250, green: 61/250, blue: 58/250, alpha: 1.0).cgColor
        }
       // settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
        // settings.style.buttonBarItemBackgroundColor = .lightGray
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            if Constants.User.isDarkMode {
                oldCell?.label.textColor = .white
                oldCell?.contentView.backgroundColor = UIColor(red: 62/255, green: 61/255, blue: 58/255, alpha: 1.0)
                newCell?.label.textColor = .white
              //  newCell?.contentView.backgroundColor = UIColor.black
                newCell?.contentView.backgroundColor = Constants.AppColors.App_Orange_Color
            } else {
                oldCell?.label.textColor = .darkGray
                oldCell?.contentView.backgroundColor = UIColor(red: 218/250, green: 218/250, blue: 218/250, alpha: 1.0)
                newCell?.label.textColor = .white
              //  newCell?.contentView.backgroundColor = .white
                newCell?.contentView.backgroundColor = Constants.AppColors.App_Orange_Color
            }
            //newCell?.contentView.layer.cornerRadius = 4.0
        }
      //  self.buttonBarWidth.constant = buttonView.contentSize.width
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "TokenControllerID") as! TokenController
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "CollectionControllerID") as! CollectionController
        return [child_1, child_2]
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let index = ["Tokens".localized(), "Collections".localized()]
        let textTitle = index[indexPath.row]
        var cellWidth:CGFloat = 0.0
        let device = UIDevice.modelName
        if device.contains("iPad") {
            cellWidth = textTitle.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 30.0
        } else {
            cellWidth = textTitle.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        }
        return CGSize(width: cellWidth, height: 30)
    }*/
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        Constants.staticView.tokenSlideView.isHidden = true
        Constants.staticView.collectionSlideView.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        Constants.staticView.tokenSlideView.isHidden = false
        Constants.staticView.collectionSlideView.isHidden = false
    }
}
