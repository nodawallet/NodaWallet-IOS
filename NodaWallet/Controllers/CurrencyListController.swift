//
//  CurrencyListController.swift
//  NodaWallet

import UIKit

protocol CurrencyListControllerDelegate {
    func currencySelected(isSend: Bool, index: Int, currencySymbol: String, currencyImage: String)
}

class CurrencyListController: UIViewController {
    
    @IBOutlet weak var currencyListTableView: UITableView!
    @IBOutlet weak var currencyListTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var currencyList = [CurrencyListDatas]()
    var delegate:CurrencyListControllerDelegate?
    var isSend = true
    var sendCurrencyName = ""
    var getCurrencyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.placeholder = "Search".localized()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.searchView.layer.cornerRadius = 4.0
        self.searchView.theme_backgroundColor = ["#EBEBEB", "#000"]
        self.searchView.theme_alpha = [0.5, 0.5]
        self.currencyListTF.theme_textColor = ["#000", "#FFF"]
        if Constants.User.isDarkMode {
            self.currencyListTF.placeHolderColor = .white
        } else {
            self.currencyListTF.placeHolderColor = .black
        }
        self.currencyListTableView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        //currencyListTableView.separatorColor = UIColor.clear
        currencyListTableView.theme_separatorColor = ["#000", "#FFF"]
        currencyListTableView.register(UINib(nibName: "CurrencyListTableCell", bundle:nil), forCellReuseIdentifier: "CurrencyListTableCellID")
        currencyListTableView.tableFooterView = UIView()
        currencyList.removeAll()
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if isSend {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol != getCurrencyName {
                        currencyList.append(data)
                    }
                }
            } else {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol != sendCurrencyName {
                        currencyList.append(data)
                    }
                }
            }
        }
        self.currencyListTableView.reloadData()
    }
    
}

extension CurrencyListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyListTableCellID", for: indexPath) as? CurrencyListTableCell {
            cell.contentView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
            cell.currencyNameLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencybalanceLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyPercentLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyValueLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyDollarLabel.theme_textColor = ["#000", "#FFF"]
            let contentData = currencyList[indexPath.row]
            cell.currencyNameLabel.text = contentData.currencyName
            cell.currencybalanceLabel.text = contentData.balance
            cell.currencyImageView.loadImage(string: contentData.currencyImage)
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentData = currencyList[indexPath.row]
        DispatchQueue.main.async {
        self.dismiss(animated: false) {
            self.delegate?.currencySelected(isSend: self.isSend, index: indexPath.row, currencySymbol: contentData.symbol, currencyImage: contentData.currencyImage)
        }
        }
    }
    
}
