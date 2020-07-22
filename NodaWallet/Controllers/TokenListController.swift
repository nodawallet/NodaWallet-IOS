//
//  TokenListController.swift
//  NodaWallet
//
//  Created by iOS on 13/03/20.
//  
//

import UIKit
import RealmSwift

class TokenListController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tokenListTableView: UITableView!
    @IBOutlet weak var addTokenButton: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchImage: UIImageView!

    var currencyList = [CurrencyListDatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.delegate = self
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
       // self.addTokenButton.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.searchTF.placeholder = "Search".localized()
        self.searchView.layer.cornerRadius = 4.0
        self.searchView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.searchView.theme_alpha = [0.5, 0.5]
        self.searchTF.theme_textColor = ["#000", "#FFF"]
        
        if Constants.User.isDarkMode {
            self.searchTF.placeHolderColor = .white
        } else {
            self.searchTF.placeHolderColor = .darkGray
        }
            
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        tokenListTableView.delegate = self
        tokenListTableView.dataSource = self
        tokenListTableView.register(UINib(nibName: "TokenListTableCell", bundle: nil), forCellReuseIdentifier: "TokenTableCellID")
        tokenListTableView.tableFooterView = UIView()
        
        self.navTitle.text = "Add_token".localized()
        self.addTokenButton.setTitle("Add_custom_token".localized(), for: .normal)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTokenFromAPI()
    }
    
    private func getTokenFromAPI() {
        DataManager.getCurrencyList { (success, msg, data, error) in
            if success {
                let json = jsonArray(data: data ?? Data.init())
                if let responseArray = json["data"] as? [[String: Any]] {
                    for currencyArr in responseArray {
                        let currName = currencyArr["currency"] as? String ?? ""
                        let currSymbol = currencyArr["symbol"] as? String ?? ""
                        let currImage = currencyArr["logo"] as? String ?? ""
                        let contractAddress = currencyArr["contract_address"] as? String ?? ""
                        let geckoID = currencyArr["gekko_id"] as? String ?? ""
                        let decimal = currencyArr["decimal"] as? Int ?? 0
                        let type = currencyArr["type"] as? String ?? ""
                        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
                        
                        if currName == "Ethereum" {
                            if responseArray.count == 1 {
                                self.loadCurrencyList()
                            }
                        } else if currName == "Bitcoin" {
                            if responseArray.count == 2 {
                               self.loadCurrencyList()
                            }
                        } else if currName == "Litecoin" {
                            if responseArray.count == 3 {
                               self.loadCurrencyList()
                            }
                        } else if currName == "Binance" {
                            if responseArray.count == 4 {
                               self.loadCurrencyList()
                            }
                        } else {
                            var isAddCurrency = true
                                        
                           for localData in currencyData {
                                if localData.walletID == SelectedWalletDetails.walletID {
                                    if localData.symbol == currSymbol {
                                        isAddCurrency = false
                                    }
                                }
                            }
                                        
                            if isAddCurrency {
                                let realm = try! Realm()
                                var currencyID = currencyData.count
                                currencyID = currencyID + 1
                                                                     
                                let addCurrencyList0 = updateCurrencyData(currencyName: currName, currencyID: currencyID, currencyImage: currImage, enable: false, address: contractAddress, symbol: currSymbol, balance: "0", decimal: decimal, walletID: SelectedWalletDetails.walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "customtoken", geckoID: geckoID, coinPublicKey: "", type: type)
                                                                     
                                try! realm.write {
                                    realm.add(addCurrencyList0)
                                }
                            }
                        }
                        
                    }
                    self.loadCurrencyList()
                }
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
    private func loadCurrencyList() {
        currencyList.removeAll()
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                currencyList.append(data)
            }
        }
        tokenListTableView.reloadData()
    }
    
    @IBAction func addCustomToken(_ sender: Any) {
        self.pushViewController(identifier: "AddCustomTokenController", storyBoardName: "Main")
    }
    
}

extension TokenListController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenTableCellID", for: indexPath) as! TokenListTableCell
        cell.currencyValueLabel.isHidden = true
        cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
        cell.currencyNameLabel.theme_textColor = ["#000", "#FFF"]
        cell.currencyPriceLabel.theme_textColor = ["#000", "#FFF"]
        cell.tokenListState.theme_onTintColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.lightMode]
        let content = currencyList[indexPath.row] as CurrencyListDatas
        cell.currencyNameLabel.text = content.currencyName
        cell.currencyImageView.loadImage(string: content.currencyImage)
        cell.currencyPriceLabel.text = content.balance + " " + content.symbol
        cell.tokenListState.isOn = content.enable
        cell.delegate = self
        cell.currencyPercentLabel.isHidden = true
        cell.balanceIntoMPLabel.isHidden = true
        return cell
    }
    
}

extension TokenListController: TokenListTableCellDelegate {
    func currencyEnabled(enable: Bool, cell: TokenListTableCell) {
        guard let indexPath = tokenListTableView.indexPath(for: cell) else {
            return
        }
        let content = currencyList[indexPath.row]
        let obj = CurrencyListDatas()
        LocalDBManager.sharedInstance.updateShowAndHideCurrency(object: obj, currencyName: content.currencyImage, currencyID: content.currencyID, currencyImage: content.currencyImage, enable: enable)
        self.loadCurrencyList()
    }
}

extension TokenListController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        currencyList.removeAll()
        for data in currencyData {
            if data.currencyName.lowercased().contains(string) {
                if data.walletID == SelectedWalletDetails.walletID {
                    currencyList.append(data)
                }
            }
        }
        self.tokenListTableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if textField.text?.count == 0 {
                self.loadCurrencyList()
            } else {
                let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
                currencyList.removeAll()
                for data in currencyData {
                    if data.currencyName.lowercased().contains(textField.text ?? "") {
                        if data.walletID == SelectedWalletDetails.walletID {
                            currencyList.append(data)
                        }
                    }
                }
                self.tokenListTableView.reloadData()
            }
        }
    }
    
}
