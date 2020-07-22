//
//  TokenController.swift
//  NodaWallet
//

import UIKit
import XLPagerTabStrip
import web3swift
import BigInt
import WebKit
import RealmSwift
import SDWebImage
import Alamofire

class TokenController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Token"
    
    @IBOutlet weak var tokenListTableView: UITableView!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var mainWalletView: UIView!
    @IBOutlet weak var showListView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var mainWalletLabel: UILabel!
    
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    
    var currencyList = [CurrencyListDatas]()
    var mainBalance = 0.0
    var balanceArr = [String]()
    var balanceIndex = 0
    
    var stopUpdating = false
    
    var ethCoinBalance = ""
    var tokenCurrencyListArr = [[String: Any]]()
    var marketPriceInOrderArr = [[String: Any]]()
    
    var bnbCoinListArr = [[String: Any]]()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainWalletLabel.text = "main_wallet".localized()
        self.searchTF.placeholder = "Search".localized()
        self.searchTF.delegate = self
        self.cancelButtonWidth.constant = 0
        self.view.backgroundColor = .clear
        self.tokenListTableView.register(UINib(nibName: "TokenListTableCell", bundle:nil), forCellReuseIdentifier: "TokenTableCellID")
        self.tokenListTableView.tableFooterView = UIView()
        self.updateAppColor()
    }
       
    private func updateAppColor() {
        self.balanceLabel.theme_textColor = ["#000", "#FFF"]
        self.mainWalletLabel.theme_textColor = ["#555555", "#FFF"]
        self.mainWalletView.theme_backgroundColor = ["#EBE9E8", "#373431"]
        self.slideView.theme_backgroundColor = ["#EBE9E8", "#373431"]
       // self.showListView.theme_backgroundColor = ["#F5F5F5", "#302A21"]
        self.showListView.theme_backgroundColor = ["#FFF", "#000"]
        self.searchView.theme_backgroundColor = ["#EBE9E8", "#373431"]
        self.mainWalletLabel.theme_backgroundColor = ["#F5F5F5", "#302A21"]
        self.tokenView.layer.theme_shadowColor = ["#9A9A9A", "#434343"]
        self.searchImageView.theme_image = ["Search_Dark", "Search_Light"]
        self.searchTF.theme_textColor = ["#000", "#FFF"]
        
        if Constants.User.isDarkMode {
            self.searchTF.placeHolderColor = .white
            self.tokenView.layer.shadowColor = UIColor.darkGray.cgColor
        } else {
            self.searchTF.placeHolderColor = .darkGray
            self.tokenView.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currencyList.removeAll()
        self.balanceArr.removeAll()
        self.balanceIndex = 0
        
        self.searchTF.text = ""
        Constants.staticView.tokenSlideView = slideView
        //slideView.isHidden = false
        
        let index = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.selectedWalletID) - 1
        let walletData = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[index]
        SelectedWalletDetails.walletID = walletData.walletID
        SelectedWalletDetails.mnemonicData = walletData.mnemonicPhraseDatas
        SelectedWalletDetails.walletAddress = walletData.address
        SelectedWalletDetails.privateKey = walletData.privateKey
        SelectedWalletDetails.importedBy = walletData.importedBy
        
        self.stopUpdating = false
        
        self.loadCurrencyListDatas(isUpdateBalance: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopUpdating = true
    }
    
    private func loadCurrencyListDatas(isUpdateBalance: Bool) {
        self.currencyList.removeAll()
        self.balanceArr.removeAll()
        self.balanceIndex = 0
        self.tokenCurrencyListArr.removeAll()
        self.marketPriceInOrderArr.removeAll()
        
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.enable == true {
                    currencyList.append(data)
                }
            }
        }
        
        self.mainBalance = 0.0
        for balanceVal in currencyList {
            let balance = balanceVal.balance
            let balanceInDouble = Double(balance) ?? 0.0
            let marketPriceInDouble = Double(balanceVal.marketPrice) ?? 0.0
            let priceVal = balanceInDouble * marketPriceInDouble
            self.mainBalance += priceVal
        }
        let mainBalancePrice = String(format: "%.2f", self.mainBalance)
        self.balanceLabel.text = mainBalancePrice + " \(userSelectedCurrencySymbol)"
        
        self.tokenListTableView.reloadData()
        
        if isUpdateBalance {
            self.getBalanceAndUpdateToDB()
        }
        
    }
        
    private func getBalanceAndUpdateToDB() {
        //GET BALANCE FOR ETH and ERC20
        let ethBalanceURL = Constants.urlConfig.GET_ETH_ERC20_BALANCE_API + SelectedWalletDetails.walletAddress + "?apiKey=freekey"
        DataManager.getETHanderc20Balance(urlString: ethBalanceURL) { (success, balance, tokenListArr, data, error) in
            if success {
                let ethBalanceInDouble = Double(balance) ?? 0
                self.ethCoinBalance = String(format: "%.8f", ethBalanceInDouble)
                self.tokenCurrencyListArr = tokenListArr
                self.getBNBBalanceAPI()
            }
        }
    }
    
    private func getBNBBalanceAPI() {
        var address = ""
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.symbol == "BNB" && data.isToken == "currency" {
                    address = data.address
                }
            }
        }
        BNBDataManager.getBNBBalanceRequest(address: address) { (success, responseArr, data, error) in
            if success {
                self.bnbCoinListArr = responseArr
                self.getAllCoinBalance()
            } else {
                self.getAllCoinBalance()
            }
        }
    }
    
    private func getAllCoinBalance() {
        if stopUpdating || currencyList.count == 0 {
            return
        }
        
        let currencyData = currencyList[balanceIndex]
        
        if currencyData.symbol == "ETH" && currencyData.isToken == "currency" {
            self.balanceArr.append(ethCoinBalance)
            self.checkBalanceToUpdateMarketPrice()
            return
        }
        
        if currencyData.isToken != "currency" && currencyData.type != "BEP2" {
            if self.tokenCurrencyListArr.count == 0 {
                self.balanceArr.append("0.00000000")
                self.checkBalanceToUpdateMarketPrice()
                return
            }
            var isBalanceAvailable = false
            for tokenListArr in self.tokenCurrencyListArr {
                if let tokenList = tokenListArr["tokenInfo"] as? [String: Any] {
                    if let address = tokenList["address"] as? String {
                        if address == currencyData.address {
                            let erc20Balance = tokenListArr["balance"] as? Double ?? 0
                            isBalanceAvailable = true
                            let convertBalance = self.convertedUsingDecimal(priceInDouble: erc20Balance, decimal: currencyData.decimal)
                            let balanceToAppendInDouble = Double(convertBalance) ?? 0
                            let balanceToAppend = String(format: "%.8f", balanceToAppendInDouble)
                            self.balanceArr.append(balanceToAppend)
                        }
                    }
                }
            }
            if !isBalanceAvailable {
                self.balanceArr.append("0.00000000")
            }
            self.checkBalanceToUpdateMarketPrice()
            return
        }
         
        var urlString = Constants.urlConfig.GET_BTC_HISTORY_API + currencyData.address
    
        if currencyData.currencyName == "Litecoin" && currencyData.isToken == "currency" {
            urlString = Constants.urlConfig.GET_LTC_HISTORY_API + currencyData.address
        }
        
        if currencyData.currencyName == "Binance" || currencyData.type == "BEP2" {
            var isBalanceAvailable = false
            for getBalanceArr in self.bnbCoinListArr {
                let symbol = getBalanceArr["symbol"] as? String ?? ""
                let balanceFree = getBalanceArr["free"] as? String ?? ""
                if symbol == currencyData.symbol {
                    isBalanceAvailable = true
                    self.balanceArr.append(balanceFree)
                }
            }
            if !isBalanceAvailable {
                self.balanceArr.append("0.00000000")
            }
            self.checkBalanceToUpdateMarketPrice()
            return
        }
        self.getBTCandLTCBalanceAPI(urlString: urlString)
    }
    
    private func getBTCandLTCBalanceAPI(urlString: String) {
        //USING SAME API FOR BOTH HISTORY AND BALANCE BTC and LTC
        WithdrawHistoryManager.getWithdrawHistory(urlString: urlString, showLoader: false) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let jsonData = json["data"] as? [String: AnyObject] {
                    if let balance = jsonData["balance"] as? String {
                        self.balanceArr.append(balance)
                        self.checkBalanceToUpdateMarketPrice()
                    }
                }
            } else {
                self.balanceArr.append("0.00000000")
                self.checkBalanceToUpdateMarketPrice()
            }
        }
    }
    
    private func checkBalanceToUpdateMarketPrice() {
        self.balanceIndex += 1
        if self.balanceArr.count == self.currencyList.count {
            self.getAndUpdateMarketPriceToDB()
        } else {
            self.getAllCoinBalance()
        }
    }
    
    private func getAndUpdateMarketPriceToDB() {
        if stopUpdating {
            return
        }
        var gekkoIdArr = [String]()
        for getGeckoID in currencyList {
            gekkoIdArr.append(getGeckoID.geckoID)
        }
        let geckoID = gekkoIdArr.joined(separator: ",")
        DataManager.getMarketCap(currency: userSelectedCurrency, ids: geckoID) { (success, responseArr, data, error) in
            if success {
                for currencyData in self.currencyList {
                    for marketPriceFromAPI in responseArr {
                        let id = marketPriceFromAPI["id"] as? String ?? ""
                        if id == currencyData.geckoID {
                            self.marketPriceInOrderArr.append(marketPriceFromAPI)
                        }
                    }
                }
                self.updateDummyArrForCustomToken()
            }
        }
    }
    
    private func updateDummyArrForCustomToken() {
        if self.balanceArr.count == self.marketPriceInOrderArr.count {
            self.updateToLocalDBandLoadView()
        } else {
            self.marketPriceInOrderArr.append(["": ""])
            self.updateDummyArrForCustomToken()
        }
    }
    
    private func updateToLocalDBandLoadView() {
        let obj = CurrencyListDatas()
        for (index, marketPriceArr) in self.marketPriceInOrderArr.enumerated() {
            let marketPrice = marketPriceArr["current_price"] as? Double ?? 0.0
            let volumePercent = marketPriceArr["price_change_percentage_24h"] as? Double ?? 0.0
            let balanceToUpdate = self.balanceArr[index]
            let currentDataFromList = self.currencyList[index]
            LocalDBManager.sharedInstance.updateMarketPriceAndBalance(object: obj, currencyID: currentDataFromList.currencyID, marketPrice: "\(marketPrice)", volumeChangePercent: "\(volumePercent)", balance: balanceToUpdate)
        }
        self.loadCurrencyListDatas(isUpdateBalance: false)
    }
    
    @IBAction func showScannerAction(_ sender: Any) {
        if let tabbarVc = self.tabBarController as? LandingTabbarController {
            tabbarVc.selectedIndex = 1
        }
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        self.pushViewController(identifier: "TokenListController", storyBoardName: "Main")
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        tokenListTableView.reloadData()
        cancelButtonWidth.constant = 0
    }
    
}

extension TokenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TokenTableCellID", for: indexPath) as? TokenListTableCell {
           // cell.contentView.theme_backgroundColor = ["#F5F5F5", "#302A21"]
            cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
            cell.currencyNameLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyPriceLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyValueLabel.theme_textColor = ["#000", "#FFF"]
            cell.balanceIntoMPLabel.theme_textColor = ["#000", "#FFF"]
            cell.tokenListState.isHidden = true
            let content = currencyList[indexPath.row] as CurrencyListDatas
            cell.currencyNameLabel.text = content.currencyName
            cell.currencyImageView.loadImage(string: content.currencyImage)
            cell.currencyValueLabel.text = content.balance + " " + content.symbol
            let marketVal = Double(content.marketPrice) ?? 0.0
            let marketPrice = String(format: "%.2f", marketVal) + " \(userSelectedCurrencySymbol)"
            cell.currencyPriceLabel.text = marketPrice
            let marketPercentInDouble = Double(content.marketPercent) ?? 0.0
            cell.currencyPercentLabel.text = String(format: "%.2f", marketPercentInDouble) + " %"
            if content.marketPercent.contains("-") {
                cell.currencyPercentLabel.textColor = UIColor.init(hexString: "FF3B30")
            } else {
                cell.currencyPercentLabel.textColor = UIColor.init(hexString: "34C759")
            }
            if content.isToken == "usertoken" {
                cell.currencyPercentLabel.isHidden = true
                cell.currencyPriceLabel.isHidden = true
            } else {
                cell.currencyPercentLabel.isHidden = false
                cell.currencyPriceLabel.isHidden = false
            }
            let balanceInDouble = Double(content.balance) ?? 0.0
            let balanceIntoMP = marketVal * balanceInDouble
            cell.balanceIntoMPLabel.text = String(format: "%.4f", balanceIntoMP) + " \(userSelectedCurrencySymbol)"
            
            cell.currencyNameLabel.adjustsFontSizeToFitWidth = true
            cell.currencyValueLabel.adjustsFontSizeToFitWidth = true
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GraphViewControllerID") as? GraphViewController {
            vc.currencyList = currencyList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension TokenController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Tokens".localized())
    }
}

extension TokenController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

extension TokenController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        currencyList.removeAll()
        for data in currencyData {
            if data.currencyName.lowercased().contains(string) {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.enable == true {
                        self.stopUpdating = true
                        currencyList.append(data)
                    }
                }
            }
        }
        self.tokenListTableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if textField.text?.count == 0 {
                self.loadCurrencyListDatas(isUpdateBalance: false)
            } else {
                let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
                currencyList.removeAll()
                for data in currencyData {
                    if data.currencyName.lowercased().contains(textField.text ?? "") {
                        if data.walletID == SelectedWalletDetails.walletID {
                            if data.enable == true {
                                self.stopUpdating = true
                                currencyList.append(data)
                            }
                        }
                    }
                }
                self.tokenListTableView.reloadData()
            }
        }
    }
    
}

extension Double {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
    
}
