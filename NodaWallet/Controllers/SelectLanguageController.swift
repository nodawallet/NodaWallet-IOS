//
//  SelectLanguageController.swift
//  NodaWallet

import UIKit
import BigInt
import web3swift

class SelectLanguageController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var englishImageView: UIImageView!
    @IBOutlet weak var frenchImageView: UIImageView!
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var frenchView: UIView!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var frenchButton: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    
    var currencyList = [CurrencyListDatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "select_language".localized()
        self.updateAppColors()
        if let language = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.AppLanguage) as? String {
            if language == "English" {
                self.englishImageView.image = UIImage(named: "Tick_Light")
                self.frenchImageView.image = nil
                self.frenchImageView.layer.borderColor = Constants.AppColors.App_Orange_Color?.cgColor
                self.frenchImageView.layer.borderWidth = 1.0
                self.frenchImageView.layer.cornerRadius = frenchImageView.frame.height / 2
            } else if language == "Russian" {
                self.frenchImageView.image = UIImage(named: "Tick_Light")
                self.englishImageView.image = nil
                self.englishImageView.layer.borderColor = Constants.AppColors.App_Orange_Color?.cgColor
                self.englishImageView.layer.borderWidth = 1.0
                self.englishImageView.layer.cornerRadius = frenchImageView.frame.height / 2
            }
        }
    }
    
    private func updateAppColors() {
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.englishView.layer.theme_borderColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.frenchView.layer.theme_borderColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.englishView.theme_backgroundColor = ["#FFF", "#000"]
        self.frenchView.theme_backgroundColor = ["#FFF", "#000"]
        self.englishButton.theme_setTitleColor([Constants.NavigationColor.lightMode, "#FFF"], forState: .normal)
        self.frenchButton.theme_setTitleColor([Constants.NavigationColor.lightMode, "#FFF"], forState: .normal)
    }
        
    @IBAction func englishTapped(_ sender: Any) {
        self.englishImageView.image = UIImage(named: "Tick_Light")
        self.englishImageView.layer.borderWidth = 0
        self.frenchImageView.image = nil
        self.frenchImageView.layer.borderColor = Constants.AppColors.App_Orange_Color?.cgColor
        self.frenchImageView.layer.borderWidth = 1.0
        self.frenchImageView.layer.cornerRadius = frenchImageView.frame.height / 2
        showSelectedLangAlert(language: "English")
    }
    
    @IBAction func frenchTapped(_ sender: Any) {
        self.frenchImageView.image = UIImage(named: "Tick_Light")
        self.frenchImageView.layer.borderWidth = 0
        self.englishImageView.image = nil
        self.englishImageView.layer.borderColor = Constants.AppColors.App_Orange_Color?.cgColor
        self.englishImageView.layer.borderWidth = 1.0
        self.englishImageView.layer.cornerRadius = frenchImageView.frame.height / 2
        showSelectedLangAlert(language: "Russian")
    }
    
    private func showSelectedLangAlert(language: String) {
        let addAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            UserDefaults.standard.set(language, forKey: Constants.UserDefaultKey.AppLanguage)
            APPDELEGATE.homepage()
        }
        self.showAlertOkAction(message: "Your selected language is \(language)", okAction: addAction)
    }
    
}
