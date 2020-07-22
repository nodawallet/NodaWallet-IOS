//
//  UserSelectedCollectionCell.swift
//  NodaWallet
//


import UIKit

class UserSelectedCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var securityKeyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.securityKeyLabel.text = "label"
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.9653922915, green: 0.6228087544, blue: 0.213332057, alpha: 1).cgColor
        if Constants.User.isDarkMode {
            self.layer.borderColor = UIColor.init(named: "232325")?.cgColor
        }
    }
}
