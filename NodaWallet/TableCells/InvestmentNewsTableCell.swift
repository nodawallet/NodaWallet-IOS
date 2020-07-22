//
//  InvestmentNewsTableCell.swift
//  NodaWallet
//
//  Created by macOsx on 28/04/20.
//  .
//

import UIKit

class InvestmentNewsTableCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rightArrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightArrowImage.updateTintColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
