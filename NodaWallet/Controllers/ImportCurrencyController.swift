//
//  ImportCurrencyController.swift
//  NodaWallet
//
//  Created by macOsx on 24/03/20.
//  .
//

import UIKit
import XLPagerTabStrip

class ImportCurrencyController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var buttonView: ButtonBarView!
    @IBOutlet weak var navTitle: UILabel!
    
    override func viewDidLoad() {
        self.navTitle.text = "Import".localized()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.buttonView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#F2F2F2", "#000"]
        
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
            oldCell?.contentView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
            newCell?.contentView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        }
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "PhraseController") as! PhraseController
       // let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "KeyStoreJsonController") as! KeyStoreJsonController
        let child_3 = self.storyboard?.instantiateViewController(withIdentifier: "PrivateKeyController") as! PrivateKeyController
        let child_4 = self.storyboard?.instantiateViewController(withIdentifier: "AddressController") as! AddressController
        return [child_1, child_3, child_4]
    }

}
