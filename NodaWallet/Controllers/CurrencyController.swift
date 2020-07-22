//
//  CurrencyController.swift
//  NodaWallet
//
//  Created by iOS on 16/03/20.
//  .
//

import UIKit

class CurrencyController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var currencyAllTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var navTitle: UILabel!
        
    var customCurrencyArr = [
        "data": [[
            "currencyName": "USD - US Dollar",
            "symbol": "$",
            "currency": "USD"
        ], [
            "currencyName": "BTC - Bitcoin",
            "symbol": "BTC",
            "currency": "BTC"
        ], [
            "currencyName": "EUR - Euro",
            "symbol": "€",
            "currency": "EUR"
        ], [
            "currencyName": "GBP - British",
            "symbol": "£",
            "currency": "GBP"
        ], [
            "currencyName": "RUB - Russian Ruble",
            "symbol": "₽",
            "currency": "RUB"
        ], [
            "currencyName": "AUD - Australian Dollar",
            "symbol": "A$",
            "currency": "AUD"
        ], [
            "currencyName": "INR - Indian Rupee",
            "symbol": "₹",
            "currency": "INR"
        ], [
            "currencyName": "CNY - Chinese yuan",
            "symbol": "¥",
            "currency": "CNY"
        ], [
            "currencyName": "CAD - Canadian Dollar",
            "symbol": "C$",
            "currency": "CAD"
        ], [
            "currencyName": "JPY - Japanese Yen",
            "symbol": "¥",
            "currency": "JPY"
        ], [
            "currencyName": "KWD - Kuwaiti Dinar",
            "symbol": "د.ك",
            "currency": "KWD"
        ], [
            "currencyName": "CHF - Swiss Franc",
            "symbol": "SFr",
            "currency": "CHF"
        ]
           ]] as [String : Any]
    
    var allCustomCurrencyArr = [[String : Any]]()
    var searchArr = [[String : Any]]()
    var isSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.delegate = self
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.searchTF.placeholder = "Search".localized()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.searchView.layer.cornerRadius = 4.0
        self.searchView.theme_backgroundColor = ["#EBEBEB", "#000"]
        self.searchView.theme_alpha = [0.5, 0.5]
        self.searchTF.theme_textColor = ["#000", "#FFF"]
        self.currencyAllTableView.theme_backgroundColor = ["#FFF", "#000"]
        
        currencyAllTableView.delegate = self
        currencyAllTableView.dataSource = self
        currencyAllTableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCellID")
        currencyAllTableView.tableFooterView = UIView()
        
        if Constants.User.isDarkMode {
            self.searchTF.placeHolderColor = .white
            self.currencyAllTableView.separatorColor = .white
        } else {
            self.searchTF.placeHolderColor = .black
        }
        
        self.navTitle.text = "currency".localized()
        if let customArr = customCurrencyArr["data"] as? [[String : Any]] {
            self.allCustomCurrencyArr = customArr
        }
    }
    
}

extension CurrencyController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched {
            return searchArr.count
        }
        return allCustomCurrencyArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCellID", for: indexPath) as! CurrencyCell
        cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
        cell.selectionStyle = .none
        cell.currencyLabel.theme_textColor = ["#000", "#FFF"]
       
        var contentData = [String: Any]()
        if isSearched {
            contentData = searchArr[indexPath.row]
        } else {
            contentData = allCustomCurrencyArr[indexPath.row]
        }
         
        cell.currencyLabel.text = contentData["currencyName"] as? String ?? ""
        
        let symbolArr = contentData["symbol"] as? String ?? ""
        let userSelectedCurrencyVal = UserDefaults.standard.string(forKey: Constants.UserDefaultKey.userSelectedCurrencySymbolID)
        if symbolArr == userSelectedCurrencyVal {
            cell.selectedCurrencyImage.image = UIImage(named: "Filled_Circle")
        } else {
            cell.selectedCurrencyImage.image = UIImage(named: "")
        }
        
        let currency = contentData["currency"] as? String ?? ""
        let currencyInLowerCase = currency.lowercased()
        cell.countryImage.image = UIImage(named: currencyInLowerCase)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Default currency
        var contentData = [String: Any]()
        if isSearched {
            contentData = searchArr[indexPath.row]
        } else {
            contentData = allCustomCurrencyArr[indexPath.row]
        }
        let currency = contentData["currency"] as? String ?? ""
        let currencySymbol = contentData["symbol"] as? String ?? ""
        UserDefaults.standard.set(currency, forKey: Constants.UserDefaultKey.userSelectedCurrencyID)
        UserDefaults.standard.set(currencySymbol, forKey: Constants.UserDefaultKey.userSelectedCurrencySymbolID)
        loadApp()
    }
    
    @objc func loadApp() {
        DispatchQueue.main.async {
            APPDELEGATE.homepage()
        }
    }
    
}

extension CurrencyController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if searchTF.text!.isEmpty {
                self.isSearched = false
                self.currencyAllTableView.reloadData()
                return
            } else {
                var currencyArr = [[String: Any]]()
                currencyArr.removeAll()
                for data in allCustomCurrencyArr {
                    let currencyName = data["currencyName"] as? String ?? ""
                    if currencyName.lowercased().contains(searchTF.text ?? "") {
                        currencyArr.append(data)
                    }
                }
                searchArr = currencyArr
                isSearched = true
                self.currencyAllTableView.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currencyArr = [[String: Any]]()
        currencyArr.removeAll()
        for data in allCustomCurrencyArr {
            let currencyName = data["currencyName"] as? String ?? ""
            if currencyName.lowercased().contains(searchTF.text ?? "") {
                currencyArr.append(data)
            }
        }
        if currencyArr.count > 0 {
            searchArr = currencyArr
            isSearched = true
        }
        self.currencyAllTableView.reloadData()
        return true
    }

}
