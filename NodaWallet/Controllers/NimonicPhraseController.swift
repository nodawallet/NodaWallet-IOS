//
//  NimonicPhraseController.swift
//  NodaWallet

import UIKit
import web3swift
import RealmSwift
import BitcoinKit
import HDWalletKit
import TrustWalletCore

class NimonicPhraseController: UIViewController {

    @IBOutlet weak var userSelectedCollectionView: UICollectionView!
    @IBOutlet weak var userViewCollectionView: UICollectionView!
    @IBOutlet weak var invalidOrderLabel: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    @IBOutlet weak var verifyContentLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var userSelectedView: UIView!
    
    var providedForUserArr = [String]()
    var userSelectedArr = [String]()
    var userViewArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userViewArr.shuffle()
        
        self.verifyTitleLabel.text = "Verify_recovery_phrase".localized()
        self.verifyContentLabel.text = "tap_the_words".localized()
        self.verifyButton.setTitle("verify".localized(), for: .normal)
        
        self.invalidOrderLabel.isHidden = true
        self.userSelectedCollectionView.layoutIfNeeded()
        self.userViewCollectionView.layoutIfNeeded()
        self.updateAppColor()
    }
    
    private func updateAppColor() {
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.verifyContentLabel.theme_textColor = ["#434343", "#FFF"]
        self.userSelectedView.theme_backgroundColor = ["#DCDCDC", Constants.NavigationColor.darkMode]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func verifyAct(_ sender: UIButton) {
        if providedForUserArr.elementsEqual(userSelectedArr) {
            var mnemonicID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.mnemonicID)
            var walletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.walletID)
            mnemonicID += 1
            walletID += 1
            let arrString = "\(userSelectedArr[0]) " + "\(userSelectedArr[1]) " + "\(userSelectedArr[2]) " + "\(userSelectedArr[3]) " + "\(userSelectedArr[4]) " + "\(userSelectedArr[5]) " + "\(userSelectedArr[6]) " + "\(userSelectedArr[7]) " + "\(userSelectedArr[8]) " + "\(userSelectedArr[9]) " + "\(userSelectedArr[10]) " + "\(userSelectedArr[11])"
            let keystore = try! BIP32Keystore(mnemonics: arrString, password: "", mnemonicsPassword: "")
            let privatekey = try! keystore!.UNSAFE_getPrivateKeyData(password: "", account: (keystore!.addresses!.first!))
            let publicKey = SECP256K1.privateToPublic(privateKey: privatekey)
            let address = keystore!.addresses!.first!
            
            let mnemonicData = addMnemonicPhraseToDB(mnemonic: arrString, mnemonicID: mnemonicID, ethPublicKey: publicKey?.toHexString() ?? "", walletID: walletID, walletName: "Main-Wallet-\(walletID)", importedBy: "Mnemonic", address: address.address, privateKey: privatekey.toHexString())
            
            var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
            currencyID = currencyID + 1
            let addETHCurrencyList = updateCurrencyData(currencyName: "Ethereum", currencyID: currencyID, currencyImage: "Etherium", enable: true, address: address.address, symbol: "ETH", balance: "0", decimal: 18, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: privatekey.toHexString(), importedBy: "Mnemonic", isToken: "currency", geckoID: "ethereum", coinPublicKey: publicKey?.toHexString() ?? "", type: "ERC20")
            
            //For BTC
            let seed = try? Mnemonic.seed(mnemonic: userSelectedArr)
            let wallet = HDWallet(seed: seed!, externalIndex: .zero, internalIndex: .zero, network: btcNetwork)
            currencyID = currencyID + 1
            let addBTCCurrencyList = updateCurrencyData(currencyName: "Bitcoin", currencyID: currencyID, currencyImage: "Bitcoin", enable: true, address: wallet.address.description, symbol: "BTC", balance: "0", decimal: 8, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: wallet.privKeys[0].description, importedBy: "Mnemonic", isToken: "currency", geckoID: "bitcoin", coinPublicKey: wallet.pubKeys[0].description, type: "ERC20")
            
            //For LTC
            let litecoinSeed = Mnemonic.createSeed(mnemonic: arrString)
            let purpose1 = PrivateKey.init(seed: litecoinSeed, coin: .litecoin)
            
            let purpose = purpose1.derived(at: .hardened(44))
            let coinType = purpose.derived(at: .hardened(2))
            let account = coinType.derived(at: .hardened(0))
            let change = account.derived(at: .notHardened(0))
            let litecoinPrivateKey = change.derived(at: .notHardened(0))
            
            currencyID = currencyID + 1
            let addLTCCurrencyList = updateCurrencyData(currencyName: "Litecoin", currencyID: currencyID, currencyImage: "Litecoin", enable: true, address: litecoinPrivateKey.publicKey.address, symbol: "LTC", balance: "0", decimal: 8, walletID: walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: litecoinPrivateKey.get(), importedBy: "Mnemonic", isToken: "currency", geckoID: "litecoin", coinPublicKey: litecoinPrivateKey.publicKey.get(), type: "ERC20")
            
            //For BNB
            let binanceWallet = HDWallet(mnemonic: arrString, passphrase: "")
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
        } else {
            self.showAlert(message: "order_mismatching".localized())
        }
    }

}

extension NimonicPhraseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == userSelectedCollectionView {
            return userSelectedArr.count
        } else if collectionView == userViewCollectionView {
            return userViewArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == userSelectedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserSelectedCollectionCellID", for: indexPath) as! UserSelectedCollectionCell
            cell.securityKeyLabel.text = userSelectedArr[indexPath.row]
            cell.contentView.theme_backgroundColor = ["#EAB671", "#2D2D2D"]
            cell.securityKeyLabel.theme_textColor = ["#FFF", "#FFF"]
            return cell
        } else if collectionView == userViewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserViewCollectionCellID", for: indexPath) as! UserViewCollectionCell
            cell.securityKeyLabel.text = userViewArr[indexPath.row]
            cell.contentView.theme_backgroundColor = ["#EAB671", "#2D2D2D"]
            cell.securityKeyLabel.theme_textColor = ["#FFF", "#FFF"]
            return cell
        }
        return UICollectionViewCell.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text = ""
        if collectionView == userSelectedCollectionView {
            text = userSelectedArr[indexPath.row]
        } else if collectionView == userViewCollectionView {
            text = userViewArr[indexPath.row]
        }
        var cellWidth:CGFloat = 0.0
        let device = "iPade"
        if device.contains("iPad") {
            cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 30.0
        } else {
            cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        }
        return CGSize(width: cellWidth, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userViewCollectionView {
            if self.userViewArr.count == 0 {
                return
            }
            let content = self.userViewArr[indexPath.row]
            self.userSelectedArr.append(content)
            self.userViewArr.remove(at: indexPath.row)
            self.userSelectedCollectionView.reloadData()
            self.userViewCollectionView.reloadData()
        }
        if collectionView == userSelectedCollectionView {
            if self.userSelectedArr.count == 0 {
                return
            }
            let content = self.userSelectedArr[indexPath.row]
            self.userViewArr.append(content)
            self.userSelectedArr.remove(at: indexPath.row)
            self.userSelectedCollectionView.reloadData()
            self.userViewCollectionView.reloadData()
        }
        
    }
    
}
