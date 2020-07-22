//
//  SendCurrencyController.swift
//  NodaWallet

import UIKit
import web3swift
import BigInt
import PromiseKit
import RealmSwift
import ANLoader
import BitcoinKit
import HDWalletKit
import TrustWalletCore

class SendCurrencyController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var receiveAddressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var receiveAddressTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var receiveAddressView: UIView!
    @IBOutlet weak var innerReceiveAddressView: UIView!

    @IBOutlet weak var amountView: UIView!
    
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var scanImage: UIImageView!
    
    /// CONFIRM VIEW
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var getAmountLabel: UILabel!
    @IBOutlet weak var fromTitleLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toTitleLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var networkFeeTitleLabel: UILabel!
    @IBOutlet weak var networkFeeLabel: UILabel!
    @IBOutlet weak var receiveAmountTitleLabel: UILabel!
    @IBOutlet weak var receiveAmountLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var amountInSelectedCurrencyLbl: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var currencyList:CurrencyListDatas!
    var contractABI = ""
    
    var privateKey = ""
    var contractAddress = ""
    
    var maxAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTF.delegate = self
        self.updateAppColor()
    }
    
    private func saveSendHistory(hash: String!, gasPrice: String, nonce: String) {
        let param = ["from_address": currencyList.address,"method":"new_transaction","to_address":self.receiveAddressTF.text!,"currency":currencyList.symbol,"tax_id":hash,"amount":self.amountTF.text!, "device":"iOS","firebase_id":firebaseToken] as [String: AnyObject]
        DataManager.saveSendRequest(parameter: param) { (success, msg, data, error) in
            if success {
                ///show success alert
                ANLoader.hide()
                self.showSuccessAlert()
            } else {
                ANLoader.hide()
               
                self.showSuccessAlert()
            }
        }
    }
    
    private func showSuccessAlert() {
        let okAction = UIAlertAction(title: "ok", style: .default) { (alert) in
        let deadlineTime = DispatchTime.now() + .seconds(1)
           DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
              self.navigationController?.popToRootViewController(animated: true)
           }
        }
        self.showAlertOkAction(message: "Withdraw request placed successfully.Amount will be transferred within 5 minutes", okAction: okAction)
    }
    
    private func updateAppColor() {
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        self.sendView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        self.receiveAddressLabel.theme_textColor = ["#000", "#FFF"]
        self.amountLabel.theme_textColor = ["#000", "#FFF"]
        
        self.receiveAddressTF.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        self.innerReceiveAddressView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]

        self.amountTF.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        
        self.receiveAddressTF.theme_textColor = ["#000", "#FFF"]
        self.amountTF.theme_textColor = ["#000", "#FFF"]
        
        self.pasteButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.amountInSelectedCurrencyLbl.theme_textColor = ["#000", "#FFF"]
        self.amountInSelectedCurrencyLbl.alpha = 0.6
        
        if !Constants.User.isDarkMode {
            scanImage.image = scanImage.image?.withRenderingMode(.alwaysTemplate)
            scanImage.tintColor = UIColor.black
        }
        
        if Constants.User.isDarkMode {
            self.receiveAddressTF.placeHolderColor = .white
            self.amountTF.placeHolderColor = .white
        } else {
            self.receiveAddressTF.placeHolderColor = .black
            self.amountTF.placeHolderColor = .black
        }
        
        self.receiveAddressTF.placeholder = "Recipient_Address".localized()
        self.amountTF.placeholder = "amount_in".localized() + currencyList.symbol
        
        self.receiveAddressView.theme_backgroundColor = ["#AAAAAA", "#000"]
        self.amountView.theme_backgroundColor = ["#AAAAAA", "#000"]
                
        self.receiveAddressLabel.text = "Recipient_Address".localized()
        self.amountLabel.text = "amount_in".localized() + currencyList.symbol
        self.navTitle.text = "send".localized()
        self.sendButton.setTitle("send".localized(), for: .normal)
        self.pasteButton.setTitle("Paste".localized(), for: .normal)
        self.maxButton.setTitle("max".localized(), for: .normal)
        
        self.fromTitleLabel.text = "From".localized()
        self.toTitleLabel.text = "To".localized()
        self.networkFeeTitleLabel.text = "network_fee".localized()
        self.receiveAmountTitleLabel.text = "max_total".localized()
        self.confirmButton.setTitle("confirm".localized(), for: .normal)
        
        //Confirm View
        self.confirmView.theme_backgroundColor = ["#FFF", "#000"]
        self.getAmountLabel.theme_textColor = ["#000", "#FFF"]
        self.fromTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.toTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.receiveAmountTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.networkFeeTitleLabel.theme_textColor = ["#000", "#FFF"]
        
        self.fromAddressLabel.theme_textColor = ["#333333", "#FFF"]
        self.toAddressLabel.theme_textColor = ["#333333", "#FFF"]
        self.networkFeeLabel.theme_textColor = ["#333333", "#FFF"]
        self.receiveAmountLabel.theme_textColor = ["#333333", "#FFF"]
        self.balanceValueLabel.theme_textColor = ["#333333", "#FFF"]
        
        self.maxButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        
        self.fromAddressLabel.theme_alpha = [1, 0.7]
        self.toAddressLabel.theme_alpha = [1, 0.7]
        self.networkFeeLabel.theme_alpha = [1, 0.7]
        self.receiveAmountLabel.theme_alpha = [1, 0.7]
        self.balanceValueLabel.theme_alpha = [1, 0.7]
    }
    
    @IBAction func pasteAction(_ sender: UIButton) {
        if let myString = UIPasteboard.general.string {
            receiveAddressTF.insertText(myString)
        }
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if receiveAddressTF.text!.isEmpty {
            self.popUpView(message: "enter_receiver_address".localized())
            return
        }
        if amountTF.text!.isEmpty {
            self.popUpView(message: "enter_your_amount".localized())
            return
        }
        if self.currencyList.isToken != "currency" && self.currencyList.type != "BEP2" {
            let address = EthereumAddress(receiveAddressTF.text!)
            if address == nil {
                self.popUpView(message: "enter_valid_address".localized())
                return
            }
        }
        if self.currencyList.symbol == "ETH" && self.currencyList.isToken == "currency" {
            let address = EthereumAddress(receiveAddressTF.text!)
            if address == nil {
                self.popUpView(message: "enter_valid_address".localized())
                return
            }
        }
        if self.currencyList.symbol == "BTC" && self.currencyList.isToken == "currency" {
            if self.isValidBitcoinAddress(address: receiveAddressTF.text!) == false {
                self.popUpView(message: "enter_valid_address".localized())
                return
            }
        }
        if self.currencyList.symbol == "BNB" && self.currencyList.isToken == "currency" {
            if validateBinanceAddress(address: receiveAddressTF.text!) == false {
                self.popUpView(message: "enter_valid_address".localized())
                return
            }
        }
        if self.currencyList.isToken != "currency" && self.currencyList.type == "BEP2" {
            if validateBinanceAddress(address: receiveAddressTF.text!) == false {
                self.popUpView(message: "enter_valid_address".localized())
                return
            }
        }
        guard let receiveAmount = amountTF.text else {
            return
        }
        let receiveAmountInDouble = Double(receiveAmount) ?? 0.0
        let balanceInWallet = Double(currencyList.balance) ?? 0.0
        if receiveAmountInDouble <= 0 {
            self.popUpView(message: "please_enter_valid_amount".localized())
            return
        }
        
        if currencyList.address == self.receiveAddressTF.text {
            self.popUpView(message: "try_with_different_address".localized())
            return
        }
       
        if receiveAmountInDouble <= balanceInWallet {
            if SelectedWalletDetails.privateKey.count == 0 {
                return
            }
            self.confirmView.isHidden = false
            self.loadConfirmData()
        } else {
            self.popUpView(message: "no_balance_in_wallet".localized())
        }
    }
    
    private func loadConfirmData() {
        var networkFee = 0.00088
        if self.currencyList.symbol == "BTC" || self.currencyList.symbol == "LTC" {
            networkFee = 0.00025
        }
        if self.currencyList.symbol == "BNB" {
            networkFee = 0.000325
        }
        if self.currencyList.type == "BEP2" {
            networkFee = 0.000325
        }
        let getAmountInDouble = Double(self.amountTF.text ?? "")!
        //let balanceInWallet = Double(currencyList.balance) ?? 0.0
        
        let userEnteredValue = "-" + self.amountTF.text! + " \(currencyList.symbol)"
        self.getAmountLabel.text = userEnteredValue + " (\(self.amountInSelectedCurrencyLbl.text ?? ""))"
        self.fromAddressLabel.text = currencyList.address
        
        if self.currencyList.isToken != "currency" && self.currencyList.type != "BEP2" {
            self.fromAddressLabel.text = SelectedWalletDetails.walletAddress
        } else if self.currencyList.isToken != "currency" && self.currencyList.type == "BEP2" {
            var address = ""
            let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
            for data in currencyData {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol == "BNB" && data.isToken == "currency" {
                        address = data.address
                    }
                }
            }
            self.fromAddressLabel.text = address
        }
        self.toAddressLabel.text = self.receiveAddressTF.text ?? ""
        self.networkFeeLabel.text = String(networkFee)
        
        self.fromAddressLabel.adjustsFontSizeToFitWidth = true
        self.toAddressLabel.adjustsFontSizeToFitWidth = true
        
        let receiveAmount = getAmountInDouble + networkFee
        self.receiveAmountLabel.text = String(format: "%.8f", receiveAmount)
        
        self.maxAmount = receiveAmount
        //let balanceAfterTransaction = balanceInWallet - receiveAmount
        //self.balanceValueLabel.text = "Balance: " + String(format: "%.8f", balanceAfterTransaction)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        let balanceInWallet = Double(currencyList.balance) ?? 0.0
        if balanceInWallet < self.maxAmount {
            self.popUpView(message: "You dont have enough balance to transfer")
            return
        }
        showAppLoader()
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if self.currencyList.isToken != "currency" && self.currencyList.type != "BEP2" {
                self.prepareTransaction(parameters: Data())
                return
            }
            if self.currencyList.symbol == "ETH" && self.currencyList.isToken == "currency" {
                self.sendTransfer()
                return
            }
            if self.currencyList.symbol == "BTC" && self.currencyList.isToken == "currency" {
                self.getBTCTranHash()
                return
            }
            if self.currencyList.symbol == "LTC" && self.currencyList.isToken == "currency" {
                self.getLTCTranHash()
                return
            }
            if self.currencyList.symbol == "BNB" && self.currencyList.isToken == "currency" {
                self.getAccountNumberForBNB(denom: "BNB", bnbAddress: self.currencyList.address)
                return
            }
            if self.currencyList.isToken != "currency" && self.currencyList.type == "BEP2" {
                self.getAccountNumberForBNB(denom: self.currencyList.symbol, bnbAddress: self.fromAddressLabel.text!)
                return
            }
        }
    }
    
    func sendTransfer() {
        let value: String = amountTF.text ?? ""
        
        let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
               
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        let address = keystoreManager.addresses![0]
       // let address = EthereumAddress(SelectedWalletDetails.walletAddress)!
        
        let toAddress = EthereumAddress(receiveAddressTF.text!)!
      //  let contract = web3Main.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = address
        //options.gasPrice = .manual(BigUInt("40000000000"))
        //options.gasLimit = .manual(BigUInt("347578"))
        options.gasPrice = .automatic
        options.gasLimit = .automatic
       
        do {
            let trans = try web3Main.eth.sendETH(to: toAddress, amount: amount!)
            let rbfj = try trans?.send(password: "", transactionOptions: options)
            
            self.saveSendHistory(hash: rbfj!.hash, gasPrice: "\(rbfj!.transaction.gasPrice)", nonce: "\(rbfj!.transaction.nonce)")
        } catch (let err) {
            ANLoader.hide()
            self.showAlert(message: "\(err)")
        }

    }
    
   @IBAction func scanAction(_ sender: UIButton) {
       if let scanVc = self.storyboard?.instantiateViewController(withIdentifier: "CommonScannerControllerID") as? CommonScannerController {
        scanVc.delegate = self
        self.present(scanVc, animated: true, completion: nil)
       }
   }
    
    func prepareTransaction(parameters: Data, gasLimit: BigUInt = 27500) {
        DispatchQueue.main.async {
            
            let value: String = self.amountTF.text ?? ""
           // let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
            
            //let arrString = SelectedWalletDetails.mnemonicData
            //let keystore = try! BIP32Keystore(mnemonics: arrString, password: "", mnemonicsPassword: "")
            let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
            let dataKey = Data.myFromHex(formattedKey)!
                   
            let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
            let keystoreManager = KeystoreManager([keystore])
            web3Main.addKeystoreManager(keystoreManager)
            let ethAddressFrom = keystoreManager.addresses![0]
            
            guard let toConractAdd = EthereumAddress(self.currencyList.address) else {return}
            
            var options = TransactionOptions.defaultOptions
            options.from = ethAddressFrom
            options.to = toConractAdd
            //options.gasPrice = .manual(BigUInt("40000000000"))
            //options.gasLimit = .manual(BigUInt("347578"))
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            options.value = BigUInt(0) // or any other value you want to send

            //let valueToSend = Web3.Utils.parseToBigUInt(value, decimals: 6)!
            let valueToSend = Web3.Utils.parseToBigUInt(value, decimals: self.currencyList.decimal)!
           
            guard let contract = web3Main.contract(Web3Utils.erc20ABI, at: toConractAdd, abiVersion: 2) else {return}
                 
            let toAddr = EthereumAddress(self.receiveAddressTF.text!)!
           
            let transaction = contract.write("transfer", parameters: [toAddr, valueToSend] as [AnyObject], extraData: Data(), transactionOptions: options)!
            
            do {
                let send = try transaction.send(password: "", transactionOptions: options)
               
                self.saveSendHistory(hash: send.hash, gasPrice: "\(send.transaction.gasPrice)", nonce: "\(send.transaction.nonce)")
            } catch(let err) {
               
                ANLoader.hide()
                self.showAlert(message: err.localizedDescription)
            }
            
        }
    }
    
    private func getBTCTranHash() {
        let satoshiAmount = self.convertToSatoshi(value: Decimal(string: self.amountTF.text ?? "") ?? 0)
        
        let param = ["inputs":[["addresses":[self.currencyList.address]]],"outputs":[["addresses":[self.receiveAddressTF.text!],"value":satoshiAmount]]]
        
        BTCDataManager.getTransactionHash(parameter: param as [String : Any]) { (success, signString, tranactions, data, error) in
            if success {
                self.sendBTC(signStr: signString, tx: tranactions)
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
    
    private func sendBTC(signStr: [String], tx: [String: Any]) {
        
        let mnemonicPhrase = SelectedWalletDetails.mnemonicData
        let sep = mnemonicPhrase.components(separatedBy: " ")
        let mnemonic = [sep[0], sep[1], sep[2], sep[3], sep[4], sep[5], sep[6], sep[7], sep[8], sep[9], sep[10], sep[11]]
        do {
            let seed = try Mnemonic.seed(mnemonic: mnemonic)
                
            let wallet = HDWallet(seed: seed, externalIndex: .zero, internalIndex: .zero, network: .mainnetBTC)
            
            let pubKey = wallet.pubKey(index: 0, chain: .external)
            
            var afterSignArr = [String]()
            var publicKeyArr = [String]()
                
            for sign in signStr {
                let data = Data.init(btcHex: sign)
                let signatureData = wallet.privKeys[0].sign(data!)
               
                afterSignArr.append(signatureData.btcHex)
                publicKeyArr.append(pubKey.description)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.sendTransaction(tran: tx, signArr: signStr, afterSignArr: afterSignArr, publicKeyArr: publicKeyArr)
            }
                
        } catch(let err) {
            ANLoader.hide()
        }
    }
    
    private func sendTransaction(tran: [String: Any], signArr: [String], afterSignArr: [String], publicKeyArr: [String]) {
        let param = ["tx": tran, "tosign": signArr, "signatures": afterSignArr, "pubkeys": publicKeyArr] as [String : Any]
        print("myparam", param)
        BTCDataManager.sendTransactionHash(parameter: param) { (success, hash, data, error) in
            if success {
                self.saveSendHistory(hash: hash, gasPrice: "", nonce: "")
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
    
    @IBAction func maxAmountAction(_ sender: UIButton) {
        self.amountTF.text = self.currencyList.balance
        self.textFieldDidEndEditing(self.amountTF)
    }
    
}

extension SendCurrencyController: CommonScannerControllerDelegate {
    func scannedQR(qrCode: String) {
        self.receiveAddressTF.text = qrCode
    }
    
}

extension SendCurrencyController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" || string != "" {
            let res = (textField.text ?? "") + string
            return Double(res) != nil
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTF {
            if textField.text!.isEmpty {
                return
            }
            let amountInDouble = Double(amountTF.text!)!
            let marketPriceInDouble = Double(currencyList.marketPrice)!
            let amountToShow = amountInDouble * marketPriceInDouble
            let amountInString = String(format: "%.2f", amountToShow)
            self.amountInSelectedCurrencyLbl.text = "~\(userSelectedCurrencySymbol) \(amountInString)"
        }
    }
}

extension SendCurrencyController {
    private func getLTCTranHash() {
        let satoshiAmount = self.convertToSatoshi(value: Decimal(string: self.amountTF.text ?? "") ?? 0)
       
        let param = ["inputs":[["addresses":[self.currencyList.address]]],"outputs":[["addresses":[self.receiveAddressTF.text!],"value":satoshiAmount]]]
       
        LTCDataManager.getTransactionHash(parameter: param as [String : Any]) { (success, signString, tranactions, data, error) in
            if success {
                self.sendLTC(signStr: signString, tx: tranactions)
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
    
    private func sendLTC(signStr: [String], tx: [String: Any]) {
        
        let mnemonicPhrase = SelectedWalletDetails.mnemonicData
        let seed = Mnemonic.createSeed(mnemonic: mnemonicPhrase)
        do {
            let purpose1 = PrivateKey.init(seed: seed, coin: .litecoin)
            
            let purpose = purpose1.derived(at: .hardened(44))
            // m/44'/0'
            //Litecoin
            let coinType = purpose.derived(at: .hardened(2))
            // m/44'/0'/0'
            let account = coinType.derived(at: .hardened(0))
            // m/44'/0'/0'/0
            let change = account.derived(at: .notHardened(0))
            let firstPrivateKey = change.derived(at: .notHardened(0))
            
            var afterSignArr = [String]()
            var publicKeyArr = [String]()
                
            for sign in signStr {
                let data = Data.init(btcHex: sign)
                let signatureData = _Crypto.signMessage(data!, withPrivateKey: firstPrivateKey.raw)
               
                afterSignArr.append(signatureData.btcHex)
                publicKeyArr.append(firstPrivateKey.publicKey.get())
            }
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.sendLTCTransaction(tran: tx, signArr: signStr, afterSignArr: afterSignArr, publicKeyArr: publicKeyArr)
            }
                
        } catch(let err) {
            ANLoader.hide()
        }
    }
    
    private func sendLTCTransaction(tran: [String: Any], signArr: [String], afterSignArr: [String], publicKeyArr: [String]) {
        let param = ["tx": tran, "tosign": signArr, "signatures": afterSignArr, "pubkeys": publicKeyArr] as [String : Any]
        LTCDataManager.sendTransactionHash(parameter: param) { (success, hash, data, error) in
            if success {
                self.saveSendHistory(hash: hash, gasPrice: "", nonce: "")
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
}

extension SendCurrencyController {
    
    private func getAccountNumberForBNB(denom: String, bnbAddress: String) {
        BNBDataManager.getAccountDetailsBNB(address: bnbAddress) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let accountNo = json["account_number"] as? Int64 {
                    if let sequence = json["sequence"] as? Int64 {
                        let amount = self.amountTF.text ?? ""
                        let amountInDouble = Double(amount)!
                        let amountToSend = self.bnbAmountConvertion(priceInDouble: amountInDouble, decimal: 8)
                        self.sendBNBTransaction(amount: amountToSend, accountNo: accountNo, sequenceNo: sequence, denom: denom)
                    }
                }
            } else {
                ANLoader.hide()
                self.popUpView(message: msg)
            }
        }
    }
    
    private func sendBNBTransaction(amount: Int64, accountNo: Int64, sequenceNo: Int64, denom: String) {
        let wallet = HDWallet(mnemonic: SelectedWalletDetails.mnemonicData, passphrase: "")

        let privateKey = wallet.getKeyForCoin(coin: .binance)
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        
        let token = BinanceSendOrder.Token.with {
            $0.denom = denom // BNB or BEP2 token symbol
            $0.amount = amount   // Amount, 1 BNB
        }
        
        let orderInput = BinanceSendOrder.Input.with {
            $0.address = AnyAddress(publicKey: publicKey, coin: .binance).data
            $0.coins = [token]
        }

        let orderOutput = BinanceSendOrder.Output.with {
            $0.address = AnyAddress(string: receiveAddressTF.text!, coin: .binance)!.data
            $0.coins = [token]
        }
        
        let input = BinanceSigningInput.with {
            $0.chainID = "Binance-Chain-Tigris" // Chain id (network id),                 from /v1/node-info api
            $0.accountNumber = accountNo              // On chain account / address number,     from /v1/account/<address> api
            $0.sequence = sequenceNo                 // Sequence number, plus 1 for new order, from /v1/account/<address> api
            $0.source = 0                     // BEP10 source id
            $0.privateKey = privateKey.data
            $0.memo = ""
            $0.sendOrder = BinanceSendOrder.with {
                $0.inputs = [orderInput]
                $0.outputs = [orderOutput]
            }
        }

        let output: BinanceSigningOutput = AnySigner.sign(input: input, coin: .binance)
        let param = ["body": output.encoded.hexString] as [String: Any]
        BNBDataManager.BNBSendTX(body: output.encoded, parameter: param) { (success, hash, data, error) in
            if success {
                self.saveSendHistory(hash: hash, gasPrice: "", nonce: "")
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
}

