//
//  SettingsController.swift
//  NodaWallet
//
//  n 06/03/20.
//  .
//

import UIKit
import SwiftTheme

class SettingsController: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet weak var mainWalletLabel: UILabel!
    @IBOutlet weak var multiCoinWalletLabel: UILabel!
    @IBOutlet weak var advancedSettingLabel: UILabel!
    @IBOutlet weak var touchIDLabel: UILabel!
    @IBOutlet weak var pushNotificationLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var browserTitleLabel: UILabel!
    @IBOutlet weak var transactionsTitleLabel: UILabel!
    @IBOutlet weak var twitterTitleLabel: UILabel!
    @IBOutlet weak var telegramTitleLabel: UILabel!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var selectedLangLabel: UILabel!
    @IBOutlet weak var faqTitleLabel: UILabel!
    @IBOutlet weak var walletonnectLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var rightArrowImg1: UIImageView!
    @IBOutlet weak var rightArrowImg2: UIImageView!
    @IBOutlet weak var rightArrowImg4: UIImageView!
    @IBOutlet weak var rightArrowImg5: UIImageView!
    @IBOutlet weak var rightArrowImg6: UIImageView!
    @IBOutlet weak var rightArrowImg7: UIImageView!
    @IBOutlet weak var rightArrowImg8: UIImageView!
    @IBOutlet weak var rightArrowImg9: UIImageView!
    @IBOutlet weak var rightArrowImg10: UIImageView!
    @IBOutlet weak var rightArrowImg11: UIImageView!
    @IBOutlet weak var rightArrowImg12: UIImageView!
    
    @IBOutlet weak var languageImage: UIImageView!

    @IBOutlet weak var roundWalletImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAppColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if Constants.User.isDarkMode {
            self.darkModeSwitch.isOn = true
        }
        if Constants.User.isTouchID {
            self.touchIDSwitch.isOn = true
        }
    }
    
    private func updateAppColor() {
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.firstView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.secondView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.thirdView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.fourthView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        
        mainWalletLabel.theme_textColor = ["#000", "#FFF"]
        multiCoinWalletLabel.theme_textColor = ["#000", "#FFF"]
        advancedSettingLabel.theme_textColor = ["#000", "#FFF"]
        touchIDLabel.theme_textColor = ["#000", "#FFF"]
        pushNotificationLabel.theme_textColor = ["#000", "#FFF"]
        darkModeLabel.theme_textColor = ["#000", "#FFF"]
        currencyTitleLabel.theme_textColor = ["#000", "#FFF"]
        browserTitleLabel.theme_textColor = ["#000", "#FFF"]
        transactionsTitleLabel.theme_textColor = ["#000", "#FFF"]
        twitterTitleLabel.theme_textColor = ["#000", "#FFF"]
        telegramTitleLabel.theme_textColor = ["#000", "#FFF"]
        aboutTitleLabel.theme_textColor = ["#000", "#FFF"]
        selectedLangLabel.theme_textColor = ["#000", "#FFF"]
        faqTitleLabel.theme_textColor = ["#000", "#FFF"]
        walletonnectLabel.theme_textColor = ["#000", "#FFF"]
        
        backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        rightArrowImg1.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg2.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg4.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg5.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg6.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg7.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg8.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg9.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg10.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg11.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg12.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        roundWalletImage.theme_image = ["Round_Wallet_Light", "Round_Wallet_Dark"]
        
        if Constants.User.isDarkMode {
            languageImage.image = languageImage.image?.withRenderingMode(.alwaysTemplate)
            languageImage.tintColor = UIColor.white
        }
        
        touchIDSwitch.theme_onTintColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.lightMode]
        darkModeSwitch.theme_onTintColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.lightMode]
        pushNotificationSwitch.theme_onTintColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.lightMode]
        
        self.mainWalletLabel.text = "main_wallet".localized()
        self.multiCoinWalletLabel.text = "multi_coin_wallet".localized()
        self.pushNotificationLabel.text = "push_notification".localized()
        self.advancedSettingLabel.text = "advanced_settings".localized()
        self.touchIDLabel.text = "Touch_id".localized()
        self.darkModeLabel.text = "darkmode".localized()
        self.selectedLangLabel.text = "select_language".localized()
        self.currencyTitleLabel.text = "currency".localized()
        self.browserTitleLabel.text = "browser".localized()
        self.twitterTitleLabel.text = "twitter".localized()
        self.telegramTitleLabel.text = "telegram".localized()
        self.transactionsTitleLabel.text = "transaction".localized()
        self.faqTitleLabel.text = "faq".localized()
        self.walletonnectLabel.text = "wallet_connect".localized()
        self.aboutTitleLabel.text = "about".localized()
    }
    
    @IBAction func darModeSwitchAction(_ sender: Any) {
        if Constants.User.isDarkMode {
            self.darkModeSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultKey.isDarkModeSelected)
            Constants.User.isDarkMode = false
            ThemeManager.setTheme(index: 0)
        } else {
            self.darkModeSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultKey.isDarkModeSelected)
            Constants.User.isDarkMode = true
            ThemeManager.setTheme(index: 1)
        }
        DispatchQueue.main.async {
            APPDELEGATE.homepage()
        }
    }
    
    @IBAction func touchIdAction(_ sender: Any) {
        if Constants.User.isTouchID {
            self.touchIDSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultKey.touchID)
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultKey.passcodeLogin)
            Constants.User.isTouchID = false
        } else {
            self.touchIDSwitch.isOn = false
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeControllerID") as? PasscodeController {
                vc.isFromSettings = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        /*if let aString = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(aString, options: [:], completionHandler: { success in
            })
        }*/
    }
    
    @IBAction func mainWalletAction(_ sender: Any) {
        self.pushViewController(identifier: "AdvancedSettingControllerID", storyBoardName: "Main")
    }
    
    @IBAction func advancedSettingAction(_ sender: Any) {
        //self.pushViewController(identifier: "AdvancedSettingControllerID", storyBoardName: "Main")
    }
    
    @IBAction func selectedLanguageAction(_ sender: Any) {
        self.pushViewController(identifier: "SelectLanguageControllerID", storyBoardName: "Main")
    }
    
    @IBAction func transactionAct(_ sender: Any) {
        self.pushViewController(identifier: "TransactionControllerID", storyBoardName: "Main")
    }
    
    @IBAction func currenciesAct(_ sender: Any) {
        self.pushViewController(identifier: "CurrencyControllerID", storyBoardName: "Main")
    }
    
    @IBAction func faqAct(_ sender: Any) {
        self.pushViewController(identifier: "FaqControllerID", storyBoardName: "Main")
    }
    
    @IBAction func twitterAct(_ sender: Any) {
        getSocialLink(from: "twitter")
    }
       
    @IBAction func telegramAct(_ sender: Any) {
        getSocialLink(from: "telegram")
    }
    
    @IBAction func aboutAct(_ sender: Any) {
        self.pushViewController(identifier: "AboutViewControllerID", storyBoardName: "Main")
    }
    
    @IBAction func walletConnectAct(_ sender: Any) {
        if let tabbar = self.tabBarController as? LandingTabbarController {
            tabbar.selectedIndex = 1
        }
    }
    
    private func getSocialLink(from: String) {
        DataManager.getSocialRequest { (success, msg, data, error) in
            if success {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        return
                    }
                    if let responseArr = jsonArray["data"] as? [String: Any] {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonWebControllerID") as? CommonWebController {
                            vc.webUrl = responseArr[from] as? String ?? ""
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                } catch(let err) {
                    print("err occured", err)
                }
            }
        }
    }
    
}

extension SettingsController: UNUserNotificationCenterDelegate {
    
}
