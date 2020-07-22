//
//  SecurityKeyController.swift
//  NodaWallet

import UIKit

class SecurityKeyController: UIViewController {
    
    var arr = [String]()
    
    @IBOutlet weak var navigationiew: UIView!
    @IBOutlet weak var secretKeyTitleLabel: UILabel!
    @IBOutlet weak var secretKeyTitleContentLabel: UILabel!
    @IBOutlet weak var securityKeyCollectionView: UICollectionView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var infoContentLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var furtherButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phraseCollectionViewHeight: NSLayoutConstraint!
    
    var isFromSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromSettings {
            self.backImage.isHidden = true
            self.backButton.isHidden = true
        }
        if isFromSettings {
            self.furtherButton.isHidden = true
        }
        securityKeyCollectionView.delegate = self
        securityKeyCollectionView.dataSource = self
        self.securityKeyCollectionView.layoutIfNeeded()
        self.updateAppColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func updateAppColor() {
        self.contentView.theme_backgroundColor = ["#FFF", "#000"]
        self.securityKeyCollectionView.theme_backgroundColor = ["#FFF", "#000"]
        self.navigationiew.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.infoView.theme_backgroundColor = ["#E5E5E5", "#161616"]
        self.infoContentLabel.theme_textColor = ["#000", "#FFF"]
        
        self.secretKeyTitleLabel.theme_textColor = [Constants.NavigationColor.lightMode, "#FFF"]
        self.secretKeyTitleContentLabel.theme_textColor = ["#555555", "#555555"]
        
        self.secretKeyTitleLabel.text = "Write_down_the_secret_phrase".localized()
        self.secretKeyTitleContentLabel.text = "correct_order_content".localized()
        self.infoContentLabel.text = "Never_pass_the_phrase_restoring_to_anyone_keeping_her_reliable".localized()
        self.copyButton.setTitle("Copy".localized(), for: .normal)
        self.furtherButton.setTitle("Further".localized(), for: .normal)
        
        self.phraseCollectionViewHeight.constant = self.securityKeyCollectionView.contentSize.height + 10
    }
    
    @IBAction func copyAct(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        let arrayStr = "\(arr[0]) " + "\(arr[1]) " + "\(arr[2]) " + "\(arr[3]) " + "\(arr[4]) " + "\(arr[5]) " + "\(arr[6]) " + "\(arr[7]) " + "\(arr[8]) " + "\(arr[9]) " + "\(arr[10]) " + "\(arr[11])"
        pasteboard.string = arrayStr
        self.popUpView(message: "copied_to_clipboard".localized())
    }
    
    @IBAction func furtherAct(_ sender: UIButton) {
        if let nimonicVc = self.storyboard?.instantiateViewController(withIdentifier: "NimonicPhraseControllerID") as? NimonicPhraseController {
            nimonicVc.providedForUserArr = arr
            nimonicVc.userViewArr = arr
            self.navigationController?.pushViewController(nimonicVc, animated: true)
        }
    }
}

extension SecurityKeyController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecuritykeyCell", for: indexPath) as! SecuritykeyCell
        cell.contentView.theme_backgroundColor = ["#EAB671", "#2D2D2D"]
        cell.securityKeyLabel.theme_textColor = ["#FFF", "#FFF"]
        cell.securityKeyLabel.text = self.arr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.arr[indexPath.row]
        
        var cellWidth:CGFloat = 0.0
        let device = "UIDevice.modelName"
        if device.contains("iPad") {
            cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 30.0
        } else {
            cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        }
        return CGSize(width: cellWidth, height: 30.0)
    }
}

