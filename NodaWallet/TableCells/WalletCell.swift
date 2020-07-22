//
//  walletCell.swift


import UIKit

protocol WalletCellDelegate {
    func infoCliced(cell: UITableViewCell)
}

class WalletCell: UITableViewCell {

    @IBOutlet weak var walletIconImage: UIImageView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var mainWalletLabel: UILabel!
    @IBOutlet weak var multiCoinWallet: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    
    var delegate:WalletCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func infoAction(_ sender: UIButton) {
        delegate?.infoCliced(cell: self)
    }
    
    
}
