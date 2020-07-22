//
//  LaunchScreenController.swift
//  NodaWallet

import UIKit

class LaunchScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let isTouchID = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.touchID) as? Bool {
            if isTouchID {
                Constants.User.isTouchID = true
            } else {
                Constants.User.isTouchID = false
            }
        } else {
            Constants.User.isTouchID = false
        }
        
        if Constants.User.isTouchID {
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.fingerPrintScreen), userInfo: nil, repeats: false)
        } else {
            self.moveToNimonicScreen()
        }
       
    }
    
    private func moveToNimonicScreen() {
        if let isFirstTime = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.isFirstTime) as? Bool {
            if isFirstTime {
                Constants.User.isFirstTime = true
            } else {
                Constants.User.isFirstTime = false
            }
        } else {
            Constants.User.isFirstTime = true
        }
        
        if Constants.User.isFirstTime {
            UserDefaults.standard.set("English", forKey: Constants.UserDefaultKey.AppLanguage)
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.showSecurityScreen), userInfo: nil, repeats: false)
        } else {
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.showHomeScreen), userInfo: nil, repeats: false)
        }
    }
    
    @objc func showHomeScreen() {
        APPDELEGATE.homepage()
    }
    
    @objc func showSecurityScreen() {
        self.pushViewController(identifier: "PrivateAndSecureControllerID", storyBoardName: "Main")
    }
    
    @objc func fingerPrintScreen() {
        self.pushViewController(identifier: "FingerPrintControllerID", storyBoardName: "Main")
    }
    
}
