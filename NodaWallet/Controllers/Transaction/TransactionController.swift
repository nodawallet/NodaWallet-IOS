//
//  TransactionController.swift
//  NodaWallet
//
//  Created by iOS on 12/03/20.
//  .
//

import UIKit
import web3swift
import BigInt
import FittedSheets

class TransactionController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var currenctTitleLbl: UILabel!
    
    var transactionListArr = [[String: Any]]()
    var currencyList = [CurrencyListDatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.separatorColor = .clear
        transactionTableView.register(UINib(nibName: "ExchangeCell", bundle: nil), forCellReuseIdentifier: "ExchangeCell")
        transactionTableView.register(UINib(nibName: "SendReceiveCell", bundle: nil), forCellReuseIdentifier: "SendReceiveCell")
        
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        if Constants.User.isDarkMode {
            self.typeView.layer.borderColor = UIColor.white.cgColor
        } else {
            self.typeView.layer.borderColor = UIColor.black.cgColor
        }
        self.currenctTitleLbl.theme_textColor = ["#000", "#FFF"]
        self.getExchangeHistory(address: SelectedWalletDetails.walletAddress)
    }
    
    private func getExchangeHistory(address: String) {
        let param = ["address": address,"method":"all_exchange"] as [String: AnyObject]
        DataManager.getExchangeHistory(parameter: param) { (success, msg, data, error) in
            if success {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        return
                    }
                    if let orderListArray = jsonArray["data"] as? [[String: Any]] {
                        self.transactionListArr = orderListArray
                        self.transactionTableView.reloadData()
                    }
                    if self.transactionListArr.count == 0 {
                        self.transactionTableView.setEmptyMessage("No Records Found")
                    } else {
                        self.transactionTableView.restore()
                    }
                } catch(let error) {
                    print(error)
                }
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
    @IBAction func currency_List_Act(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterCurrencyID") as? FilterCurrencyController {
            let sheetController = SheetViewController(controller: vc)
            vc.delegate = self
            self.present(sheetController, animated: false, completion: nil)
        }
        
    }
    
}

extension TransactionController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // let count = LocalDBManager.sharedInstance.getExchangeHistoryFromDB().count
        return transactionListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath) as! ExchangeCell
        cell.subView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        cell.subView.layer.theme_shadowColor = ["#9A9A9A", "#434343"]
        cell.orderTypeLabel.theme_textColor = ["#000", "#FFF"]
        cell.DateLabel.theme_textColor = ["#000", "#FFF"]
        cell.pairLabel.theme_textColor = ["#000", "#FFF"]
        cell.pairContentLabel.theme_textColor = ["#000", "#FFF"]
        cell.sendAmountLabel.theme_textColor = ["#000", "#FFF"]
        cell.sendAmountContentLabel.theme_textColor = ["#000", "#FFF"]
        cell.receiveAmountLabel.theme_textColor = ["#000", "#FFF"]
        cell.receiveAmountContentLabel.theme_textColor = ["#000", "#FFF"]
        cell.feesLabel.theme_textColor = ["#000", "#FFF"]
        cell.statusLabel.theme_textColor = ["#000", "#FFF"]
        cell.statusContentLabel.theme_textColor = ["#000", "#FFF"]
        cell.feesContentLabel.theme_textColor = ["#000", "#FFF"]
        cell.hashTitleLabel.theme_textColor = ["#000", "#FFF"]
        cell.hashLabel.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblOne.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblTwo.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblThree.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblFour.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblFive.theme_textColor = ["#000", "#FFF"]
        cell.semiColonLblSix.theme_textColor = ["#000", "#FFF"]
        
        let contentData = transactionListArr[indexPath.row]
        let spendCurr = contentData["spend_currency"] as? String ?? ""
        let receiveCurr = contentData["receive_currency"] as? String ?? ""
        let sendAmount = contentData["spend_amount"] as? Double ?? 0.0
        let receiveAmount = contentData["receive_amounty"] as? Double ?? 0.0
        let status = contentData["status"] as? String ?? ""
        let hash = contentData["tax_id"] as? String ?? ""
        let date = contentData["date"] as? String ?? ""
        let time = contentData["time"] as? String ?? ""
        let fees = contentData["fee"] as? Double ?? 0.0001
        let pair = spendCurr + "/" + receiveCurr
        
        cell.DateLabel.text = date + " " + time
        cell.pairContentLabel.text = pair
        cell.sendAmountContentLabel.text = String(format: "%.8f", sendAmount) + " " + spendCurr
        cell.receiveAmountContentLabel.text = String(format: "%.8f", receiveAmount) + " " + receiveCurr
        cell.feesContentLabel.text = "\(fees)"
        cell.statusContentLabel.text = status
        cell.hashLabel.text = hash
        
        return cell
    }
    
}

extension TransactionController: FilterCurrencyControllerDelegate {
    func currencySelected(currency: String) {
        self.currenctTitleLbl.text = currency
        self.transactionListArr.removeAll()
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.enable == true {
                    currencyList.append(data)
                }
            }
        }
        if currency == "BTC" {
            if currencyList.count >= 2 {
                self.getExchangeHistory(address: currencyList[1].address)
            }
        } else if currency == "LTC" {
            if currencyList.count >= 3 {
                self.getExchangeHistory(address: currencyList[2].address)
            }
        } else {
            self.getExchangeHistory(address: SelectedWalletDetails.walletAddress)
        }
    }
    
}
