//
//  FilterCurrencyController.swift
//  NodaWallet
//
//  Created by macOsx on 17/06/20.
//  .
//

import UIKit

protocol FilterCurrencyControllerDelegate {
    func currencySelected(currency: String)
}

class FilterCurrencyController: UIViewController {

    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var delegate:FilterCurrencyControllerDelegate?
    
    var allCurrencyArr = [
    "data": [[
        "currencyName": "ETH",
        "image": "Etherium"
    ], [
        "currencyName": "BTC",
        "image": "Bitcoin"
    ], [
        "currencyName": "LTC",
        "image": "Litecoin"
    ], [
        "currencyName": "BNB",
        "image": "Binance"
    ] ]] as [String : Any]
    
    var myCustomArr = [[String : Any]]()
    var searchArr = [[String : Any]]()
    var isSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.delegate = self
        self.searchTF.placeholder = "Search".localized()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.searchView.layer.cornerRadius = 4.0
        self.searchView.theme_backgroundColor = ["#EBEBEB", "#000"]
        self.searchView.theme_alpha = [0.5, 0.5]
        self.searchTF.theme_textColor = ["#000", "#FFF"]
        
        self.currencyTableView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.currencyTableView.tableFooterView = UIView()
        if Constants.User.isDarkMode {
            self.currencyTableView.separatorColor = .white
        } else {
            self.currencyTableView.separatorColor = .lightGray
        }
        if let customArr = allCurrencyArr["data"] as? [[String : Any]] {
            self.myCustomArr = customArr
        }
    }

}

extension FilterCurrencyController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched {
            return searchArr.count
        }
        return myCustomArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCurrencyListTableCell", for: indexPath) as? FilterCurrencyListTableCell {
            cell.contentView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
            cell.currencyLabel.theme_textColor = ["#000", "#FFF"]
            
            var contentData = [String: Any]()
            if isSearched {
                contentData = searchArr[indexPath.row]
            } else {
                contentData = myCustomArr[indexPath.row]
            }
            
            cell.currencyLabel.text = contentData["currencyName"] as? String ?? ""
            cell.currencyCoin.loadImage(string: contentData["image"] as? String ?? "")
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension FilterCurrencyController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contentData = [String: Any]()
        if isSearched {
            contentData = searchArr[indexPath.row]
        } else {
            contentData = myCustomArr[indexPath.row]
        }
        self.dismiss(animated: false) {
            self.delegate?.currencySelected(currency: contentData["currencyName"] as? String ?? "")
        }
    }
}

extension FilterCurrencyController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if searchTF.text!.isEmpty {
                self.isSearched = false
                self.currencyTableView.reloadData()
                return
            } else {
                var currencyArr = [[String: Any]]()
                currencyArr.removeAll()
                for data in myCustomArr {
                    let currencyName = data["currencyName"] as? String ?? ""
                    if currencyName.lowercased().contains(searchTF.text ?? "") {
                        currencyArr.append(data)
                    }
                }
                searchArr = currencyArr
                isSearched = true
                self.currencyTableView.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currencyArr = [[String: Any]]()
        currencyArr.removeAll()
        for data in myCustomArr {
            let currencyName = data["currencyName"] as? String ?? ""
            if currencyName.lowercased().contains(searchTF.text ?? "") {
                currencyArr.append(data)
            }
        }
        if currencyArr.count > 0 {
            searchArr = currencyArr
            isSearched = true
        }
        self.currencyTableView.reloadData()
        return true
    }
}
