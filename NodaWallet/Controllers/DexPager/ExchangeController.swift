//
//  ExchangeController.swift
//  NodaWallet
//

import UIKit
import XLPagerTabStrip
import FittedSheets
import web3swift
import BigInt
import RealmSwift
import ANLoader
import BitcoinKit
import HDWalletKit
import TrustWalletCore

class ExchangeController: UIViewController {

    var itemInfo: IndicatorInfo = "Exchange"
    
    @IBOutlet weak var buyCrptoView: UIView!
    @IBOutlet weak var youSendView: UIView!
    @IBOutlet weak var youGetView: UIView!
    
    @IBOutlet weak var cryptoPurchaseLabel: UILabel!
    @IBOutlet weak var noteContent: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
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
    
    @IBOutlet weak var alterView: UIView!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var fromBalanceLabel: UILabel!
    @IBOutlet weak var toBalanceLabel: UILabel!
    
    
    var currencyList = [CurrencyListDatas]()
    var sendAddress = ""
    var getAddress = ""
    
    var contractAddress = ""
    var privateKey = ""
    
    var fromBalance = ""
    var toBalance = ""
    
    var calculatedMarketPrice = ""
    
    var fromIndex = 0
    var toIndex = 0
    
    var isToken = ""
    
    var minimumExchangePrice = 0.0
    var maximumExchangePrice = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.youSendTF.delegate = self
        self.youGetTF.delegate = self
        self.updateAppColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyList.removeAll()
        self.updateCurrencyList()
    }
    
    private func updateAppColor() {
        self.buyCrptoView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        
        //self.youSendView.theme_backgroundColor = ["#DFDEDC", "#3E3D3A"]
        //self.youGetView.theme_backgroundColor = ["#DFDEDC", "#3E3D3A"]
        
        self.youSendView.theme_backgroundColor = ["#F0F0F0", "#3E3D3A"]
        self.youGetView.theme_backgroundColor = ["#F0F0F0", "#3E3D3A"]
        
        self.cryptoPurchaseLabel.theme_textColor = ["#000", "#FFF"]
        self.noteContent.theme_textColor = ["#000", "#FFF"]
        self.feeLabel.theme_textColor = ["#000", "#FFF"]
        self.minLabel.theme_textColor = ["#000", "#FFF"]
        self.maxLabel.theme_textColor = ["#000", "#FFF"]
        
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
        
        self.fromBalanceLabel.theme_textColor = ["#000", "#FFF"]
        self.toBalanceLabel.theme_textColor = ["#000", "#FFF"]
        
        if Constants.User.isDarkMode {
            self.buyCrptoView.layer.shadowColor = UIColor.darkGray.cgColor
            self.youSendTF.placeHolderColor = UIColor.white
            self.youGetTF.placeHolderColor = UIColor.white
        } else {
            self.buyCrptoView.layer.shadowColor = UIColor.lightGray.cgColor
            self.youSendTF.placeHolderColor = UIColor.darkGray
            self.youGetTF.placeHolderColor = UIColor.darkGray
        }
        
        self.cryptoPurchaseLabel.text = "exchange".localized()
        self.youSendLabel.text = "You_pay".localized()
        self.youGetLabel.text = "You_are_getting".localized()
        self.furtherButton.setTitle("Further".localized(), for: .normal)
    }
    
    private func updateCurrencyList() {
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.enable == true {
                    if data.isToken != "usertoken" && data.type != "BEP2" {
                        currencyList.append(data)
                    }
                }
            }
        }
        if currencyList.count > 0 {
            fromIndex = 0
        }
        if currencyList.count > 1 {
            toIndex = 1
        }
        self.loadCurrencyOnTF(fromIndex: fromIndex, toIndex: toIndex)
    }
    
    private func loadCurrencyOnTF(fromIndex: Int, toIndex:Int) {
        self.sendCurrencyLabel.text = currencyList[fromIndex].symbol
        self.currencySendImage.loadImage(string: currencyList[fromIndex].currencyImage)
        self.fromBalance = currencyList[fromIndex].balance
        self.sendAddress = currencyList[fromIndex].address
        self.isToken = currencyList[fromIndex].isToken
        
        self.getCurrencyLabel.text = currencyList[toIndex].symbol
        self.currencyGetImage.loadImage(string: currencyList[toIndex].currencyImage)
        self.toBalance = currencyList[toIndex].balance
        self.getAddress = currencyList[toIndex].address
        
        //update currency value
        let fromMarket = currencyList[fromIndex].marketPrice
        let toMarket = currencyList[toIndex].marketPrice
        let fromMarketToDouble = Double(fromMarket) ?? 0
        let toMarketToDouble = Double(toMarket) ?? 0
        let calculateMarketPrice = fromMarketToDouble / toMarketToDouble
        let finalMarketPrice = String(format: "%.8f", calculateMarketPrice)
        self.noteContent.text = "1 \(currencyList[fromIndex].symbol) = \(finalMarketPrice) \(currencyList[toIndex].symbol)"
        
        self.calculatedMarketPrice = finalMarketPrice
        
        //show balance
        self.fromBalanceLabel.text = "Balance".localized() + ": \(self.fromBalance)"
        self.toBalanceLabel.text = "Balance".localized() + ": \(self.toBalance)"
        self.getMinimumTransaction(fromCurrency: currencyList[fromIndex].symbol, toCurrency: currencyList[toIndex].symbol)
    }
    
    private func getMinimumTransaction(fromCurrency: String, toCurrency: String) {
        let param = ["from_currency": fromCurrency, "to_currency": toCurrency] as [String : AnyObject]
        DataManager.getMinimumTransactionValue(parameter: param) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let responseArr = json["data"] as? [String: Any] {
                    let result = responseArr["result"] as? String ?? ""
                    self.minimumExchangePrice = Double(result) ?? 0.0
                    self.minLabel.text = "Min " + "\(result) \(self.sendCurrencyLabel.text!)"
                    self.maxLabel.text = "Max " + "\(self.maximumExchangePrice) \(self.sendCurrencyLabel.text!)"
                }
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
    @IBAction func alterAction(_ sender: Any) {
        let from = self.fromIndex
        let to = self.toIndex
        self.fromIndex = to
        self.toIndex = from
        self.youSendTF.text = ""
        self.youGetTF.text = ""
        self.noteContent.text = ""
        self.feeLabel.text = ""
        self.loadCurrencyOnTF(fromIndex: self.fromIndex, toIndex: self.toIndex)
    }
    
    @IBAction func youGetCurrencyAction(_ sender: Any) {
        self.showCurrencyList(isSend: false)
    }
    
    @IBAction func youSendCurrencyAction(_ sender: Any) {
        self.showCurrencyList(isSend: true)
    }
    
    private func showCurrencyList(isSend: Bool) {
        self.youGetTF.resignFirstResponder()
        self.youSendTF.resignFirstResponder()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DexCurrencyListControllerID") as! DexCurrencyListController
        let sheetController = SheetViewController(controller: controller)
        controller.delegate = self
        controller.isSend = isSend
        controller.sendCurrencyName = sendCurrencyLabel.text ?? ""
        controller.getCurrencyName = getCurrencyLabel.text ?? ""
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func furtherAction(_ sender: Any) {
        if youSendTF.text!.isEmpty || youSendTF.text == "0" || youSendTF.text == "0.0" || youSendTF.text!.count == 0 {
            self.showAlert(message: "enter_your_amount".localized())
            return
        }
        let youSendInDouble = Double(self.youSendTF.text!)!
        let fromBalanceInDouble = Double(self.fromBalance)!
        if youSendInDouble > fromBalanceInDouble {
            self.popUpView(message: "no_balance_in_wallet".localized())
            return
        }
        if youSendInDouble < minimumExchangePrice {
            self.popUpView(message: "Your \(self.sendCurrencyLabel.text!) \("should_greater_than".localized()) \(minimumExchangePrice)")
            return
        }
        if youSendInDouble > maximumExchangePrice {
            self.popUpView(message: "Your \(self.sendCurrencyLabel.text!) \("should_not_greater_than".localized()) \(maximumExchangePrice)")
            return
        }
        if SelectedWalletDetails.privateKey.count == 0 {
            return
        }
        self.updateExchangeProcess()
    }
    
    private func updateExchangeProcess() {
        let param = ["from_currency":currencyList[fromIndex].symbol,"to_currency":currencyList[toIndex].symbol,"amount":self.youSendTF.text!,"receive_address":currencyList[toIndex].address,"device":"iOS","firebase_id":firebaseToken] as [String: AnyObject]
        DataManager.createExchangeTransaction(parameter: param) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let responseArr = json["data"] as? [String: Any] {
                    if let depositAddress = responseArr["deposit_address"] as? String {
                        let depositAmount = responseArr["deposit_amount"] as? String ?? ""
                        let memoID = responseArr["extra_id"] as? String ?? ""
                        let currency = param["from_currency"] as? String ?? ""
                        showAppLoader()
                        if currency == "ETH" {
                            self.exchangeFromETH(value: depositAmount, depositAddress: depositAddress)
                        } else if currency == "BTC" {
                            self.getTranHash(value: depositAmount, depositAddress: depositAddress)
                        } else if currency == "LTC" {
                            self.getLTCTranHash(value: depositAmount, depositAddress: depositAddress)
                        } else if currency == "BNB" {
                            self.getAccountNumberForBNB(value: depositAmount, depositAddress: depositAddress, memoId: memoID)
                        } else {
                            self.exchangeFromToken(value: depositAmount, depositAddress: depositAddress)
                        }
                    }
                }
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
    func exchangeFromETH(value: String, depositAddress: String) {
        
        let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
               
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        let address = keystoreManager.addresses![0]
       // let address = EthereumAddress(SelectedWalletDetails.walletAddress)!
        
        let toAddress = EthereumAddress(depositAddress)!
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
            let sendTransaction = try trans?.send(password: "", transactionOptions: options)
            self.showAlertAfterSuccess()
        } catch (let err) {
            ANLoader.hide()
            self.showAlert(message: "\(err)")
        }

    }
    
    private func getTranHash(value: String, depositAddress: String) {
        let satoshiAmount = self.convertToSatoshi(value: Decimal(string: value) ?? 0)
        let param = ["inputs":[["addresses":[self.currencyList[fromIndex].address]]],"outputs":[["addresses":[depositAddress],"value": satoshiAmount]]]
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.sendTransaction(tran: tx, signArr: signStr, afterSignArr: afterSignArr, publicKeyArr: publicKeyArr)
            }
                
        } catch(let err) {
            ANLoader.hide()
            
        }
    }
    
    private func sendTransaction(tran: [String: Any], signArr: [String], afterSignArr: [String], publicKeyArr: [String]) {
        let param = ["tx": tran, "tosign": signArr, "signatures": afterSignArr, "pubkeys": publicKeyArr] as [String : Any]
       
        BTCDataManager.sendTransactionHash(parameter: param) { (success, hash, data, error) in
            if success {
                //self.showSuccessExchange(hash: hash)
                self.showAlertAfterSuccess()
            } else {
                 ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
    
    private func exchangeFromToken(value: String, depositAddress: String) {
        DispatchQueue.main.async {
            
            let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
            let dataKey = Data.myFromHex(formattedKey)!
                   
            let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
            let keystoreManager = KeystoreManager([keystore])
            web3Main.addKeystoreManager(keystoreManager)
            let ethAddressFrom = keystoreManager.addresses![0]
            

            guard let toConractAdd = EthereumAddress(self.currencyList[self.fromIndex].address) else {return}
            
            var options = TransactionOptions.defaultOptions
            options.from = ethAddressFrom
            options.to = toConractAdd
            //options.gasPrice = .manual(BigUInt("40000000000"))
            //options.gasLimit = .manual(BigUInt("347578"))
            options.gasPrice = .automatic
            options.gasLimit = .automatic
            options.value = BigUInt(0) // or any other value you want to send

            //let valueToSend = Web3.Utils.parseToBigUInt(value, decimals: 6)!
            let valueToSend = Web3.Utils.parseToBigUInt(value, decimals: self.currencyList[self.fromIndex].decimal)!
            
            guard let contract = web3Main.contract(Web3Utils.erc20ABI, at: toConractAdd, abiVersion: 2) else {return}
                 
            let toAddr = EthereumAddress(depositAddress)!
           
            let transaction = contract.write("transfer", parameters: [toAddr, valueToSend] as [AnyObject], extraData: Data(), transactionOptions: options)!
            
            do {
                let send = try transaction.send(password: "", transactionOptions: options)
                //self.showSuccessExchange(hash: send.hash)
                self.showAlertAfterSuccess()
            } catch(let err) {
                ANLoader.hide()
                self.showAlert(message: err.localizedDescription)
            }
            
        }
    }
    
    private func showAlertAfterSuccess() {
        ANLoader.hide()
        let okAction = UIAlertAction(title: "ok", style: .default) { (alert) in
            self.youSendTF.text = ""
            self.youGetTF.text = ""
            self.feeLabel.text = ""
        }
        self.showAlertOkAction(message: "Exchange_Success".localized(), okAction: okAction)
    }
        
}

extension ExchangeController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "exchange".localized())
    }
}

extension ExchangeController: DexCurrencyListControllerDelegate {
    
    func currencySelected(isSend: Bool, index: Int, currencySymbol: String, currencyImage: String, balance: String) {
        if isSend {
            if index == self.toIndex {
                self.alterAction((Any).self)
                return
            }
            self.fromIndex = index
            self.loadCurrencyOnTF(fromIndex: index, toIndex: self.toIndex)
        } else {
            if index == self.fromIndex {
                self.alterAction((Any).self)
                return
            }
            self.toIndex = index
            self.loadCurrencyOnTF(fromIndex: self.fromIndex, toIndex: index)
        }
    }
    
    private func showApproximateReceiveAmount(amount: Double) {
        let param = ["from_currency":currencyList[fromIndex].symbol,"to_currency":currencyList[toIndex].symbol,"amount":amount] as [String : AnyObject]
        DataManager.getApproximateValue(parameter: param) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let responseArr = json["data"] as? [String: Any] {
                    if let result = responseArr["result"] as? String {
                        self.feeLabel.text = "Approx amount: " + result
                    }
                }
            } else {
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
    
}

extension ExchangeController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty {
            return
        }
        
        if textField == youSendTF {
            let youSend = Double(youSendTF.text!)!
            let marketPriceInDouble = youSend * Double(self.calculatedMarketPrice)!
            self.youGetTF.text = String(format: "%.8f", marketPriceInDouble)
            self.showApproximateReceiveAmount(amount: youSend)
        }
        
        if textField == youGetTF {
            let youGet = Double(youGetTF.text!)!
            
            let fromMarket = currencyList[fromIndex].marketPrice
            let toMarket = currencyList[toIndex].marketPrice
            let fromMarketToDouble = Double(fromMarket) ?? 0
            let toMarketToDouble = Double(toMarket) ?? 0
            let calculateMarketPrice = toMarketToDouble / fromMarketToDouble
            let finalMarketPrice = String(format: "%.8f", calculateMarketPrice)
            
            let marketPriceInDouble = youGet * Double(finalMarketPrice)!
            self.youSendTF.text = String(format: "%.8f", marketPriceInDouble)
            let youSend = Double(youSendTF.text!)!
            self.showApproximateReceiveAmount(amount: youSend)
        }
        
    }
}

extension ExchangeController {
    private func getLTCTranHash(value: String, depositAddress: String) {
        let satoshiAmount = self.convertToSatoshi(value: Decimal(string: value) ?? 0)
        let param = ["inputs":[["addresses":[self.currencyList[fromIndex].address]]],"outputs":[["addresses":[depositAddress],"value": satoshiAmount]]]
        
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
                self.showAlertAfterSuccess()
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
}

extension ExchangeController {
    
    private func getAccountNumberForBNB(value: String, depositAddress: String, memoId: String) {
        BNBDataManager.getAccountDetailsBNB(address: self.currencyList[fromIndex].address) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let accountNo = json["account_number"] as? Int64 {
                    if let sequence = json["sequence"] as? Int64 {
                        let amountInDouble = Double(value)!
                        let amountToSend = self.bnbAmountConvertion(priceInDouble: amountInDouble, decimal: 8)
                        self.sendBNBTransaction(amount: amountToSend, accountNo: accountNo, sequenceNo: sequence, depositAddr: depositAddress, memoID: memoId)
                    }
                }
            } else {
                ANLoader.hide()
                self.popUpView(message: msg)
            }
        }
    }
    
    private func sendBNBTransaction(amount: Int64, accountNo: Int64, sequenceNo: Int64, depositAddr: String, memoID: String) {
        let wallet = HDWallet(mnemonic: SelectedWalletDetails.mnemonicData, passphrase: "")

        let privateKey = wallet.getKeyForCoin(coin: .binance)
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        
        let token = BinanceSendOrder.Token.with {
            $0.denom = "BNB" // BNB or BEP2 token symbol
            $0.amount = amount   // Amount, 1 BNB
        }
        
        let orderInput = BinanceSendOrder.Input.with {
            $0.address = AnyAddress(publicKey: publicKey, coin: .binance).data
            $0.coins = [token]
        }

        let orderOutput = BinanceSendOrder.Output.with {
            $0.address = AnyAddress(string: depositAddr, coin: .binance)!.data
            $0.coins = [token]
        }
        
        let input = BinanceSigningInput.with {
            $0.chainID = "Binance-Chain-Tigris" // Chain id (network id),                 from /v1/node-info api
            $0.accountNumber = accountNo              // On chain account / address number,     from /v1/account/<address> api
            $0.sequence = sequenceNo                 // Sequence number, plus 1 for new order, from /v1/account/<address> api
            $0.source = 0                     // BEP10 source id
            $0.privateKey = privateKey.data
            $0.memo = memoID
            $0.sendOrder = BinanceSendOrder.with {
                $0.inputs = [orderInput]
                $0.outputs = [orderOutput]
            }
        }

        let output: BinanceSigningOutput = AnySigner.sign(input: input, coin: .binance)
        let param = ["body": output.encoded.hexString] as [String: Any]
        BNBDataManager.BNBSendTX(body: output.encoded, parameter: param) { (success, hash, data, error) in
            if success {
                self.showAlertAfterSuccess()
            } else {
                ANLoader.hide()
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }
}

