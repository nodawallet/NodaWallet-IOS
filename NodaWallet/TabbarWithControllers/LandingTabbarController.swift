//
//  LandingTabbarController.swift
//  NodaWallet

import UIKit

class LandingTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.tintColor = Constants.AppColors.App_Orange_Color
        self.tabBar.theme_barTintColor = ["#FFF", Constants.NavigationColor.darkMode]
        if Constants.User.isDarkMode {
            self.tabBar.unselectedItemTintColor = .white
        } else {
            self.tabBar.unselectedItemTintColor = .lightGray
        }
        self.tabBar.items?[0].title = "Wallet".localized()
       // self.tabBar.items?[1].title = "Buy_Crypto".localized()
        self.tabBar.items?[1].title = "Scanner".localized()
        self.tabBar.items?[2].title = "exchange".localized()
        self.tabBar.items?[3].title = "Settings".localized()
    }
    

}
