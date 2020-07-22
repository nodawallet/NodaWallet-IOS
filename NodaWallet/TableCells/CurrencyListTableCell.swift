//
//  CurrencyListTableCell.swift
//  NodaWallet
//

import UIKit

class CurrencyListTableCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencybalanceLabel: UILabel!
    @IBOutlet weak var currencyPercentLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var currencyDollarLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
