//
//  PrivateAndSecureController.swift
//  NodaWallet

import UIKit
import web3swift
import RealmSwift

class PrivateAndSecureController: UIViewController {

    @IBOutlet weak var walletButtonView: UIView!
    @IBOutlet weak var continueButtonView: UIView!
    
    @IBOutlet weak var privateTitleLabel: UILabel!
    @IBOutlet weak var privateContentLabel: UILabel!
    @IBOutlet weak var termsContentLabel: UILabel!
    
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var createWalletButton: UIButton!
    @IBOutlet weak var haveWalletButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var isSelected = false
    var showBackView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.walletButtonView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.continueButtonView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.privateTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.privateContentLabel.theme_textColor = ["#434343", "#FFF"]
        self.termsContentLabel.theme_textColor = ["#000", "#FFF"]
        
        self.privateTitleLabel.text = "Private_and_Secure".localized()
        self.privateContentLabel.text = "Private_keys_will_never_leave_your_device".localized()
        self.createWalletButton.setTitle("cerate_new_wallet".localized(), for: .normal)
        self.haveWalletButton.setTitle("I_already_have_wallet".localized(), for: .normal)
        self.continueButton.setTitle("continue".localized(), for: .normal)
        self.termsContentLabel.text = "terms_wallet".localized()
        
        if !showBackView {
            self.backView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func createNewWalletAction(_ sender: UIButton) {
        self.continueButtonView.isHidden = false
    }
    
    @IBAction func importWalletAction(_ sender: UIButton) {
        self.pushViewController(identifier: "MultiCoinWalletControllerID", storyBoardName: "Main")
    }
    
    @IBAction func tickAction(_ sender: UIButton) {
        isSelected = true
        tickButton.setImage(UIImage(named: "Confirm_Tick"), for: .normal)
        tickButton.layer.borderWidth = 0
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        if isSelected {
            let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 128, language: BIP39Language.english)
            let data = mnemonic?.description.components(separatedBy: " ") ?? [""]
            var array = [String]()
            for phrase in data {
                array.append(phrase)
            }
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecurityKeyControllerID") as? SecurityKeyController {
                vc.arr = array
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.popUpView(message: "Please_select_box_to_continue".localized())
        }
    }

}
