//
//  AddCustomTokenController.swift
//  NodaWallet
//
//  Created by iOS on 13/03/20.
//  .
//

import UIKit
import RealmSwift
import web3swift
import BigInt

class AddCustomTokenController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var addTokenButton: UIButton!
    
    @IBOutlet weak var networkTitleLabel: UILabel!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var symbolTF: UITextField!
    @IBOutlet weak var decimalTF: UITextField!
    
    @IBOutlet weak var showNetworkListButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var scanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTF.delegate = self
        self.updateAppColor()
    }
    
    private func updateAppColor() {
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
       // self.addTokenButton.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.networkTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.showNetworkListButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.pasteButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        self.networkView.theme_backgroundColor = ["#F0F0F0", "#303234"]
        
        self.addressTF.theme_textColor = ["#000", "#FFF"]
        self.nameTF.theme_textColor = ["#000", "#FFF"]
        self.symbolTF.theme_textColor = ["#000", "#FFF"]
        self.decimalTF.theme_textColor = ["#000", "#FFF"]
        
        //Localization
        self.networkTitleLabel.text = "network".localized()
        self.addressTF.placeholder = "contract_address".localized()
        self.nameTF.placeholder = "Name".localized()
        self.symbolTF.placeholder = "symbol".localized()
        self.decimalTF.placeholder = "decimal".localized()
        self.pasteButton.setTitle("Paste".localized(), for: .normal)
        self.addTokenButton.setTitle("done".localized(), for: .normal)
        
        if Constants.User.isDarkMode {
            self.addressTF.placeHolderColor = .white
            self.nameTF.placeHolderColor = .white
            self.symbolTF.placeHolderColor = .white
            self.decimalTF.placeHolderColor = .white
        } else {
            self.addressTF.placeHolderColor = .lightGray
            self.nameTF.placeHolderColor = .lightGray
            self.symbolTF.placeHolderColor = .lightGray
            self.decimalTF.placeHolderColor = .lightGray
        }
        
        if !Constants.User.isDarkMode {
            scanImage.image = scanImage.image?.withRenderingMode(.alwaysTemplate)
            scanImage.tintColor = UIColor.black
        }
        
        self.navTitleLabel.text = "Add_token".localized()
    }
    
    @IBAction func networkListAct(_ sender: Any) {
        self.pushViewController(identifier: "NetworkListController", storyBoardName: "Main")
    }

    @IBAction func pasteAct(_ sender: Any) {
        if let myString = UIPasteboard.general.string {
           addressTF.insertText(myString)
        }
        self.validateTF { (success, msg) in
            if success {
                self.getContractDetails()
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
    private func getContractDetails() {
        DataManager.getContractDetails(address: addressTF.text!) { (success, response, data, error) in
            if success {
                if response.count > 0 {
                    self.nameTF.text = response[0]["tokenName"] as? String ?? ""
                    self.symbolTF.text = response[0]["tokenSymbol"] as? String ?? ""
                    self.decimalTF.text = response[0]["tokenDecimal"] as? String ?? ""
                }
            } else {
                self.popUpView(message: "enter_valid_contract_address".localized())
            }
        }
    }
    
    @IBAction func scanAction(_ sender: Any) {
        if let scanVc = self.storyboard?.instantiateViewController(withIdentifier: "CommonScannerControllerID") as? CommonScannerController {
         scanVc.delegate = self
         self.present(scanVc, animated: true, completion: nil)
        }
    }
    
    @IBAction func addCustomToken(_ sender: Any) {
        if addressTF.text!.isEmpty {
            self.popUpView(message: "enter_address".localized())
            return
        }
        if nameTF.text!.isEmpty {
            self.popUpView(message: "enter_name".localized())
            return
        }
        if symbolTF.text!.isEmpty {
            self.popUpView(message: "enter_symbol".localized())
            return
        }
        if decimalTF.text!.isEmpty {
            self.popUpView(message: "enter_decimal_from".localized())
            return
        }
        let addr = EthereumAddress(addressTF.text!)
        if addr == nil {
            self.popUpView(message: "enter_valid_contract_address".localized())
            return
        }
        self.addTokenToDB()
        /*DataManager.getContractABI(address: addressTF.text!) { (success, result, data, error) in
            if success {
                self.addTokenToDB()
            } else {
                self.popUpView(message: "enter_valid_contract_address".localized())
            }
        }*/
    }
    
    private func validateTF(completionHandler: @escaping (Bool, String) -> Swift.Void) -> () {
        var message = ""
        if addressTF.text!.isEmpty {
            message = "enter_address".localized()
            completionHandler(false, message)
            return
        }
        let addr = EthereumAddress(addressTF.text!)
        if addr == nil {
            message = "enter_valid_contract_address".localized()
            completionHandler(false, message)
            return
        }
        completionHandler(true, message)
    }
    
    private func addTokenToDB() {
        let realm = try! Realm()
        var currencyID = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB().count
        currencyID = currencyID + 1
        
        let addCurrencyList0 = updateCurrencyData(currencyName: nameTF.text!, currencyID: currencyID, currencyImage: "ERC-20", enable: true, address: addressTF.text!, symbol: symbolTF.text!, balance: "0", decimal: Int(decimalTF.text!) ?? 0, walletID: SelectedWalletDetails.walletID, marketPrice: currentMarketPrice, marketPercentage: ETHVolumeChangePercent, privateKey: "", importedBy: "Address", isToken: "usertoken", geckoID: "", coinPublicKey: "", type: "ERC20")
        
        try! realm.write {
            realm.add(addCurrencyList0)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddCustomTokenController: CommonScannerControllerDelegate {
    func scannedQR(qrCode: String) {
        self.addressTF.text = qrCode
        self.textFieldDidEndEditing(self.addressTF)
    }
    
}

extension AddCustomTokenController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            return
        }
        self.validateTF { (success, msg) in
            if success {
                self.getContractDetails()
            } else {
                self.popUpView(message: msg)
            }
        }
    }
    
}
