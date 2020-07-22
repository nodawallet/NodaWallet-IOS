//
//  FilterCurrencyListTableCell.swift
//  NodaWallet
//
//  Created by macOsx on 17/06/20.
//  .
//

import UIKit

class FilterCurrencyListTableCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyCoin: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
