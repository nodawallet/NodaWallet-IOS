//
//  AboutViewController.swift
//  NodaWallet
//
//  Created by macOsx on 13/05/20.
//  .
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var termsImage: UIImageView!
    @IBOutlet weak var privacyImage: UIImageView!
    
    @IBOutlet weak var rightArrowImg1: UIImageView!
    @IBOutlet weak var rightArrowImg2: UIImageView!
    @IBOutlet weak var rightArrowImg4: UIImageView!
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var aboutTitle: UILabel!
    @IBOutlet weak var privacyPolicyTitle: UILabel!
    @IBOutlet weak var termsAndConTitle: UILabel!
    
    var selectedLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage.theme_image = ["Light_Background", "Dark_Background"]
        aboutImage.theme_image = ["About_Light", "About_Dark"]
        termsImage.theme_image = ["Terms_Light", "Terms_Dark"]
        privacyImage.theme_image = ["Privacy_Light", "Privacy_Dark"]
        
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.subView.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        
        rightArrowImg1.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg2.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        rightArrowImg4.theme_image = ["Right_Arrow_Light", "Right_Arrow_Dark"]
        
        aboutTitle.theme_textColor = ["#000", "#FFF"]
        privacyPolicyTitle.theme_textColor = ["#000", "#FFF"]
        termsAndConTitle.theme_textColor = ["#000", "#FFF"]
        
        self.navTitle.text = "about".localized()
        self.aboutTitle.text = "about".localized()
        self.privacyPolicyTitle.text = "privacy_policy".localized()
        self.termsAndConTitle.text = "terms_and_conditions".localized()
        
        if let language = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.AppLanguage) as? String {
            self.selectedLanguage = language
        }
    }
    
    @IBAction func aboutAct(_ sender: Any) {
        self.getAboutAPI(method: "aboutus", vcTitle: "About")
    }
    
    @IBAction func termsAct(_ sender: Any) {
        self.getAboutAPI(method: "termsandconditions", vcTitle: "Terms And Condition")
    }
    
    @IBAction func privacyPolicyAct(_ sender: Any) {
        self.getAboutAPI(method: "privacypolicy", vcTitle: "Privacy Policy")
    }
    
    private func getAboutAPI(method: String, vcTitle: String) {
        let param = ["page": method, "method":"cms_page"] as [String: AnyObject]
        DataManager.getAboutAPI(parameter: param) { (success, content, data, error) in
            if success {
                 if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonWebControllerID") as? CommonWebController {
                     if self.selectedLanguage == "English" {
                        vc.webUrl = content[0]["description"] as? String ?? ""
                     } else {
                        vc.webUrl = content[0]["description_rs"] as? String ?? ""
                     }
                     vc.myTitle = vcTitle
                     self.present(vc, animated: true, completion: nil)
                 }
            } else {
                self.popUpView(message: Constants.Message.errorMsg)
            }
        }
    }

}
