//
//  collectionCell.swift


import UIKit

class SecuritykeyCell: UICollectionViewCell {
   
    @IBOutlet weak var securityKeyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.securityKeyLabel.text = "label"
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.6235294118, blue: 0.2117647059, alpha: 1).cgColor
        if Constants.User.isDarkMode {
            self.layer.borderColor = UIColor.init(named: "232325")?.cgColor
        }
    }
    
}
