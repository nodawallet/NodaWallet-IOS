//
//  BuyCryptoController.swift
//  NodaWallet
//
//  n 06/03/20.
//  .
//

import UIKit
import FittedSheets
import web3swift
import BigInt

class BuyCryptoController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var buyCrptoView: UIView!
    @IBOutlet weak var youSendView: UIView!
    @IBOutlet weak var youGetView: UIView!
    
    @IBOutlet weak var cryptoPurchaseLabel: UILabel!
    @IBOutlet weak var noteContent: UILabel!
    
    @IBOutlet weak var youSendTF: UITextField!
    @IBOutlet weak var youGetTF: UITextField!
    
    @IBOutlet weak var sendCurrencyLabel: UILabel!
    @IBOutlet weak var getCurrencyLabel: UILabel!
    
    @IBOutlet weak var furtherButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var downArrowImg1: UIImageView!
    @IBOutlet weak var downArrowImg2: UIImageView!
    
    @IBOutlet weak var youSendLabel: UILabel!
    @IBOutlet weak var youGetLabel: UILabel!
    
    @IBOutlet weak var currencySendImage: UIImageView!
    @IBOutlet weak var currencyGetImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAppColor()
    }
    
    private func updateAppColor() {
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.buyCrptoView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        
       // self.youSendView.theme_backgroundColor = ["#DFDEDC", "#3E3D3A"]
       // self.youGetView.theme_backgroundColor = ["#DFDEDC", "#3E3D3A"]
        
         self.youSendView.theme_backgroundColor = ["#F0F0F0", "#3E3D3A"]
         self.youGetView.theme_backgroundColor = ["#F0F0F0", "#3E3D3A"]
        
        self.cryptoPurchaseLabel.theme_textColor = ["#000", "#FFF"]
        self.noteContent.theme_textColor = ["#000", "#FFF"]
        
        self.sendCurrencyLabel.theme_textColor = ["#000", "#FFF"]
        self.getCurrencyLabel.theme_textColor = ["#000", "#FFF"]
        
        self.youSendTF.theme_textColor = ["#000", "#FFF"]
        self.youGetTF.theme_textColor = ["#000", "#FFF"]
        
        self.furtherButton.titleLabel?.theme_textColor = ["#000", "#FFF"]
        
        backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        downArrowImg1.theme_image = ["Down_Arrow_Light", "Down_Arrow_Dark"]
        downArrowImg2.theme_image = ["Down_Arrow_Light", "Down_Arrow_Dark"]
        
        self.youGetLabel.theme_textColor = ["#000", "#FFF"]
        self.youSendLabel.theme_textColor = ["#000", "#FFF"]
        
        if Constants.User.isDarkMode {
            self.buyCrptoView.layer.shadowColor = UIColor.darkGray.cgColor
        } else {
            self.buyCrptoView.layer.shadowColor = UIColor.lightGray.cgColor
        }
        
        self.navTitle.text = "Buy_Crypto".localized()
        self.cryptoPurchaseLabel.text = "Crypto_purchase".localized()
        self.youSendLabel.text = "you_send".localized()
        self.youGetLabel.text = "you_get".localized()
        self.noteContent.text = "minimun_fees".localized()
        self.furtherButton.setTitle("Further".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func youSendCurrencyAction(_ sender: Any) {
        self.showCurrencyList(isSend: true)
    }
   
    @IBAction func youGetCurrencyAction(_ sender: Any) {
        self.showCurrencyList(isSend: false)
    }
    
    private func showCurrencyList(isSend: Bool) {
        self.youGetTF.resignFirstResponder()
        self.youSendTF.resignFirstResponder()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CurrencyListControllerID") as! CurrencyListController
        let sheetController = SheetViewController(controller: controller)
        controller.delegate = self
        controller.isSend = isSend
        controller.sendCurrencyName = sendCurrencyLabel.text ?? ""
        controller.getCurrencyName = getCurrencyLabel.text ?? ""
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func furtherAction(_ sender: Any) {
        //self.getContractABI(address: self.contractString, isExchange: true)
    }

    
}

extension BuyCryptoController: CurrencyListControllerDelegate {
    func currencySelected(isSend: Bool, index: Int, currencySymbol: String, currencyImage: String) {
        if isSend {
            self.sendCurrencyLabel.text = currencySymbol
            self.currencySendImage.loadImage(string: currencyImage)
        } else {
            self.getCurrencyLabel.text = currencySymbol
            self.currencyGetImage.loadImage(string: currencyImage)
        }
    }
    
}
