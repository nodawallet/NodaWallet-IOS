//
//  ExchangeCell.swift
//  NodaWallet
//
//  Created by iOS on 12/03/20.
//  .
//

import UIKit

class ExchangeCell: UITableViewCell {

    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var pairContentLabel: UILabel!
    @IBOutlet weak var sendAmountLabel: UILabel!
    @IBOutlet weak var sendAmountContentLabel: UILabel!
    @IBOutlet weak var receiveAmountLabel: UILabel!
    @IBOutlet weak var receiveAmountContentLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusContentLabel: UILabel!
    @IBOutlet weak var feesContentLabel: UILabel!
    @IBOutlet weak var hashTitleLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var semiColonLblOne: UILabel!
    @IBOutlet weak var semiColonLblTwo: UILabel!
    @IBOutlet weak var semiColonLblThree: UILabel!
    @IBOutlet weak var semiColonLblFour: UILabel!
    @IBOutlet weak var semiColonLblFive: UILabel!
    @IBOutlet weak var semiColonLblSix: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
