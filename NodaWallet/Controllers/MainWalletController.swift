//
//  MainWalletController.swift
//  NodaWallet

import UIKit

class MainWalletController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var mainWalletTitleLabel: UILabel!
    @IBOutlet weak var multicoinTitleLable: UILabel!
    @IBOutlet weak var mainWalletView: UIView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var mainWalletNameLabel: UILabel!
    @IBOutlet weak var mainWalletContentView: UIView!
    @IBOutlet weak var mainWalletTitleContentLabel: UILabel!
    @IBOutlet weak var showSecurityPharseView: UIView!
    @IBOutlet weak var mainWalletNameTF: UITextField!
    
    @IBOutlet weak var showSecurityPharseContentView: UIView!
    
    @IBOutlet weak var secretPhraseTitleLabel: UILabel!
    @IBOutlet weak var secretPhraseContentLabel: UILabel!
    @IBOutlet weak var openKeyAccountLabel: UILabel!
    @IBOutlet weak var exportPublicKeyView: UIView!
    
    @IBOutlet weak var exportPublicContentView: UIView!
    @IBOutlet weak var exportPublicKeyLabel: UILabel!
    @IBOutlet weak var exportPublicKeyContentLabel: UILabel!
    
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    var index = 0
    var isDeleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "advanced_settings".localized()
        self.mainWalletNameTF.delegate = self
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.walletImageView.theme_image = ["Round_Wallet_Light", "Round_Wallet_Dark"]
        
        self.mainWalletTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.multicoinTitleLable.theme_textColor = ["#000", "#FFF"]
        self.nameTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.mainWalletNameLabel.theme_textColor = ["#000", "#FFF"]
        self.mainWalletTitleContentLabel.theme_textColor = ["#000", "#FFF"]
        self.secretPhraseTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.secretPhraseContentLabel.theme_textColor = ["#000", "#FFF"]
        self.openKeyAccountLabel.theme_textColor = ["#000", "#FFF"]
        self.exportPublicKeyLabel.theme_textColor = ["#000", "#FFF"]
        self.exportPublicKeyContentLabel.theme_textColor = ["#000", "#FFF"]
        self.mainWalletNameTF.theme_textColor = ["#000", "#FFF"]
        
        self.mainWalletView.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.showSecurityPharseView.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.exportPublicKeyView.theme_backgroundColor = ["#DED8CF", "#393939"]
        
        self.multicoinTitleLable.text = "multi_coin_wallet".localized()
        self.nameTitleLabel.text = "Name".localized()
        self.mainWalletTitleContentLabel.text = "BACKUP_OPTIONS".localized()
        self.secretPhraseTitleLabel.text = "Show_secret_phrase".localized()
        self.secretPhraseContentLabel.text = "lose_access_in_device".localized()
        self.openKeyAccountLabel.text = "OPEN_KEY_ACCOUNT".localized()
        self.exportPublicKeyLabel.text = "Export_Public_Keys".localized()
        self.exportPublicKeyContentLabel.text = "public_keys_account_information".localized()
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isDeleted {
            let content = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[index]
            let obj = MnemonicPhraseDatas()
            LocalDBManager.sharedInstance.updateWalletName(object: obj, mnemonic: content.mnemonicPhraseDatas, mnemonicID: content.mnemonicID, ethPublicKey: content.ethPublicKey, walletID: content.walletID, walletName: self.mainWalletNameTF.text ?? "")
        }
    }
    
    private func loadData() {
        let content = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[index]
        self.mainWalletNameTF.text = content.walletName
        self.mainWalletTitleLabel.text = content.walletName
        let totalWalletCount = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB().count
        if totalWalletCount <= 1 {
            deleteImage.isHidden = true
            deleteButton.isHidden = true
        }
        
        //Hide delete option for selected wallet
        let selectedWalletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.selectedWalletID) - 1
        let selectedWalletContent = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[selectedWalletID]
        if content.walletID == selectedWalletContent.walletID {
            deleteImage.isHidden = true
            deleteButton.isHidden = true
        }
        
        if content.importedBy == "PrivateKey" {
            secretPhraseTitleLabel.text = "Show_Private_Key".localized()
        }
    }
    
    @IBAction func showSecretKeyAct(_ sender: Any) {
        let content = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[index]
        
        if content.importedBy == "PrivateKey" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExportPrivateKeyControllerID") as? ExportPrivateKeyController {
                vc.privateKey = content.privateKey
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecurityKeyControllerID") as? SecurityKeyController {
            vc.isFromSettings = true
            let array = content.mnemonicPhraseDatas.components(separatedBy: " ")
            var strArr = [String]()
            for i in array {
                strArr.append(i)
            }
            vc.arr = strArr
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func exportPublicKeyAct(_ sender: Any) {
        self.pushViewController(identifier: "ExportAccPublicKeyControllerID", storyBoardName: "Main")
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let okAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
            let object = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[self.index]
            LocalDBManager.sharedInstance.deleteMainWalletFromDB(object: object)
            UserDefaults.standard.set(1, forKey: Constants.UserDefaultKey.selectedWalletID)
            self.isDeleted = true
            DispatchQueue.main.async {
                APPDELEGATE.homepage()
            }
        }
        self.showAlertWithCancelAndOk(title: "Are you sure you want to delete this wallet.", okAction: okAction)
    }


}

extension MainWalletController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            return
        }
        if textField == mainWalletNameTF {
            self.mainWalletTitleLabel.text = textField.text
        }
    }
}
