//
//  ExportAccPublicKeyCellController.swift
//  NodaWallet
//
//  Created by iOS on 16/03/20.
//  .
//

import UIKit

class ExportAccPublicKeyController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var exportAccPublicKeyTableView: UITableView!
    @IBOutlet weak var navTitle: UILabel!
    
    var currencyListFromDB = [CurrencyListDatas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "export_account_public_key".localized()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.exportAccPublicKeyTableView.theme_backgroundColor = ["#FFF", "#000"]
        
        exportAccPublicKeyTableView.delegate = self
        exportAccPublicKeyTableView.dataSource = self
        exportAccPublicKeyTableView.register(UINib(nibName: "ExportAccPublicKeyCell", bundle: nil), forCellReuseIdentifier: "ExportAccPublicKeyCellID")
        exportAccPublicKeyTableView.tableFooterView = UIView()
        
        let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
        for data in currencyData {
            if data.walletID == SelectedWalletDetails.walletID {
                if data.symbol == "ETH" || data.symbol == "BTC" || data.symbol == "LTC" || data.symbol == "BNB" {
                    currencyListFromDB.append(data)
                }
            }
        }
    }

}

extension ExportAccPublicKeyController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyListFromDB.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExportAccPublicKeyCellID", for: indexPath) as! ExportAccPublicKeyCell
        cell.coinLabel.theme_textColor = ["#000", "#FFF"]
        cell.keyLabel.theme_textColor = ["#000", "#FFF"]
        cell.subView.backgroundColor = .clear
        let contentData = currencyListFromDB[indexPath.row] as CurrencyListDatas
        cell.coinLabel.text = contentData.currencyName
        cell.keyLabel.text = contentData.coinPublicKey
        return cell
    }
    
    
}
