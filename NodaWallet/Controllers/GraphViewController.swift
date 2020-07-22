//
//  GraphViewController.swift
//  NodaWallet

import UIKit
import web3swift
import BigInt
import RealmSwift
import Charts

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class GraphViewController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var smartContractAddressTablevView: UITableView!
    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var submitImageView: UIImageView!
    
    @IBOutlet weak var copyImageView: UIImageView!
    
    @IBOutlet weak var smartContarctAddressTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var currencyBalanceLabel: UILabel!
    @IBOutlet weak var currencyDollarLabel: UILabel!
    @IBOutlet weak var currencyPercentageLabel: UILabel!
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var transactionHisTitleLbl: UILabel!
    
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var twentyFourBttn: UIButton!
    @IBOutlet weak var weekBttn: UIButton!
    @IBOutlet weak var monthBttn: UIButton!
    @IBOutlet weak var yearBttn: UIButton!
    
    @IBOutlet weak var chartMarketPriceLabel: UILabel!
    
    @IBOutlet weak var navTitle: UILabel!
    
    var currencyList:CurrencyListDatas!
    var transactionListArr = [[String: Any]]()
    var marketPriceArr = [Double]()
    
    var currencyNameInGraphAPI = "ethereum"
    
    var realm = try! Realm()
    var bnbAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.twentyFourBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: 0.5)
        self.weekBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: 0.5)
        self.monthBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: 1.0)
        self.yearBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: 0.5)
        
        self.navTitle.text = currencyList.symbol
        smartContractAddressTablevView.delegate = self
        smartContractAddressTablevView.dataSource = self
        smartContractAddressTablevView.register(UINib(nibName: "SmartContractAddressCell", bundle: nil), forCellReuseIdentifier: "SmartContractAddressCell")
        self.smartContractAddressTablevView.register( UINib(nibName: "SmartContractsDateCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SmartContractsDateCell")
        self.updateAppColor()
    }
    
    private func updateAppColor() {
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.contentView.theme_backgroundColor = ["#FFF", "#000"]
        self.currencyView.theme_backgroundColor = ["#FFF", "#000"]
        self.smartContractAddressTablevView.theme_backgroundColor = ["#FFF", "#000"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.currencyBalanceLabel.theme_textColor = ["#000", "#FFF"]
        self.currencyDollarLabel.theme_textColor = ["#000", "#FFF"]
        self.chartMarketPriceLabel.theme_textColor = ["#000", "#FFF"]
       // self.currencyPercentageLabel.theme_textColor = ["#000", "#FFF"]
        
        self.sendLabel.theme_textColor = ["#000", "#FFF"]
        self.receiveLabel.theme_textColor = ["#000", "#FFF"]
        self.copyLabel.theme_textColor = ["#000", "#FFF"]
        
        self.sendLabel.text = "send".localized()
        self.receiveLabel.text = "Receive".localized()
        self.copyLabel.text = "Copy".localized()
        self.transactionHisTitleLbl.text = "Transaction_History".localized()
        
        self.coinImageView.loadImage(string: currencyList.currencyImage)
        
        self.currencyDollarLabel.text = "\(currencyList.balance)" + " \(currencyList.symbol)"
        
        let marketVal = Double(currencyList.marketPrice) ?? 0.0
        let marketPrice = String(format: "%.2f", marketVal) + " \(userSelectedCurrencySymbol)"
        self.currencyBalanceLabel.text = marketPrice
        self.chartMarketPriceLabel.text = marketPrice
        
        if currencyList.marketPercent.contains("-") {
            self.currencyPercentageLabel.textColor = UIColor.init(hexString: "FF3B30")
        } else {
            self.currencyPercentageLabel.textColor = UIColor.init(hexString: "34C759")
        }
        self.currencyPercentageLabel.text = currencyList.marketPercent + " %"
        
        if currencyList.isToken == "usertoken" {
            self.currencyBalanceLabel.text = ""
            self.currencyPercentageLabel.text = ""
        }
        let todayDate = NSDate().timeIntervalSince1970
        let fromSepArr = String(todayDate)
        let fromSeperator = fromSepArr.components(separatedBy: ".")
        let fromTimestamp = fromSeperator[0]
        
        let monthChartData = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.timeIntervalSince1970
        let toSepArr = String(monthChartData ?? 0.0)
        let toSeperator = toSepArr.components(separatedBy: ".")
        let toTimestamp = toSeperator[0]
        
        if currencyList.isToken == "usertoken" {
            DataManager.getAllGeckoIDRequest { (success, response, data, error) in
                if success {
                    for geckoData in response {
                        let symbol = geckoData["symbol"] as? String ?? ""
                        if self.currencyList.symbol.lowercased() == symbol {
                            self.currencyNameInGraphAPI = geckoData["id"] as? String ?? ""
                            self.getGraphData(currency: self.currencyNameInGraphAPI, from: toTimestamp, to: fromTimestamp, isHitHistory: true)
                            return
                        }
                    }
                }
            }
        } else {
            currencyNameInGraphAPI = currencyList.geckoID
            self.getGraphData(currency: currencyNameInGraphAPI, from: toTimestamp, to: fromTimestamp, isHitHistory: true)
        }
    }
    
    private func getGraphData(currency: String, from: String, to: String, isHitHistory: Bool) {
        self.marketPriceArr.removeAll()
        DataManager.getGraphDetails(currency: currency, from: from, to: to) { (success, msg, data, error) in
            if success {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        return
                    }
                    if let responseArr = jsonArray["prices"] as? NSArray {
                        for priceArr in responseArr {
                            let priceInStr = "\(priceArr)"
                            let seperatePriceArr = priceInStr.components(separatedBy: ",")
                            let firstVal = seperatePriceArr[1].replacingOccurrences(of: ")", with: "")
                            let removeVal = firstVal.replacingOccurrences(of: "\n", with: "")
                            let removeSlash = String(removeVal.filter { !" \n\t\r".contains($0) })
                            let againRemove = removeSlash.replacingOccurrences(of: "\"", with: "")
                            let marketPriceInDouble = Double(againRemove) ?? 0.0
                            self.marketPriceArr.append(marketPriceInDouble)
                        }
                        self.updateGraphViewData(isHitHistory: isHitHistory)
                    }
                } catch(let error) {
                    print(error)
                }
            }
        }
        
    }
    
    private func updateGraphViewData(isHitHistory: Bool) {
        graphView.delegate = self

        graphView.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
        if Constants.User.isDarkMode {
            graphView.backgroundColor = .black
        } else {
            graphView.backgroundColor = .white
        }
        
        graphView.dragEnabled = true
        graphView.setScaleEnabled(true)
        graphView.pinchZoomEnabled = false
        graphView.maxHighlightDistance = 300
           
        graphView.xAxis.enabled = false
           
        let yAxis = graphView.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelPosition = .insideChart
        
        if Constants.User.isDarkMode {
            yAxis.labelTextColor = .white
        } else {
            yAxis.labelTextColor = .black
        }
        
        yAxis.axisLineColor = .lightGray
           
        graphView.rightAxis.enabled = false
        graphView.legend.enabled = false
           
        self.setDataCount(Int(marketPriceArr.count), range: UInt32(100))
        
        graphView.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        if isHitHistory {
            self.loadTransactionHistory()
        }
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = marketPriceArr[i]
            //let val = Double(arc4random_uniform(mult) + 20)
            return ChartDataEntry(x: Double(i), y: mult)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 0.5
        set1.circleRadius = 4
        
        if Constants.User.isDarkMode {
            set1.setColor(.white)
        } else {
            set1.setColor(.black)
        }
        
        set1.setCircleColor(.white)
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        
        let gradientColors = [ChartColorTemplates.colorFromString("#F69F36").cgColor,
                              ChartColorTemplates.colorFromString("#FFFFFF").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
        data.setDrawValues(false)
        
        graphView.data = data
    }
    
    private func loadTransactionHistory() {
        var urlString = ""
        let todayDate = NSDate().timeIntervalSince1970
        let fromSepArr = String(todayDate)
        let fromSeperator = fromSepArr.components(separatedBy: ".")
        let fromTimestamp = fromSeperator[0] + "000"
        if currencyList.symbol == "ETH" && currencyList.isToken == "currency" {
            urlString = Constants.urlConfig.GET_ETH_HISTORY_API + "module=account&action=txlist&address=\(currencyList.address)&startblock=0&endblock=99999999&page=1&offset=60&sort=desc&apikey=" + api_Key
        } else if currencyList.symbol == "BTC" && currencyList.isToken == "currency" {
            urlString = Constants.urlConfig.GET_BTC_HISTORY_API + currencyList.address
        } else if currencyList.symbol == "LTC" && currencyList.isToken == "currency" {
            urlString = Constants.urlConfig.GET_LTC_HISTORY_API + currencyList.address
        } else if currencyList.symbol == "BNB" && currencyList.isToken == "currency" {
            urlString = Constants.urlConfig.GET_BNB_HISTORY_API + currencyList.address + "&endTime=\(fromTimestamp)&txType=TRANSFER"
        } else if currencyList.isToken != "currency" && currencyList.type == "BEP2" {
            var address = ""
            let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
            for data in currencyData {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol == "BNB" && data.isToken == "currency" {
                        address = data.address
                    }
                }
            }
            self.bnbAddress = address
            urlString = Constants.urlConfig.GET_BNB_HISTORY_API + address + "&endTime=\(fromTimestamp)"
        } else {
            urlString = Constants.urlConfig.GET_ERC20_HISTORY_API + "module=account&action=tokentx&contractaddress=\(currencyList.address)&address=\(SelectedWalletDetails.walletAddress)&page=1&offset=100&sort=desc&apikey=" + api_Key
        }
       
        WithdrawHistoryManager.getWithdrawHistory(urlString: urlString, showLoader: true) { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if self.currencyList.symbol == "BNB" && self.currencyList.isToken != "usertoken" {
                    if let listArr = json["tx"] as? [[String: AnyObject]] {
                        self.transactionListArr = listArr
                    }
                } else if self.currencyList.symbol == "BTC" || self.currencyList.symbol == "LTC" && self.currencyList.isToken != "usertoken" {
                    if let jsonData = json["data"] as? [String: AnyObject] {
                        if let listArr = jsonData["txs"] as? [[String: AnyObject]] {
                            self.transactionListArr = listArr
                        }
                    }
                } else if self.currencyList.isToken != "currency" && self.currencyList.type == "BEP2" {
                    //Process BEP Token
                    if let listArr = json["tx"] as? [[String: AnyObject]] {
                        for transactionList in listArr {
                            if let data = transactionList["data"] as? String {
                                let myData = data.data(using: .utf8)!
                                do {
                                    if let jsonResponse = try JSONSerialization.jsonObject(with: myData, options : .allowFragments) as? [String: Any] {
                                        if let orderData = jsonResponse["orderData"] as? [String: Any] {
                                            if let symbol = orderData["symbol"] as? String {
                                                if symbol.contains(self.currencyList.symbol) {
                                                    self.transactionListArr.append(transactionList)
                                                }
                                            }
                                        }
                                    }
                                } catch let error as NSError {
                                    print(error)
                                }
                            } else {
                                self.transactionListArr.append(transactionList)
                            }
                        }
                    }
                } else {
                    if let listArr = json["result"] as? [[String: AnyObject]] {
                        self.transactionListArr = listArr
                    }
                }
                if self.transactionListArr.count == 0 {
                    self.smartContractAddressTablevView.setEmptyMessage("no_transaction_found".localized())
                }
                DispatchQueue.main.async {
                    self.smartContractAddressTablevView.reloadData()
                }
            }
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendCurrencyControllerID") as? SendCurrencyController {
            vc.currencyList = currencyList
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveCurrencyControllerID") as? ReceiveCurrencyController {
            vc.currencyList = currencyList
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = currencyList.address
        self.popUpView(message: "copied_to_clipboard".localized())
    }
    
    @IBAction func twentyFourAction(_ sender: Any) {
        let todayDate = NSDate().timeIntervalSince1970
        let monthChartData = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.timeIntervalSince1970
        let sepArr = String(monthChartData ?? 0.0)
        let seperator = sepArr.components(separatedBy: ".")
        let timestamp = seperator[0]
        self.getGraphData(currency: currencyNameInGraphAPI, from: timestamp, to: "\(todayDate)", isHitHistory: false)
        self.updateButtonColor(todayAlpha: 1.0, weekAlpha: 0.5, monthAlpha: 0.5, yearAlpha: 0.5)
    }
    
    @IBAction func weekAction(_ sender: Any) {
        let todayDate = NSDate().timeIntervalSince1970
        let monthChartData = Calendar.current.date(byAdding: .day, value: -7, to: Date())?.timeIntervalSince1970
        let sepArr = String(monthChartData ?? 0.0)
        let seperator = sepArr.components(separatedBy: ".")
        let timestamp = seperator[0]
        self.getGraphData(currency: currencyNameInGraphAPI, from: timestamp, to: "\(todayDate)", isHitHistory: false)
        self.updateButtonColor(todayAlpha: 0.5, weekAlpha: 1.0, monthAlpha: 0.5, yearAlpha: 0.5)
    }
    
    @IBAction func monthAction(_ sender: Any) {
        let todayDate = NSDate().timeIntervalSince1970
        let fromSepArr = String(todayDate)
        let fromSeperator = fromSepArr.components(separatedBy: ".")
        let fromTimestamp = fromSeperator[0]
        
        let monthChartData = Calendar.current.date(byAdding: .day, value: -30, to: Date())?.timeIntervalSince1970
        let toSepArr = String(monthChartData ?? 0.0)
        let toSeperator = toSepArr.components(separatedBy: ".")
        let toTimestamp = toSeperator[0]
        
        self.getGraphData(currency: currencyNameInGraphAPI, from: toTimestamp, to: fromTimestamp, isHitHistory: false)
        self.updateButtonColor(todayAlpha: 0.5, weekAlpha: 0.5, monthAlpha: 1.0, yearAlpha: 0.5)
    }
    
    @IBAction func yearAction(_ sender: Any) {
        let todayDate = NSDate().timeIntervalSince1970
        let fromSepArr = String(todayDate)
        let fromSeperator = fromSepArr.components(separatedBy: ".")
        let fromTimestamp = fromSeperator[0]
        
        let monthChartData = Calendar.current.date(byAdding: .day, value: -365, to: Date())?.timeIntervalSince1970
        let toSepArr = String(monthChartData ?? 0.0)
        let toSeperator = toSepArr.components(separatedBy: ".")
        let toTimestamp = toSeperator[0]
        
        self.getGraphData(currency: currencyNameInGraphAPI, from: toTimestamp, to: fromTimestamp, isHitHistory: false)
        self.updateButtonColor(todayAlpha: 0.5, weekAlpha: 0.5, monthAlpha: 0.5, yearAlpha: 1.0)
    }
    
    private func updateButtonColor(todayAlpha: CGFloat, weekAlpha: CGFloat, monthAlpha: CGFloat, yearAlpha: CGFloat) {
        self.twentyFourBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: todayAlpha)
        self.weekBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: weekAlpha)
        self.monthBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: monthAlpha)
        self.yearBttn.backgroundColor = UIColor(red: 246/255, green: 159/255, blue: 54/255, alpha: yearAlpha)
    }
    
}

extension GraphViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let filterHisCount = realm.objects(WithdrawHistoryDatas.self).filter("sendAddress = %@", currencyList.address)
        return transactionListArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmartContractAddressCell", for: indexPath) as! SmartContractAddressCell
        self.smartContarctAddressTableViewHeight.constant = self.smartContractAddressTablevView.contentSize.height + 10
        cell.contentView.theme_backgroundColor = ["#F0F0F0", "#0F0F0F"]
        cell.smartContarctTitleLabel.theme_textColor = ["#000", "#FFF"]
        
        let contentData = transactionListArr[indexPath.row]
        
        if currencyList.symbol == "BNB" {
            if let txHash = contentData["txHash"] as? String {
                cell.smartContractAddressLabel.text = txHash
            }
            if let fromAddr = contentData["fromAddr"] as? String {
                if fromAddr == currencyList.address {
                    cell.smartContarctTitleLabel.text = "Sent"
                    if let value = contentData["value"] as? String {
                        cell.coinValueLabel.text = value + " " + currencyList.symbol
                        cell.coinValueLabel.textColor = Constants.AppColors.Text_Red_Color
                    }
                } else {
                    cell.smartContarctTitleLabel.text = "Received"
                    if let value = contentData["value"] as? String {
                        cell.coinValueLabel.text = value + " " + currencyList.symbol
                        cell.coinValueLabel.textColor = Constants.AppColors.Text_Green_Color
                    }
                }
            }
        } else if currencyList.symbol == "BTC" || currencyList.symbol == "LTC" {
            var contentArr = [String: Any]()
            if let responseArr = contentData["outgoing"] as? [String: Any] {
                contentArr = responseArr
                cell.smartContarctTitleLabel.text = "Sent"
                let price = contentArr["value"] as? String ?? ""
                if let incomingArr = contentData["incoming"] as? [String: Any] {
                    let incomePrice = incomingArr["value"] as? String ?? ""
                    let priceInDouble = Double(price) ?? 0
                    let incomePriceInDouble = Double(incomePrice) ?? 0
                    let priceToShow = priceInDouble - incomePriceInDouble
                    cell.coinValueLabel.text = String(format: "%.8f", priceToShow) + " " + currencyList.symbol
                    cell.coinValueLabel.textColor = Constants.AppColors.Text_Red_Color
                } else {
                    cell.coinValueLabel.textColor = Constants.AppColors.Text_Red_Color
                    cell.coinValueLabel.text = price + " " + currencyList.symbol
                }
            } else {
                contentArr = contentData["incoming"] as? [String: Any] ?? [:]
                cell.smartContarctTitleLabel.text = "Received"
                let price = contentArr["value"] as? String ?? ""
                cell.coinValueLabel.text = price + " " + currencyList.symbol
                cell.coinValueLabel.textColor = Constants.AppColors.Text_Green_Color
            }
            cell.smartContractAddressLabel.text = contentData["txid"] as? String ?? ""
        } else if self.currencyList.isToken != "currency" && self.currencyList.type == "BEP2" {
            if let txHash = contentData["txHash"] as? String {
                cell.smartContractAddressLabel.text = txHash
            }
            if let data = contentData["data"] as? String {
                cell.smartContarctTitleLabel.text = contentData["txType"] as? String ?? ""
            } else {
                if let fromAddr = contentData["fromAddr"] as? String {
                    if fromAddr == self.bnbAddress {
                        cell.smartContarctTitleLabel.text = "Sent"
                        if let value = contentData["value"] as? String {
                            cell.coinValueLabel.text = value + " " + currencyList.symbol
                            cell.coinValueLabel.textColor = Constants.AppColors.Text_Red_Color
                        }
                    } else {
                        cell.smartContarctTitleLabel.text = "Received"
                        if let value = contentData["value"] as? String {
                            cell.coinValueLabel.text = value + " " + currencyList.symbol
                            cell.coinValueLabel.textColor = Constants.AppColors.Text_Green_Color
                        }
                    }
                }
            }
        } else {
            let amount = contentData["value"] as? String ?? ""
            let price: BigUInt = BigUInt(amount)!
            var balanceString1 = ""
            if currencyList.symbol == "ETH" {
                balanceString1 = Web3.Utils.formatToEthereumUnits(price, toUnits: .eth, decimals: 8)!
            } else {
                let priceInDouble = Double(amount)!
                var decimalDivVal = "1"
                for _ in 1...currencyList.decimal {
                    decimalDivVal += "0"
                }
                let decimalToDivide = Double(decimalDivVal) ?? 0
                let value = priceInDouble / decimalToDivide
                balanceString1 = "\(value.avoidNotation)"
            }
            cell.coinValueLabel.text = balanceString1 + " " + currencyList.symbol
            let inputValue = contentData["input"] as? String ?? ""
            let errorValue = contentData["isError"] as? String ?? ""
            let fromAddress = contentData["from"] as? String ?? ""
            
            let fromAddressCapitalized = fromAddress.capitalized
            var selectedAddressCapitalized = ""
            if currencyList.symbol == "ETH" {
                selectedAddressCapitalized = currencyList.address.capitalized
            } else {
                selectedAddressCapitalized = SelectedWalletDetails.walletAddress.capitalized
            }
            let hash = contentData["hash"] as? String ?? ""
            cell.smartContractAddressLabel.text = hash
            if errorValue == "1" {
                cell.smartContarctTitleLabel.text = "Error"
            } else if inputValue != "0x" {
                cell.smartContarctTitleLabel.text = "Smart Contract Call"
            } else if fromAddressCapitalized == selectedAddressCapitalized {
                cell.smartContarctTitleLabel.text = "Sent"
                cell.coinValueLabel.textColor = Constants.AppColors.Text_Red_Color
            } else {
                cell.smartContarctTitleLabel.text = "Received"
                cell.coinValueLabel.textColor = Constants.AppColors.Text_Green_Color
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentData = transactionListArr[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailControllerID") as? TransactionDetailController {
            vc.withdrawHisData = contentData
            vc.currencyList = self.currencyList
            vc.bnbAddress = bnbAddress
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension GraphViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.chartMarketPriceLabel.text = String(format: "%.2f", entry.y) + " " + userSelectedCurrencySymbol
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
