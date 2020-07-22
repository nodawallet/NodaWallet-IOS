//
//  PasscodeController.swift
//  NodaWallet

import UIKit

class PasscodeController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet weak var enterCodeLabel: UILabel!
    @IBOutlet weak var loginMsgLabel: UILabel!
    
    @IBOutlet weak var codeStackView: UIStackView!
    
    @IBOutlet weak var fingerPrintLoginBttn: UIButton!
    @IBOutlet weak var cancelBttn: UIButton!
    
    var passcodeInt = [Int]()
    var tappedTimes = 0
    var isFromSettings = false
    var isReEnterCode = false
    var checkPasscodeStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterCodeLabel.text = "Enter_code".localized()
        self.loginMsgLabel.text = "code_required_content".localized()
        self.cancelBttn.setTitle("Cancel".localized(), for: .normal)
        self.fingerPrintLoginBttn.setTitle("finger_print_login".localized(), for: .normal)
        
        if isFromSettings {
            self.fingerPrintLoginBttn.isHidden = true
        } else {
            self.cancelBttn.isHidden = true
        }
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.enterCodeLabel.theme_textColor = ["#000", "#FFF"]
        self.loginMsgLabel.theme_textColor = ["#000", "#FFF"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func keyboardButtonAction(_ sender: UIButton) {
        self.passcodeInt.append(sender.tag)
        self.tappedTimes = self.tappedTimes + 1
        if self.tappedTimes == 1 {
            self.firstView.backgroundColor = Constants.AppColors.App_Orange_Color
        }
        if self.tappedTimes == 2 {
            self.secondView.backgroundColor = Constants.AppColors.App_Orange_Color
        }
        if self.tappedTimes == 3 {
            self.thirdView.backgroundColor = Constants.AppColors.App_Orange_Color
        }
        if self.tappedTimes == 4 {
            self.fourthView.backgroundColor = Constants.AppColors.App_Orange_Color
            if passcodeInt.count == 4 {
                if isFromSettings {
                    if !isReEnterCode {
                        self.loginMsgLabel.text = "enter_code_again".localized()
                        self.isReEnterCode = true
                        self.checkPasscodeStr = "\(passcodeInt[0])" + "\(passcodeInt[1])" + "\(passcodeInt[2])" + "\(passcodeInt[3])"
                        self.refereshPassCode(isShake: false)
                    } else {
                        if self.checkPasscodeStr == "\(passcodeInt[0])" + "\(passcodeInt[1])" + "\(passcodeInt[2])" + "\(passcodeInt[3])" {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FingerPrintControllerID") as? FingerPrintController {
                                vc.isFromSettings = true
                                vc.passcodeStr = self.checkPasscodeStr
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else {
                            self.refereshPassCode(isShake: true)
                        }
                    }
                } else {
                    if let passcodeStr = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.passcodeLogin) as? String {
                        if "\(passcodeInt[0])" + "\(passcodeInt[1])" + "\(passcodeInt[2])" + "\(passcodeInt[3])" == passcodeStr {
                            APPDELEGATE.homepage()
                        } else {
                            refereshPassCode(isShake: true)
                        }
                    }
                }
            }
        }
      
    }
    
    private func refereshPassCode(isShake:Bool!) {
        if isShake {
            codeStackView.shake()
        }
        firstView.backgroundColor = .white
        secondView.backgroundColor = .white
        thirdView.backgroundColor = .white
        fourthView.backgroundColor = .white
        tappedTimes = 0
        passcodeInt.removeAll()
    }
    
    @IBAction func keyboardBackAction(_ sender: UIButton) {
        if tappedTimes == 0 {
            return
        }
        if tappedTimes == 1 {
            self.passcodeInt.remove(at: 0)
            tappedTimes = tappedTimes - 1
            self.firstView.backgroundColor = .white
        }
        if tappedTimes == 2 {
            self.passcodeInt.remove(at: 1)
            tappedTimes = tappedTimes - 1
            self.secondView.backgroundColor = .white
        }
        if tappedTimes == 3 {
            self.passcodeInt.remove(at: 2)
            tappedTimes = tappedTimes - 1
            self.thirdView.backgroundColor = .white
        }
    }
    
    @IBAction func fingerPrintAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension UIStackView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
