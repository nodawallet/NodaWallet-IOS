//
//  DexController.swift
//  NodaWallet
//
//  n 07/03/20.
//  .
//

import UIKit
import XLPagerTabStrip
import FittedSheets

class DexController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var buttonView: ButtonBarView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        self.navigationLabel.text = "exchange".localized()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#F2F2F2", "#000"]
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        buttonView.layer.cornerRadius = 3.0
        buttonView.layer.borderColor = UIColor(red: 218/250, green: 218/250, blue: 218/250, alpha: 1.0).cgColor
        buttonView.layer.borderWidth = 2.0
        if Constants.User.isDarkMode {
            buttonView.backgroundColor = UIColor(red: 62/255, green: 61/255, blue: 58/255, alpha: 1.0)
            buttonView.layer.borderColor = UIColor(red: 62/250, green: 61/250, blue: 58/250, alpha: 1.0).cgColor
        }
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
       // settings.style.buttonBarItemBackgroundColor = .lightGray
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 13)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            if Constants.User.isDarkMode {
                oldCell?.label.textColor = .white
                oldCell?.contentView.backgroundColor = UIColor(red: 62/255, green: 61/255, blue: 58/255, alpha: 1.0)
                newCell?.label.textColor = .white
                newCell?.contentView.backgroundColor = UIColor.black
            } else {
                oldCell?.label.textColor = .darkGray
                oldCell?.contentView.backgroundColor = UIColor(red: 218/250, green: 218/250, blue: 218/250, alpha: 1.0)
                newCell?.label.textColor = Constants.AppColors.App_Orange_Color
                newCell?.contentView.backgroundColor = .white
            }
          
            //newCell?.contentView.layer.cornerRadius = 4.0
        }
        super.viewDidLoad()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "ExchangeControllerID") as! ExchangeController
        //let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "StockExchangeControllerID") as! StockExchangeController
        return [child_1]
    }

}
