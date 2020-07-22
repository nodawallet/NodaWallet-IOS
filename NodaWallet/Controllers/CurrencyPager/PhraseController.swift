//
//  PhraseController.swift
//  NodaWallet
//
//  Created by macOsx on 24/03/20.
//  .
//

import UIKit
import XLPagerTabStrip
import RealmSwift
import web3swift

class PhraseController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phraseTV: UITextView!
    @IBOutlet weak var pasteLabel: UILabel!
    @IBOutlet weak var phraseTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phraseTV.delegate = self
        self.contentView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.pasteLabel.theme_textColor = ["#000", "#FFF"]
        self.phraseTV.theme_backgroundColor = ["#FFF", "#000"]
        self.phraseTV.theme_textColor = ["#000", "#FFF"]
        self.phraseTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.contentLabel.theme_textColor = ["#000", "#FFF"]
        
        self.importButton.setTitle("Import".localized(), for: .normal)
        self.contentLabel.text = "phrase_content".localized()
        
        //placeholder
        phraseTV.text = "enter_phrase".localized()
        phraseTV.theme_textColor = ["#000", "#FFF"]
        
        self.phraseTitleLabel.text = "Phrase".localized()
        self.pasteLabel.text = "Paste".localized()
    }
    
    @IBAction func pasteAction(_ sender: UIButton) {
        if let myString = UIPasteboard.general.string {
            phraseTV.text = nil
            phraseTV.insertText(myString)
        }
    }
    
    @IBAction func importAction(_ sender: UIButton) {
        //phraseTV.text = "squirrel shoulder close deal sell snake blade rug champion palace fish now"
        if phraseTV.text!.isEmpty {
            self.popUpView(message: "Your phrase is missing")
            return
        }
        if phraseTV.text == "Enter your phrase" {
            self.popUpView(message: "Enter your phrase")
            return
        }
        let phraseArr = phraseTV.text!.components(separatedBy: " ")
        if phraseArr.count != 12 {
            self.popUpView(message: "Your phrase should contain 12 words")
            return
        }
        var mnemonicID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.mnemonicID)
        var walletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.walletID)
        mnemonicID += 1
        walletID += 1
        do {
            let keystore = try BIP32Keystore(mnemonics: phraseTV.text ?? "", password: "", mnemonicsPassword: "")
            let privatekey = try! keystore!.UNSAFE_getPrivateKeyData(password: "", account: (keystore!.addresses!.first!))
            let publicKey = SECP256K1.privateToPublic(privateKey: privatekey)
            let address = keystore!.addresses!.first!
            
            let mnemonicData = addMnemonicPhraseToDB(mnemonic: phraseTV.text ?? "", mnemonicID: mnemonicID, ethPublicKey: publicKey?.toHexString() ?? "", walletID: walletID, walletName: "Main-Wallet-\(walletID)", importedBy: "ETHMnemonic", address: address.address, privateKey: privatekey.toHexString())
            
            var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
            currencyID = currencyID + 1
            let addCurrencyList = updateCurrencyData(currencyName: "Ethereum", currencyID: currencyID, currencyImage: "Etherium", enable: true, address: address.address, symbol: "ETH", balance: "0", decimal: 0, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: privatekey.toHexString(), importedBy: "Mnemonic", isToken: "currency", geckoID: "ethereum", coinPublicKey: publicKey?.toHexString() ?? "", type: "ERC20")
            
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
        } catch {
            self.popUpView(message: "Please enter a valid phrase")
        }
        
    }
    
}

extension PhraseController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Phrase".localized())
    }
}

extension PhraseController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            phraseTV.text = "enter_phrase".localized()
            phraseTV.theme_textColor = ["#000", "#FFF"]
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if phraseTV.text == "enter_phrase".localized() {
            self.phraseTV.text = nil
        }
    }
}
