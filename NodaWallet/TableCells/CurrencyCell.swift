//
//  CurrencyCell.swift
//  NodaWallet
//
//  Created by iOS on 16/03/20.
//  .
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var selectedCurrencyImage: UIImageView!
    @IBOutlet weak var countryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
