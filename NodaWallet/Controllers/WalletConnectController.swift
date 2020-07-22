//
//  WalletConnectController.swift
//  NodaWallet
//
//  Created by macOsx on 04/05/20.
//  .
//

import UIKit
import WalletConnect
import TrustWalletCore
import web3swift
import BigInt

class WalletConnectController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var connectedToTitleLabel: UILabel!
    @IBOutlet weak var connectedToLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    
    var interactor: WCInteractor?
    let clientMeta = WCPeerMeta(name: "WalletConnect SDK", url: "https://github.com/TrustWallet/wallet-connect-swift")

    var privateKey = PrivateKey(data: Data(hexString: SelectedWalletDetails.privateKey)!)!

    var defaultAddress: String = ""
    var defaultChainId: Int = 1
    
    var qrCodeString = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultAddress = CoinType.ethereum.deriveAddress(privateKey: privateKey)
        
        if qrCodeString.contains("binance") {
            let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
            for data in currencyData {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol == "BNB" && data.currencyName == "Binance" {
                        self.privateKey = PrivateKey(data: Data(hexString: data.privateKey)!)!
                    }
                }
            }
            defaultAddress = CoinType.binance.deriveAddress(privateKey: privateKey)
        }
        
        approveButton.isEnabled = false
        
        guard let session = WCSession.from(string: qrCodeString) else {
            DispatchQueue.main.async {
                APPDELEGATE.homepage()
            }
            return
        }
        
        if let i = interactor, i.connected {
            i.killSession().done {  [weak self] in
                self?.approveButton.isEnabled = false
                self?.connectButton.setTitle("Connect", for: .normal)
            }.cauterize()
        } else {
            connect(session: session)
        }
        
        self.updateAppColorAndLocalization()
    }
    
    private func updateAppColorAndLocalization() {
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        
        self.siteNameLabel.theme_textColor = ["#000", "#FFF"]
        self.connectedToTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.connectedToLabel.theme_textColor = ["#000", "#FFF"]
        self.addressTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.addressLabel.theme_textColor = ["#000", "#FFF"]
        
        self.navigationTitle.text = "wallet_connect".localized()
        self.connectedToTitleLabel.text = "connected_to".localized()
        self.addressTitleLabel.text = "Address".localized()
    }
    
    func connect(session: WCSession) {
        let interactor = WCInteractor(session: session, meta: clientMeta)

        configure(interactor: interactor)

        interactor.connect().done { [weak self] connected in
            self?.connectionStatusUpdated(connected)
        }.cauterize()

        self.interactor = interactor
    }

    func configure(interactor: WCInteractor) {
        let accounts = [defaultAddress]
        let chainId = defaultChainId
        
        interactor.onSessionRequest = { [weak self] (id, peer) in
            let message = [peer.description, peer.url].joined(separator: "\n")
            let alert = UIAlertController(title: peer.name, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                self?.interactor?.rejectSession().cauterize()
                DispatchQueue.main.async {
                    APPDELEGATE.homepage()
                }
            }))
            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
                self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
                self?.updateWalletData(peer: peer)
            }))
           // self?.show(alert, sender: nil)
            self?.present(alert, animated: true, completion: nil)
        }

        interactor.onDisconnect = { [weak self] (error) in
            self?.connectionStatusUpdated(false)
        }

        interactor.onEthSign = { [weak self] (id, params) in
            let alert = UIAlertController(title: "eth_sign".localized(), message: params[1], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign".localized(), style: .default, handler: { _ in
                self?.signEth(id: id, message: params[0])
            }))
            //self?.show(alert, sender: nil)
            self?.present(alert, animated: true, completion: nil)
        }

        interactor.onEthSendTransaction = { [weak self] (id, transaction) in
            //let data = try! JSONEncoder().encode(transaction)
           // let message = String(data: data, encoding: .utf8)
           
            let amount = Web3Utils.hexToBigUInt(transaction.value)!
            let valueInETH = Web3.Utils.formatToEthereumUnits(amount)!
            let alert = UIAlertController(title: "confirm_Transaction".localized(), message: "Transfer \(valueInETH) ETH to: \(transaction.to)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "reject".localized(), style: .destructive, handler: { _ in
                self?.interactor?.rejectRequest(id: id, message: "I don't have ethers").cauterize()
            }))
            //customising by me
            alert.addAction(UIAlertAction(title: "wallet_confirm".localized(), style: .default, handler: { _ in
                if transaction.data.count > 3 {
                     self?.customExchangeSend(transaction: transaction, id: id)
                } else {
                    self?.customEthSend(transaction: transaction, id: id)
                }
            }))
            //self?.show(alert, sender: nil)
            self?.present(alert, animated: true, completion: nil)
        }

        interactor.onBnbSign = { [weak self] (id, order) in
            var message = order.encodedString
            let orderData = message.data(using: .utf8)!
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: orderData, options : .allowFragments) as? [String: Any] {
                   
                    if let inputArr = jsonResponse["msgs"] as? [[String: Any]] {
                        if let addressArr = inputArr[0]["inputs"] as? [[String: Any]] {
                            if let toAddress = addressArr[0]["address"] as? String {
                                message = "Transfer to: \(toAddress)"
                                
                            }
                        } else {
                            if let price = inputArr[0]["price"] as? Double {
                                if let quantity = inputArr[0]["quantity"] as? Double {
                                    let symbol = inputArr[0]["symbol"] as? String ?? ""
                                    let priceToShow = (self?.convertedUsingDecimal(priceInDouble: price, decimal: 8) ?? "")
                                    let quantityToShow = (self?.convertedUsingDecimal(priceInDouble: quantity, decimal: 8) ?? "")
                                    message = "Trade " + priceToShow + " BNB for " + quantityToShow + " \(symbol)"
                                   
                                }
                            }
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            let alert = UIAlertController(title: "bnb_sign".localized(), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "reject".localized(), style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "wallet_confirm".localized(), style: .default, handler: { [weak self] _ in
                self?.signBnbOrder(id: id, order: order)
            }))
            //self?.show(alert, sender: nil)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateWalletData(peer: WCPeerMeta) {
        self.iconImage.isHidden = false
        self.siteNameLabel.isHidden = false
        self.connectedToTitleLabel.isHidden = false
        self.connectedToLabel.isHidden = false
        self.addressTitleLabel.isHidden = false
        self.addressLabel.isHidden = false
        self.connectButton.isHidden = false
        
        self.iconImage.loadImage(string: peer.icons[0])
        self.siteNameLabel.text = peer.name
        self.connectedToLabel.text = peer.url
        self.addressLabel.text = defaultAddress
        
        if peer.url.contains("kyberswap") {
            self.iconImage.image = UIImage(named: "Kyberswap")
        }
    }

    func approve(accounts: [String], chainId: Int) {
        interactor?.approveSession(accounts: accounts, chainId: chainId).done {
            print("<== approveSession done")
        }.cauterize()
    }

    func signEth(id: Int64, message: String) {
        print("messageReceived", message)
       
        if SelectedWalletDetails.privateKey.count == 0 {
            return
        }
        
        let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
               
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        let address = keystoreManager.addresses![0]
        
        do {
            let output = try web3Main.wallet.signPersonalMessage(message, account: address, password: "")
            print("outesq", output.hexString)
            self.interactor?.approveRequest(id: id, result: output.hexString).cauterize()
        } catch (let error) {
            print("errty", error)
        }
        
    }

    func signBnbOrder(id: Int64, order: WCBinanceOrder) {
        let data = order.encoded
       
        let signature = privateKey.sign(digest: Hash.sha256(data: data), curve: .secp256k1)!
        let signed = WCBinanceOrderSignature(
            signature: signature.dropLast().hexString,
            publicKey: privateKey.getPublicKeySecp256k1(compressed: false).data.hexString
        )
        interactor?.approveBnbOrder(id: id, signed: signed).done({ confirm in
            if confirm.ok {
                self.showAlert(message: "Transaction sent successfully")
            } else {
                self.popUpView(message: confirm.errorMsg ?? "")
            }
        }).cauterize()
    }

    func connectionStatusUpdated(_ connected: Bool) {
        self.approveButton.isEnabled = connected
        self.connectButton.setTitle(!connected ? "Connect" : "Disconnect", for: .normal)
        
        if !connected {
            disconnectSession()
        }
    }
    
    func customEthSend(transaction: WCEthereumSendTransaction, id: Int64) {
        if SelectedWalletDetails.privateKey.count == 0 {
            return
        }
        
        let toAddress = EthereumAddress(transaction.to)!
        let gasPrice = Web3Utils.hexToBigUInt(transaction.gasPrice)
        let gasLimit = Web3Utils.hexToBigUInt(transaction.gasLimit)
        let amount = Web3Utils.hexToBigUInt(transaction.value)
        
        //let arrString = SelectedWalletDetails.mnemonicData
        //let keystore = try! BIP32Keystore(mnemonics: arrString, password: "", mnemonicsPassword: "")
        let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
               
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        let address = keystoreManager.addresses![0]
              
        var options = TransactionOptions.defaultOptions
        options.value = amount!
        options.from = address
        options.gasPrice = .manual(gasPrice!)
        options.gasLimit = .manual(gasLimit!)
    
        do {
            let trans = try web3Main.eth.sendETH(to: toAddress, amount: amount!)
            let rbfj = try trans?.send(password: "", transactionOptions: options)
            print("result", rbfj?.transaction as Any)
            self.interactor?.approveRequest(id: id, result: rbfj!.hash).cauterize()
            self.showAlert(message: "Transaction sent successfully")
        } catch (let err) {
            print("send_bug", err)
            self.showAlert(message: err.localizedDescription)
        }
    }
    
    func customExchangeSend(transaction: WCEthereumSendTransaction, id: Int64) {
        if SelectedWalletDetails.privateKey.count == 0 {
            return
        }
        
        let toAddress = EthereumAddress(transaction.to)!
        let gasPrice = Web3Utils.hexToBigUInt(transaction.gasPrice)
        let gasLimit = Web3Utils.hexToBigUInt(transaction.gasLimit)
        let amount = Web3Utils.hexToBigUInt(transaction.value)
        
        //let arrString = SelectedWalletDetails.mnemonicData
        //let keystore = try! BIP32Keystore(mnemonics: arrString, password: "", mnemonicsPassword: "")
        let formattedKey = SelectedWalletDetails.privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.myFromHex(formattedKey)!
               
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: "")!
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        let address = keystoreManager.addresses![0]
              
        let contract = web3Main.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!

        var options = TransactionOptions.defaultOptions
        options.value = amount!
        options.from = address
        options.gasPrice = .manual(gasPrice!)
        options.gasLimit = .manual(gasLimit!)
    
        guard let data = Data.myFromHex(transaction.data) else {
            print("invalid message")
            return
        }
        
        let txns = contract.write(
        "fallback",
        parameters: [AnyObject](),
        extraData: data,
        transactionOptions: options)!
        
        do {
            let trans = try txns.send(password: "", transactionOptions: options)
            self.interactor?.approveRequest(id: id, result: trans.hash).cauterize()
            self.showAlert(message: "Transaction sent successfully")
        } catch (let err) {
            self.showAlert(message: err.localizedDescription)
        }
    }
    
    @IBAction func connectTapped() {
        let session = WCSession.from(string: qrCodeString)
        if let i = interactor, i.connected {
            i.killSession().done {  [weak self] in
                self?.approveButton.isEnabled = false
                self?.connectButton.setTitle("Connect", for: .normal)
            }.cauterize()
        } else {
            connect(session: session!)
        }
    }

    @IBAction func approveTapped() {
        guard let chainId = Int("1") else {
            return
        }
        approve(accounts: [defaultAddress], chainId: chainId)
    }
    
    @IBAction func backTapped() {
        let alert = UIAlertController(title: "Do you want to disconnect this session?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            if let i = self.interactor, i.connected {
                i.killSession().done {  [weak self] in
                    self?.approveButton.isEnabled = false
                    self?.connectButton.setTitle("Connect", for: .normal)
                }.cauterize()
            }
            DispatchQueue.main.async {
                APPDELEGATE.homepage()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func disconnectSession() {
        let alert = UIAlertController(title: "You have disconnected the session", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            DispatchQueue.main.async {
                APPDELEGATE.homepage()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
