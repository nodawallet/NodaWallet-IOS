//
//  StockExchangeController.swift
//  NodaWallet

import UIKit
import XLPagerTabStrip

class StockExchangeController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Stock Exchange"
    
    @IBOutlet weak var sellTableView: UITableView!
    @IBOutlet weak var buyTableView: UITableView!
    @IBOutlet weak var openOrderTableView: UITableView!
    
    @IBOutlet weak var buyButtonOutlet: UIButton!
    @IBOutlet weak var sellButtonOutlet: UIButton!
    
    @IBOutlet weak var stockExchangeView: UIView!
    @IBOutlet weak var currencyPairTitle: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var sendCurrencyPriceLabel: UILabel!
    @IBOutlet weak var receiveCurrencyPriceLabel: UILabel!
    
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var receiveView: UIView!
    
    @IBOutlet weak var sendPriceTF: UITextField!
    @IBOutlet weak var receivePriceTF: UITextField!
    
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    @IBOutlet weak var buyConfirmButton: UIButton!
    
    @IBOutlet weak var openOrderTitleLabel: UILabel!
    @IBOutlet weak var openOrderValueLabel: UILabel!
    
    @IBOutlet weak var twentyFiveButton: UIButton!
    @IBOutlet weak var fiftyButton: UIButton!
    @IBOutlet weak var seventyFiveButton: UIButton!
    @IBOutlet weak var hundredButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buyButtonOutlet.clipsToBounds = true
        self.sellButtonOutlet.clipsToBounds = true
        self.buyButtonOutlet.layer.cornerRadius = 0
        self.sellButtonOutlet.layer.cornerRadius = 0
        
        self.buyButtonOutlet.theme_backgroundColor = ["#FFF", "#000"]
        self.buyButtonOutlet.layer.theme_borderColor = ["#DED8CF", "#393939"]
        self.buyButtonOutlet.layer.borderWidth = 3.0
        
        self.sellButtonOutlet.theme_backgroundColor = ["#DED8CF", "#393939"]
        
        self.buyButtonOutlet.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.sellButtonOutlet.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        
        openOrderTableView.separatorColor = UIColor.clear
        sellTableView.separatorColor = UIColor.clear
        sellTableView.register(UINib(nibName: "SellTableCell", bundle:nil), forCellReuseIdentifier: "SellTableCellID")
        
        buyTableView.separatorColor = UIColor.clear
        buyTableView.register(UINib(nibName: "BuyTableCell", bundle:nil), forCellReuseIdentifier: "BuyTableCellID")
        
        updateAppColor()
    }
    
    private func updateAppColor() {
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        self.stockExchangeView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        
        self.sendView.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.receiveView.theme_backgroundColor = ["#DED8CF", "#393939"]
        
        self.twentyFiveButton.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.fiftyButton.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.seventyFiveButton.theme_backgroundColor = ["#DED8CF", "#393939"]
        self.hundredButton.theme_backgroundColor = ["#DED8CF", "#393939"]
        
        self.twentyFiveButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.fiftyButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.seventyFiveButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.hundredButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        
        self.currencyPairTitle.theme_textColor = ["#000", "#FFF"]
        self.sendCurrencyPriceLabel.theme_textColor = ["#000", "#FFF"]
        self.receiveCurrencyPriceLabel.theme_textColor = ["#000", "#FFF"]
        self.openOrderTitleLabel.theme_textColor = ["#000", "#FFF"]
        
        self.priceLabel.theme_textColor = ["#000", "#FFF"]
        self.numberLabel.theme_textColor = ["#000", "#FFF"]
        
        self.balanceTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.balanceValueLabel.theme_textColor = ["#000", "#FFF"]
        self.totalTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.totalValueLabel.theme_textColor = ["#000", "#FFF"]
        
        self.buyConfirmButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        
        if Constants.User.isDarkMode {
            self.sendPriceTF.placeHolderColor = UIColor.white
            self.receivePriceTF.placeHolderColor = UIColor.white
            self.stockExchangeView.layer.shadowColor = UIColor.darkGray.cgColor
        } else {
            self.sendPriceTF.placeHolderColor = UIColor.black
            self.receivePriceTF.placeHolderColor = UIColor.black
            self.stockExchangeView.layer.shadowColor = UIColor.lightGray.cgColor
        }
        
        self.sendPriceTF.theme_textColor = ["#000", "#FFF"]
        self.receivePriceTF.theme_textColor = ["#000", "#FFF"]
    }
    
    @IBAction func buyAction(_ sender: Any) {
        self.updateBuyButton()
    }
    
    private func updateBuyButton() {
        if Constants.User.isDarkMode {
            self.buyButtonOutlet.backgroundColor = .black
            self.buyButtonOutlet.layer.borderWidth = 3.0
            self.buyButtonOutlet.layer.borderColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0).cgColor
            self.sellButtonOutlet.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0)
            self.sellButtonOutlet.layer.borderWidth = 0
        } else {
            self.buyButtonOutlet.backgroundColor = .white
            self.buyButtonOutlet.layer.borderWidth = 3.0
            self.buyButtonOutlet.layer.borderColor = UIColor(red: 220/255, green: 216/255, blue: 207/255, alpha: 1.0).cgColor
            self.sellButtonOutlet.backgroundColor = UIColor(red: 220/255, green: 216/255, blue: 207/255, alpha: 1.0)
            self.sellButtonOutlet.layer.borderWidth = 0
        }
    }
    
    @IBAction func sellAction(_ sender: Any) {
        self.updateSellButton()
    }
    
    private func updateSellButton() {
        if Constants.User.isDarkMode {
            self.sellButtonOutlet.backgroundColor = .black
            self.sellButtonOutlet.layer.borderWidth = 3.0
            self.sellButtonOutlet.layer.borderColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0).cgColor
            self.buyButtonOutlet.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0)
            self.buyButtonOutlet.layer.borderWidth = 0
        } else {
            self.sellButtonOutlet.backgroundColor = .white
            self.sellButtonOutlet.layer.borderWidth = 3.0
            self.sellButtonOutlet.layer.borderColor = UIColor(red: 220/255, green: 216/255, blue: 207/255, alpha: 1.0).cgColor
            self.buyButtonOutlet.backgroundColor = UIColor(red: 220/255, green: 216/255, blue: 207/255, alpha: 1.0)
            self.buyButtonOutlet.layer.borderWidth = 0
        }
    }
    
    @IBAction func twentyFivePercentTapped(_ sender: Any) {
    }
    
    @IBAction func fiftyPercentTapped(_ sender: Any) {
    }
    
    @IBAction func seventyFivePercentTapped(_ sender: Any) {
    }
    
    @IBAction func hundredPercentTapped(_ sender: Any) {
    }
    
    @IBAction func buyConfirmAction(_ sender: Any) {
    }
    
}

extension StockExchangeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sellTableView {
            return 100
        }
        if tableView == buyTableView {
            return 100
        }
        if tableView == openOrderTableView {
            return 10
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sellTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SellTableCellID", for: indexPath) as? SellTableCell {
                cell.contentView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
                return cell
            }
        }
        if tableView == buyTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BuyTableCellID", for: indexPath) as? BuyTableCell {
                cell.contentView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
                return cell
            }
        }
        if tableView == openOrderTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OpenOrderTableCellID", for: indexPath) as? OpenOrderTableCell {
                cell.contentView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == openOrderTableView {
            return tableView.frame.height/3
        }
        return 20
    }
}

extension StockExchangeController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "stock_exchange".localized())
    }
}
