//
//  FingerPrintController.swift
//  NodaWallet

import UIKit
import LocalAuthentication

class FingerPrintController: UIViewController {
   
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var passcodebtn: UIButton!
    @IBOutlet weak var fingerView: UIView!
    @IBOutlet weak var fingerPrintLbl1: UILabel!
    @IBOutlet weak var fingerPrintLbl2: UILabel!
    @IBOutlet weak var fingerPrintLbl3: UILabel!
    @IBOutlet weak var fingerPrintLbl4: UILabel!
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backBttn: UIButton!
    
    var isFromSettings = false
    var passcodeStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passcodebtn.setTitle("Using_Passcode".localized(), for: .normal)
        self.fingerPrintLbl1.text = "Using_Passcode".localized()
        self.fingerPrintLbl2.text = "touch_Sign_in".localized()
        self.fingerPrintLbl3.text = "finger_print_content_one".localized()
        self.fingerPrintLbl4.text = "finger_print_content_two".localized()
        
        if isFromSettings {
            self.passcodebtn.isHidden = true
            self.backBttn.isHidden = false
            self.backImage.isHidden = false
        }
        
        self.fingerView.layer.cornerRadius = fingerView.frame.width / 2.0
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.fingerPrintLbl1.theme_textColor = ["#434343", "#FFF"]
        self.fingerPrintLbl2.theme_textColor = ["#434343", "#FFF"]
        self.fingerPrintLbl3.theme_textColor = ["#434343", "#FFF"]
        self.fingerPrintLbl4.theme_textColor = ["#434343", "#FFF"]
        authenticationWithTouchID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func passcodeBtnAct(_ sender: Any) {
       self.presentViewController(identifier: "PasscodeControllerID", storyBoardName: "Main")
    }
    
    @IBAction func fingerPrintBtnAct(_ sender: Any) {
        authenticationWithTouchID()
    }
    
    @IBAction func backtBtnAct(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension FingerPrintController {
    
    func authenticationWithTouchID() {
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if let err = error {
                            
                            switch err._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userCancel.rawValue: break
                                //                                self.notifyUser("Please try again",
                                //                                                err: err.localizedDescription)
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                              //  self.passcodebtn.isHidden = false
                                //                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPinVC") as? LoginPinVC
                                //                                {
                                //                                    self.navigationController?.pushViewController(vc, animated: true)
                                //                                }
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: err.localizedDescription)
                            }
                            
                        } else {
                            let ac = UIAlertController(title: "Authentication Successfull", message: "", preferredStyle: .alert)
                            //                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                                if self.isFromSettings {
                                    UserDefaults.standard.set(true, forKey: Constants.UserDefaultKey.touchID)
                                    UserDefaults.standard.set(self.passcodeStr, forKey: Constants.UserDefaultKey.passcodeLogin)
                                    Constants.User.isTouchID = true
                                    self.navigationController?.popToRootViewController(animated: true)
                                } else {
                                    APPDELEGATE.homepage()
                                }
                            }))
                            self.present(ac, animated: true)
                            //                            self.notifyUser("Authentication Successful",
                            //                                            err: "You now have full access")
                        }
                    }
            })
            
        } else {
            // Device cannot use biometric authentication
            if let err = error {
                if #available(iOS 11.0, *) {
                    switch err.code {
                        
                    case LAError.Code.biometryNotEnrolled.rawValue:
                        notifyUser("User is not enrolled",
                                   err: err.localizedDescription)
                        
                    case LAError.Code.passcodeNotSet.rawValue:
                        notifyUser("A passcode has not been set",
                                   err: err.localizedDescription)
                        
                        
                    case LAError.Code.biometryNotAvailable.rawValue:
                        notifyUser("Biometric authentication not available",
                                   err: err.localizedDescription)
                    default:
                        notifyUser("Unknown error",
                                   err: err.localizedDescription)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
}
