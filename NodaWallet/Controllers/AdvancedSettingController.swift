//
//  AdvancedSettingController.swift
//  NodaWallet

import UIKit

class AdvancedSettingController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var WalletTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var navTitle: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "main_wallet".localized()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        WalletTableView.delegate = self
        WalletTableView.dataSource = self
        WalletTableView.register(UINib(nibName: "WalletCell", bundle: nil), forCellReuseIdentifier: "WalletCell")
        backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        if !Constants.User.isDarkMode {
            plusImage.image = plusImage.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            plusImage.tintColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WalletTableView.reloadData()
    }
    
    @IBAction func createWalletAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndSecureControllerID") as? PrivateAndSecureController {
            vc.showBackView = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AdvancedSettingController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalDBManager.sharedInstance.getMnemonicDetailsFromDB().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        cell.walletIconImage.theme_image = ["Round_Wallet_Light", "Round_Wallet_Dark"]
        cell.walletView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        cell.mainWalletLabel.theme_textColor = ["#000", "#FFF"]
        cell.multiCoinWallet.theme_textColor = ["#000", "#FFF"]
        cell.delegate = self
        //cell.multiCoinWallet.text = "multi_coin_wallet".localized()
        let content = LocalDBManager.sharedInstance.getMnemonicDetailsFromDB()[indexPath.row] as MnemonicPhraseDatas
        cell.multiCoinWallet.text = content.address
        cell.mainWalletLabel.text = content.walletName
        let selectedWalletID = UserDefaults.standard.integer(forKey: Constants.UserDefaultKey.selectedWalletID) - 1
        if indexPath.row == selectedWalletID {
            cell.tickImageView.image = UIImage(named: "Tick_Light")
        } else {
            cell.tickImageView.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row + 1, forKey: Constants.UserDefaultKey.selectedWalletID)
        DispatchQueue.main.async {
            APPDELEGATE.homepage()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
}

extension AdvancedSettingController: WalletCellDelegate {
    func infoCliced(cell: UITableViewCell) {
        guard let indexPath = self.WalletTableView.indexPath(for: cell) else {
            return
        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainWalletControllerID") as? MainWalletController {
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
