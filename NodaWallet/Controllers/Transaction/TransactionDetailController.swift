//
//  TransactionDetailController.swift
//  NodaWallet
//
//  Created by macOsx on 02/04/20.
//  .
//

import UIKit
import BigInt
import web3swift

class TransactionDetailController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var senderReceipientLabel: UILabel!
    @IBOutlet weak var senderReceipientAddressLable: UILabel!
    
    @IBOutlet weak var networkFeeLabel: UILabel!
    @IBOutlet weak var networkFeeValueLabel: UILabel!
    
    @IBOutlet weak var transactionTimeLabel: UILabel!
    @IBOutlet weak var transactionTimeValueLabel: UILabel!
    
    @IBOutlet weak var moreDetailsBttn: UIButton!
    
    var withdrawHisData = [String: Any]()
    var currencyList:CurrencyListDatas!
    
    var bnbAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.tableView.theme_backgroundColor = ["#FFF", "#000"]
        self.contentView.theme_backgroundColor = ["#FFF", "#000"]
        
        self.amountLabel.theme_textColor = ["#000", "#FFF"]
        self.senderReceipientLabel.theme_textColor = ["#000", "#FFF"]
        self.networkFeeLabel.theme_textColor = ["#000", "#FFF"]
        self.transactionTimeLabel.theme_textColor = ["#000", "#FFF"]
        
        self.navTitle.text = "transaction_details".localized()
        self.networkFeeLabel.text = "network_fee".localized()
        self.transactionTimeLabel.text = "transaction_time".localized()
        self.moreDetailsBttn.setTitle("more_details".localized(), for: .normal)
       
        DispatchQueue.main.async {
            self.updateDataFromLocalDB()
        }
    }
    
    private func updateDataFromLocalDB() {
        if currencyList.symbol == "BNB" {
            if let fromAddr = withdrawHisData["fromAddr"] as? String {
                let value = withdrawHisData["value"] as? String ?? ""
                let toAddr = withdrawHisData["toAddr"] as? String ?? ""
                if fromAddr == currencyList.address {
                    self.senderReceipientLabel.text = "recipient".localized()
                    self.amountLabel.text = "- " + value + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                    self.senderReceipientAddressLable.text = toAddr
                } else {
                    self.senderReceipientLabel.text = "sender".localized()
                    self.amountLabel.text = "+ " + value + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Green_Color
                    self.senderReceipientAddressLable.text = fromAddr
                }
            }
            if let timeStamp = withdrawHisData["timeStamp"] as? String {
                self.transactionTimeValueLabel.text = self.convertDateFormat(inputDate: timeStamp)
            }
            if let txFee = withdrawHisData["txFee"] as? String {
                self.networkFeeValueLabel.text = txFee + " " + currencyList.symbol
            }
        } else if currencyList.symbol == "BTC" || currencyList.symbol == "LTC" {
            var contentArr = [String: Any]()
            if let responseArr = withdrawHisData["outgoing"] as? [String: Any] {
                contentArr = responseArr
                self.senderReceipientLabel.text = "recipient".localized()
                let price = contentArr["value"] as? String ?? ""
                if let incomingArr = withdrawHisData["incoming"] as? [String: Any] {
                    let incomePrice = incomingArr["value"] as? String ?? ""
                    let priceInDouble = Double(price) ?? 0
                    let incomePriceInDouble = Double(incomePrice) ?? 0
                    let priceToShow = priceInDouble - incomePriceInDouble
                    self.amountLabel.text = "- " + String(format: "%.8f", priceToShow) + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                } else {
                    self.amountLabel.text = "- " + price + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                }
                if let outputs = contentArr["outputs"] as? [[String: Any]] {
                    if let address = outputs[0]["address"] as? String {
                        self.senderReceipientAddressLable.text = address
                    }
                }
            } else {
                contentArr = withdrawHisData["incoming"] as? [String: Any] ?? [:]
                self.senderReceipientLabel.text = "sender".localized()
                let price = contentArr["value"] as? String ?? ""
                self.amountLabel.text = "+ " + price + " " + currencyList.symbol
                self.amountLabel.textColor = Constants.AppColors.Text_Green_Color
                if let inputs = contentArr["inputs"] as? [[String: Any]] {
                    if let address = inputs[0]["address"] as? String {
                        self.senderReceipientAddressLable.text = address
                    }
                }
            }
            if let dateValue = withdrawHisData["time"] as? Double {
                self.transactionTimeValueLabel.text = "\(dateValue)".getDateAndTime()
            }
            if let hash = withdrawHisData["txid"] as? String {
                self.updateBTCandLTCdetails(hash: hash)
            }
        } else if currencyList.symbol == "ETH" {
            if let fromAddr = withdrawHisData["from"] as? String {
                let value = withdrawHisData["value"] as? String ?? ""
                let toAddr = withdrawHisData["to"] as? String ?? ""
                if fromAddr == currencyList.address {
                    self.senderReceipientLabel.text = "recipient".localized()
                    let price: BigUInt = BigUInt(value)!
                    let balanceString1 = Web3.Utils.formatToEthereumUnits(price, toUnits: .eth, decimals: 8)!
                    self.amountLabel.text = "- " + balanceString1 + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                    self.senderReceipientAddressLable.text = toAddr
                } else {
                    self.senderReceipientLabel.text = "sender".localized()
                    let price: BigUInt = BigUInt(value)!
                    let balanceString1 = Web3.Utils.formatToEthereumUnits(price, toUnits: .eth, decimals: 8)!
                    self.amountLabel.text = "+ " + balanceString1 + " " + currencyList.symbol
                    self.amountLabel.textColor = Constants.AppColors.Text_Green_Color
                    self.senderReceipientAddressLable.text = fromAddr
                }
            }
            
            let dateValue = withdrawHisData["timeStamp"] as? String ?? ""
            self.transactionTimeValueLabel.text = dateValue.getDateAndTime()
            
            let gasPrice = withdrawHisData["gasPrice"] as? String ?? ""
            let gasUsed = withdrawHisData["gasUsed"] as? String ?? ""
            self.networkFeeValueLabel.text = self.calculateETHTransactionFees(gasPrice: gasPrice, gasUsed: gasUsed)
        } else if currencyList.isToken != "currency" && currencyList.type == "BEP2" {
            self.updateBepToken()
        } else {
            self.updateTokenDetails()
        }
        
    }
    
    private func updateTokenDetails() {
        if let fromAddr = withdrawHisData["from"] as? String {
            let value = withdrawHisData["value"] as? String ?? ""
            let toAddr = withdrawHisData["to"] as? String ?? ""
            if fromAddr == currencyList.address {
                self.senderReceipientLabel.text = "recipient".localized()
                let priceInDouble = Double(value)!
                var decimalDivVal = "1"
                for _ in 1...currencyList.decimal {
                    decimalDivVal += "0"
                }
                let decimalToDivide = Double(decimalDivVal) ?? 0
                let value = priceInDouble / decimalToDivide
                let balanceString1 = "\(value.avoidNotation)"
                self.amountLabel.text = "- " + balanceString1 + " " + currencyList.symbol
                self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                self.senderReceipientAddressLable.text = toAddr
            } else {
                self.senderReceipientLabel.text = "sender".localized()
                let priceInDouble = Double(value)!
                var decimalDivVal = "1"
                for _ in 1...currencyList.decimal {
                    decimalDivVal += "0"
                }
                let decimalToDivide = Double(decimalDivVal) ?? 0
                let value = priceInDouble / decimalToDivide
                let balanceString1 = "\(value.avoidNotation)"
                self.amountLabel.text = "+ " + balanceString1 + " " + currencyList.symbol
                self.amountLabel.textColor = Constants.AppColors.Text_Green_Color
                self.senderReceipientAddressLable.text = fromAddr
            }
        }
        
        let dateValue = withdrawHisData["timeStamp"] as? String ?? ""
        self.transactionTimeValueLabel.text = dateValue.getDateAndTime()
        
        let gasPrice = withdrawHisData["gasPrice"] as? String ?? ""
        let gasUsed = withdrawHisData["gasUsed"] as? String ?? ""
        self.networkFeeValueLabel.text = self.calculateETHTransactionFees(gasPrice: gasPrice, gasUsed: gasUsed)
    }
    
    private func updateBepToken() {
        if let timeStamp = withdrawHisData["timeStamp"] as? String {
            self.transactionTimeValueLabel.text = self.convertDateFormat(inputDate: timeStamp)
        }
        if let txFee = withdrawHisData["txFee"] as? String {
            self.networkFeeValueLabel.text = txFee + " " + "BNB"
        }
        if let value = withdrawHisData["value"] as? String {
            self.amountLabel.text = value + " " + currencyList.symbol
        }
        if let data = withdrawHisData["data"] as? String {
            self.senderReceipientLabel.text = withdrawHisData["txType"] as? String ?? ""
            self.senderReceipientAddressLable.text = withdrawHisData["orderId"] as? String ?? ""
        } else {
            if let fromAddr = withdrawHisData["fromAddr"] as? String {
                if fromAddr == self.bnbAddress {
                    self.senderReceipientLabel.text = "recipient".localized()
                    self.amountLabel.textColor = Constants.AppColors.Text_Red_Color
                } else {
                    self.senderReceipientLabel.text = "sender".localized()
                    self.amountLabel.textColor = Constants.AppColors.Text_Green_Color
                }
            }
        }
    }
    
    private func calculateETHTransactionFees(gasPrice: String, gasUsed: String) -> String {
        let gasPriceInDouble = Double(gasPrice) ?? 0
        let gasUsedInDouble = Double(gasUsed) ?? 0
        let multiplyGasValue = gasPriceInDouble * gasUsedInDouble
        let getTransFee = multiplyGasValue / 1000000000000000000
        return "\(getTransFee) ETH"
    }
    
    @IBAction func explorerLinkAction(_ sender: Any) {
        switch currencyList.symbol {
        case "BNB":
            if let hash = withdrawHisData["txHash"] as? String {
                self.showExplorerLink(urlString: Constants.urlConfig.BNB_EXPLORER_API + hash)
            }
            break
        case "BTC":
            if let hash = withdrawHisData["txid"] as? String {
                self.showExplorerLink(urlString: Constants.urlConfig.BTC_EXPLORER_API + hash)
            }
            break
        case "LTC":
            if let hash = withdrawHisData["txid"] as? String {
                self.showExplorerLink(urlString: Constants.urlConfig.LTC_EXPLORER_API + hash)
            }
            break
        case "ETH":
            if let hash = withdrawHisData["hash"] as? String {
               self.showExplorerLink(urlString: Constants.urlConfig.ETH_EXPLORER_API + hash)
            }
            break
        default:
            if let hash = withdrawHisData["hash"] as? String {
               self.showExplorerLink(urlString: Constants.urlConfig.ETH_EXPLORER_API + hash)
            } else {
                if let hash = withdrawHisData["txHash"] as? String {
                    self.showExplorerLink(urlString: Constants.urlConfig.BNB_EXPLORER_API + hash)
                }
            }
            break
        }
           
    }
    
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

         let oldDate = olDateFormatter.date(from: inputDate)
          
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"

         return convertDateFormatter.string(from: oldDate!)
    }
    
    private func showExplorerLink(urlString: String) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonWebControllerID") as? CommonWebController {
            vc.webUrl = urlString
            vc.isExplorer = true
            self.present(vc, animated: true, completion: nil)
        }
    }

}

extension TransactionDetailController {
    private func updateBTCandLTCdetails(hash: String) {
        if currencyList.symbol == "BTC" {
            BTCDataManager.getBtcTxDetails(hash: hash) { (success, fee, data, error) in
                self.networkFeeValueLabel.text = fee + " BTC"
            }
        } else {
            LTCDataManager.getLtcTxDetails(hash: hash) { (success, fee, data, error) in
                self.networkFeeValueLabel.text = fee + " LTC"
            }
        }
    }
    
}
