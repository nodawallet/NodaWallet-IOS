//
//  FaqTableCell.swift

import UIKit

class FaqTableCell: UITableViewCell {

    @IBOutlet weak var faqHiddenAction: UIButton!
    @IBOutlet weak var HiddenView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTitleLabel: UILabel!
    @IBOutlet weak var arithmaticLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
