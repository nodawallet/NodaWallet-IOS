//
//  PrivateKeyController.swift
//  NodaWallet
//
//  Created by macOsx on 24/03/20.
//  .
//

import UIKit
import XLPagerTabStrip
import web3swift
import RealmSwift
import BigInt

class PrivateKeyController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phraseTF: UITextView!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var privateKeyTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tfView: UIView!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.pasteButton.theme_setTitleColor( ["#000", "#FFF"], forState: .normal)
        self.phraseTF.theme_backgroundColor = ["#FFF", "#000"]
        self.phraseTF.theme_textColor = ["#000", "#FFF"]
        self.privateKeyTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.contentLabel.theme_textColor = ["#000", "#FFF"]
        self.tfView.theme_backgroundColor = ["#FFF", "#000"]
        
        self.importButton.setTitle("Import".localized(), for: .normal)
        self.contentLabel.text = "private_key_content".localized()
        
        //placeholder
        phraseTF.delegate = self
        phraseTF.text = "enter_privatekey".localized()
        phraseTF.theme_textColor = ["#000", "#FFF"]
        
        self.privateKeyTitleLabel.text = "private_key".localized()
        self.pasteButton.setTitle("Paste".localized(), for: .normal)
    }
    
    @IBAction func pasteAction(_ sender: UIButton) {
        if let myString = UIPasteboard.general.string {
            phraseTF.text = nil
            phraseTF.insertText(myString)
        }
    }
    
    @IBAction func importAction(_ sender: UIButton) {
        if phraseTF.text!.isEmpty {
            self.popUpView(message: "Enter your private key")
            return
        }
        if phraseTF.text == "Enter your private key" {
            self.popUpView(message: "Enter your private key")
            return
        }
        
        self.importUsingPrivateKey()
    }
    
    private func importUsingPrivateKey() {
        var mnemonicID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.mnemonicID)
        var walletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.walletID)
        mnemonicID += 1
        walletID += 1
        let password = ""
        let key = phraseTF.text ?? ""
        let formattedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
        
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let name = "Main-Wallet-\(walletID)"
            //let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
            
        let privatekey = try! keystore.UNSAFE_getPrivateKeyData(password: "", account: (keystore.addresses!.first!))
        let publicKey = SECP256K1.privateToPublic(privateKey: privatekey)
       
        let mnemonicData = addMnemonicPhraseToDB(mnemonic: "", mnemonicID: mnemonicID, ethPublicKey: publicKey?.toHexString() ?? "", walletID: walletID, walletName: name, importedBy: "ETHPrivateKey", address: address, privateKey: privatekey.toHexString())
        
        var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
        currencyID = currencyID + 1
        let addCurrencyList = updateCurrencyData(currencyName: "Ethereum", currencyID: currencyID, currencyImage: "Etherium", enable: true, address: address, symbol: "ETH", balance: "0", decimal: 0, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: privatekey.toHexString(), importedBy: "PrivateKey", isToken: "currency", geckoID: "ethereum", coinPublicKey: publicKey?.toHexString() ?? "", type: "ERC20")
                   
        currencyID = currencyID + 1
        let addUSDTCurrencyList = updateCurrencyData(currencyName: "Tether USD", currencyID: currencyID, currencyImage: "USDT", enable: true, address: "", symbol: "USDT", balance: "0", decimal: 6, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "customtoken", geckoID: "tether", coinPublicKey: "", type: "ERC20")
        
        currencyID = currencyID + 1
        let addUSDCCurrencyList = updateCurrencyData(currencyName: "USD Coin", currencyID: currencyID, currencyImage: "USDC", enable: true, address: "", symbol: "USDC", balance: "0", decimal: 6, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "customtoken", geckoID: "usd-coin", coinPublicKey: "", type: "ERC20")
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(mnemonicData)
            realm.add(addCurrencyList)
            realm.add(addUSDTCurrencyList)
            realm.add(addUSDCCurrencyList)
        }
        
        let selectedWalletID = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB().count
        UserDefaults.standard.set(selectedWalletID, forKey: Constants.UserDefaultKey.selectedWalletID)
        UserDefaults.standard.set(mnemonicID, forKey: Constants.UserDefaultKey.mnemonicID)
        UserDefaults.standard.set(walletID, forKey: Constants.UserDefaultKey.walletID)
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultKey.isFirstTime)
        //Default currency
        UserDefaults.standard.set("usd", forKey: Constants.UserDefaultKey.userSelectedCurrencyID)
        UserDefaults.standard.set("$", forKey: Constants.UserDefaultKey.userSelectedCurrencySymbolID)
        //For updating address to backend
        UserDefaults.standard.set(true, forKey: Constants.UserDefaultKey.updateAddressToBackEnd)
        APPDELEGATE.homepage()
    }

}

extension PrivateKeyController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "private_key".localized())
    }
}

extension PrivateKeyController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            phraseTF.text = "enter_privatekey".localized()
            phraseTF.theme_textColor = ["#000", "#FFF"]
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if phraseTF.text == "enter_privatekey".localized() {
            self.phraseTF.text = nil
        }
    }
}
