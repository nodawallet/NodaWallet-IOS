//
//  ExportPrivateKeyController.swift
//  NodaWallet
//
//  Created by macOsx on 03/04/20.
//  .
//

import UIKit

class ExportPrivateKeyController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var contentOnelbl: UILabel!
    @IBOutlet weak var contentTwoLbl: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    var privateKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        
        self.navTitle.text = "qrcode".localized()
        self.contentOnelbl.text = "private_key_content_one".localized()
        self.contentTwoLbl.text = "private_key_content_one".localized()
        self.qrCodeImage.image = self.generateQRCode(from: privateKey)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = privateKey
        self.popUpView(message: "copied_to_clipboard".localized())
    }

}
