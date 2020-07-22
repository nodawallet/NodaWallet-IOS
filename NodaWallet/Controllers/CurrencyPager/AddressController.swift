//
//  AddressController.swift
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

class AddressController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressTF: UITextView!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tfView: UIView!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.pasteButton.theme_setTitleColor( ["#000", "#FFF"], forState: .normal)
        self.addressTF.theme_backgroundColor = ["#FFF", "#000"]
        self.addressTF.theme_textColor = ["#000", "#FFF"]
        self.addressTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.contentLabel.theme_textColor = ["#000", "#FFF"]
        self.tfView.theme_backgroundColor = ["#FFF", "#000"]
        
        self.importButton.setTitle("Import".localized(), for: .normal)
        self.contentLabel.text = "address_content".localized()
        
        //placeholder
        addressTF.delegate = self
        addressTF.text = "enter_address".localized()
        addressTF.theme_textColor = ["#000", "#FFF"]
        
        self.addressTitleLabel.text = "Address".localized()
        self.pasteButton.setTitle("Paste".localized(), for: .normal)
    }
    
    @IBAction func pasteAction(_ sender: UIButton) {
        if let myString = UIPasteboard.general.string {
            addressTF.text = nil
            addressTF.insertText(myString)
        }
    }
    
    @IBAction func importAction(_ sender: UIButton) {
        if addressTF.text!.isEmpty {
            self.popUpView(message: "Enter your address")
            return
        }
        if addressTF.text == "Enter your address" {
            self.popUpView(message: "Enter your address")
            return
        }
        let address = EthereumAddress(addressTF.text!)
        if address == nil {
            self.popUpView(message: "Enter your valid address")
            return
        }
        self.importUsingAddress()
    }
    
    private func importUsingAddress() {
        var mnemonicID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.mnemonicID)
        var walletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.walletID)
        mnemonicID += 1
        walletID += 1
        let name = "Main-Wallet-\(walletID)"
        
        let address = addressTF.text!

        let mnemonicData = addMnemonicPhraseToDB(mnemonic: "", mnemonicID: mnemonicID, ethPublicKey: "", walletID: walletID, walletName: name, importedBy: "ETHAddress", address: address, privateKey: "")
        
        var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
        currencyID = currencyID + 1
        let addCurrencyList = updateCurrencyData(currencyName: "Ethereum", currencyID: currencyID, currencyImage: "Etherium", enable: true, address: address, symbol: "ETH", balance: "0", decimal: 0, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "currency", geckoID: "ethereum", coinPublicKey: "", type: "ERC20")
        
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

extension AddressController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Address".localized())
    }
}

extension AddressController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addressTF.text = "enter_address".localized()
            addressTF.theme_textColor = ["#000", "#FFF"]
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addressTF.text == "enter_address".localized() {
            self.addressTF.text = nil
        }
    }
}
