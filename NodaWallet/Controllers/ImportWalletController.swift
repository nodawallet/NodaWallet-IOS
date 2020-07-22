//
//  ImportWalletController.swift
//  NodaWallet

import UIKit
import web3swift
import RealmSwift
import BigInt
import BitcoinKit
import HDWalletKit
import TrustWalletCore

class ImportWalletController: UIViewController {
 
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phraseTV: UITextView!
    @IBOutlet weak var pasteLabel: UILabel!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var phraseTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.contentView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.pasteLabel.theme_textColor = ["#000", "#FFF"]
        self.phraseTV.theme_backgroundColor = ["#FFF", "#000"]
        self.phraseTV.theme_textColor = ["#000", "#FFF"]
        self.phraseTitleLabel.theme_textColor = ["#000", "#FFF"]
        
        self.phraseTitleLabel.text = "Phrase".localized()
        self.pasteLabel.text = "Paste".localized()
        self.importButton.setTitle("Import".localized(), for: .normal)
        
        //placeholder
        phraseTV.delegate = self
        phraseTV.text = "enter_phrase".localized()
        phraseTV.theme_textColor = ["#000", "#FFF"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func pasteAction(_ sender: UIButton) {
        if let myString = UIPasteboard.general.string {
            phraseTV.text = nil
            phraseTV.insertText(myString)
        }
    }
    
    @IBAction func importAction(_ sender: UIButton) {
        if phraseTV.text!.isEmpty {
            self.popUpView(message: "Your phrase is missing")
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
            let mnemonicData = addMnemonicPhraseToDB(mnemonic: phraseTV.text ?? "", mnemonicID: mnemonicID, ethPublicKey: publicKey?.toHexString() ?? "", walletID: walletID, walletName: "Main-Wallet-\(walletID)", importedBy: "Mnemonic", address: address.address, privateKey: privatekey.toHexString())
            
            var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
            currencyID = currencyID + 1
            let addETHCurrencyList = updateCurrencyData(currencyName: "Ethereum", currencyID: currencyID, currencyImage: "Etherium", enable: true, address: address.address, symbol: "ETH", balance: "0", decimal: 18, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: privatekey.toHexString(), importedBy: "Mnemonic", isToken: "currency", geckoID: "ethereum", coinPublicKey: publicKey?.toHexString() ?? "", type: "ERC20")
            
            //For BTC
            let phraseStr = phraseTV.text!.components(separatedBy: " ")
            let seed = try? Mnemonic.seed(mnemonic: phraseStr)
            let wallet = HDWallet(seed: seed!, externalIndex: .zero, internalIndex: .zero, network: btcNetwork)
            currencyID = currencyID + 1
            let addBTCCurrencyList = updateCurrencyData(currencyName: "Bitcoin", currencyID: currencyID, currencyImage: "Bitcoin", enable: true, address: wallet.address.description, symbol: "BTC", balance: "0", decimal: 8, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: wallet.privKeys[0].description, importedBy: "Mnemonic", isToken: "currency", geckoID: "bitcoin", coinPublicKey: wallet.pubKeys[0].description, type: "ERC20")
            
            //For LTC
            let litecoinSeed = Mnemonic.createSeed(mnemonic: phraseTV.text ?? "")
            let purpose1 = PrivateKey.init(seed: litecoinSeed, coin: .litecoin)
                       
            let purpose = purpose1.derived(at: .hardened(44))
            let coinType = purpose.derived(at: .hardened(2))
            let account = coinType.derived(at: .hardened(0))
            let change = account.derived(at: .notHardened(0))
            let litecoinPrivateKey = change.derived(at: .notHardened(0))
                       
            currencyID = currencyID + 1
            let addLTCCurrencyList = updateCurrencyData(currencyName: "Litecoin", currencyID: currencyID, currencyImage: "Litecoin", enable: true, address: litecoinPrivateKey.publicKey.address, symbol: "LTC", balance: "0", decimal: 8, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: litecoinPrivateKey.get(), importedBy: "Mnemonic", isToken: "currency", geckoID: "litecoin", coinPublicKey: litecoinPrivateKey.publicKey.get(), type: "ERC20")
            
            //For BNB
            let binanceWallet = HDWallet(mnemonic: phraseTV.text!, passphrase: "")
            currencyID = currencyID + 1
            let bnbPrivateKey = binanceWallet.getKeyForCoin(coin: .binance)
            let addBNBCurrencyList = updateCurrencyData(currencyName: "Binance", currencyID: currencyID, currencyImage: "Binance", enable: true, address: binanceWallet.getAddressForCoin(coin: .binance), symbol: "BNB", balance: "0", decimal: 8, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: bnbPrivateKey.data.hexString, importedBy: "Mnemonic", isToken: "currency", geckoID: "binancecoin", coinPublicKey: bnbPrivateKey.getPublicKeySecp256k1(compressed: true).data.hexString, type: "ERC20")
            
            //Custom Token USDT
            currencyID = currencyID + 1
            let addUSDTCurrencyList = updateCurrencyData(currencyName: "Tether USD", currencyID: currencyID, currencyImage: "USDT", enable: true, address: "", symbol: "USDT", balance: "0", decimal: 6, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "customtoken", geckoID: "tether", coinPublicKey: "", type: "ERC20")
                   
            //Custom Token USDC
            currencyID = currencyID + 1
            let addUSDCCurrencyList = updateCurrencyData(currencyName: "USD Coin", currencyID: currencyID, currencyImage: "USDC", enable: true, address: "", symbol: "USDC", balance: "0", decimal: 6, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "customtoken", geckoID: "usd-coin", coinPublicKey: "", type: "ERC20")
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(mnemonicData)
                realm.add(addETHCurrencyList)
                realm.add(addBTCCurrencyList)
                realm.add(addLTCCurrencyList)
                realm.add(addBNBCurrencyList)
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

extension ImportWalletController: UITextViewDelegate {
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
