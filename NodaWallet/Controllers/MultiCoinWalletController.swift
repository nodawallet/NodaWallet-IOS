//
//  MultiCoinWalletController.swift
//  NodaWallet

import UIKit

class MultiCoinWalletController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var multiCopinWalletLabel: UILabel!
    @IBOutlet weak var multiCoinTableView: UITableView!
    @IBOutlet weak var walletImage: UIImageView!
    
    var currencyName = ["Ethereum"]
    var currencyImage = ["Etherium"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.contentView.theme_backgroundColor = ["#EBEBEB", Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.multiCopinWalletLabel.theme_textColor = ["#000", "#FFF"]
        self.walletImage.theme_image = ["Round_Wallet_Light", "Round_Wallet_Dark"]
        self.multiCoinTableView.theme_backgroundColor = ["#FFF", "#000"]
        self.multiCoinTableView.register(UINib(nibName: "TokenListTableCell", bundle:nil), forCellReuseIdentifier: "TokenTableCellID")
        self.multiCoinTableView.tableFooterView = UIView()
        
        self.multiCopinWalletLabel.text = "multi_coin_wallet".localized()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func multiCoinWalletAction(_ sender: UIButton) {
        self.pushViewController(identifier: "ImportWalletControllerID", storyBoardName: "Main")
    }
    
}

extension MultiCoinWalletController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenTableCellID", for: indexPath) as! TokenListTableCell
        cell.currencyValueLabel.isHidden = true
        cell.tokenListState.isHidden = true
        cell.currencyPriceLabel.isHidden = true
        cell.currencyPercentLabel.isHidden = true
        cell.balanceIntoMPLabel.isHidden = true
        
        cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
        cell.currencyNameLabel.theme_textColor = ["#000", "#FFF"]
        cell.currencyPriceLabel.theme_textColor = ["#000", "#FFF"]
        cell.tokenListState.theme_onTintColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.lightMode]
        cell.currencyNameLabel.text = currencyName[indexPath.row]
        cell.currencyImageView.image = UIImage(named: currencyImage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(identifier: "ImportCurrencyController", storyBoardName: "Main")
    }
    
    
}
