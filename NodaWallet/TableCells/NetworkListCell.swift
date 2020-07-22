//
//  NetworkListCell.swift
//  NodaWallet
//
//  Created by iOS on 13/03/20.
//  .
//

import UIKit

class NetworkListCell: UITableViewCell {

    @IBOutlet weak var coinimageView: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
