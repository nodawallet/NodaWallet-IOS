//
//  TokenListTableCell.swift
//  NodaWallet
//

import UIKit

protocol TokenListTableCellDelegate {
    func currencyEnabled(enable: Bool, cell: TokenListTableCell)
}

class TokenListTableCell: UITableViewCell {
    
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyPriceLabel: UILabel!
    @IBOutlet weak var currencyPercentLabel: UILabel!
    @IBOutlet weak var balanceIntoMPLabel: UILabel!
    @IBOutlet weak var tokenListState: UISwitch!
   
    var delegate:TokenListTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func enableAction(_ sender: Any) {
        if tokenListState.isOn {
            delegate?.currencyEnabled(enable: true, cell: self)
        } else {
            delegate?.currencyEnabled(enable: false, cell: self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
