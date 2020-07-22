//
//  SmartContractAddressCell.swift


import UIKit

class SmartContractAddressCell: UITableViewCell {

    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var smartContarctTitleLabel: UILabel!
    @IBOutlet weak var smartContractAddressLabel: UILabel!
    
    @IBOutlet weak var coinValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
