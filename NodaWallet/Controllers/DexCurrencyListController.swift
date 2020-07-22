//
//  DexCurrencyListController.swift
//  NodaWallet

import UIKit

protocol DexCurrencyListControllerDelegate {
    func currencySelected(isSend: Bool, index: Int, currencySymbol: String, currencyImage: String, balance: String)
}

class DexCurrencyListController: UIViewController {
    
    @IBOutlet weak var currencyListTableView: UITableView!
    @IBOutlet weak var currencyListTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var currencyList = [CurrencyListDatas]()
    var delegate:DexCurrencyListControllerDelegate?
    var isSend = true
    var sendCurrencyName = ""
    var getCurrencyName = ""
    
    var searchedCurrencyList = [CurrencyListDatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.delegate = self
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
        currencyListTableView.register(UINib(nibName: "DexCurrencyListTableCell", bundle:nil), forCellReuseIdentifier: "DexCurrencyListCell")
        currencyListTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTableView()
    }
    
    private func updateTableView() {
        currencyList.removeAll()
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.isToken != "usertoken" && data.type != "BEP2" {
                    if data.enable == true {
                        currencyList.append(data)
                    }
                }
            }
        }
        self.currencyListTableView.reloadData()
    }
    
}

extension DexCurrencyListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedCurrencyList.count > 0 {
            return searchedCurrencyList.count
        }
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DexCurrencyListCell", for: indexPath) as? DexCurrencyListTableCell {
            cell.contentView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
            cell.currencyNameLabel.theme_textColor = ["#000", "#FFF"]
            cell.currencyBalanceLabel.theme_textColor = ["#000", "#FFF"]
            
            if searchedCurrencyList.count > 0 {
                let contentData = searchedCurrencyList[indexPath.row]
                cell.currencyNameLabel.text = contentData.currencyName
                cell.currencyBalanceLabel.text = contentData.balance + " " + contentData.symbol
                cell.currencyImageView.loadImage(string: contentData.currencyImage)
            } else {
                let contentData = currencyList[indexPath.row]
                cell.currencyNameLabel.text = contentData.currencyName
                cell.currencyBalanceLabel.text = contentData.balance + " " + contentData.symbol
                cell.currencyImageView.loadImage(string: contentData.currencyImage)
            }
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contentData:CurrencyListDatas!
        var index = 0
        if searchedCurrencyList.count > 0 {
            contentData = searchedCurrencyList[indexPath.row]
            let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
            for (loopIndex ,data) in currencyData.enumerated() {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.enable == true {
                        if contentData.currencyName == data.currencyName {
                            index = loopIndex
                        }
                    }
                }
            }
        } else {
            contentData = currencyList[indexPath.row]
            index = indexPath.row
        }
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
            self.delegate?.currencySelected(isSend: self.isSend, index: index, currencySymbol: contentData.symbol, currencyImage: contentData.currencyImage, balance: contentData.balance)
            }
        }
    }
    
}

extension DexCurrencyListController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        currencyList.removeAll()
        searchedCurrencyList.removeAll()
        for data in currencyData {
            if data.currencyName.lowercased().contains(string) {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.enable == true {
                        //currencyList.append(data)
                        searchedCurrencyList.append(data)
                    }
                }
            }
        }
        self.currencyListTableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if textField.text?.count == 0 {
                self.updateTableView()
            } else {
                let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
                currencyList.removeAll()
                searchedCurrencyList.removeAll()
                for data in currencyData {
                    if data.currencyName.lowercased().contains(textField.text ?? "") {
                        if data.walletID == SelectedWalletDetails.walletID {
                            if data.enable == true {
                                //currencyList.append(data)
                                searchedCurrencyList.append(data)
                            }
                        }
                    }
                }
                self.currencyListTableView.reloadData()
            }
        }
    }
    
}
