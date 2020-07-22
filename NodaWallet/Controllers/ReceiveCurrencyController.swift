//
//  ReceiveCurrencyController.swift
//  NodaWallet

import UIKit

class ReceiveCurrencyController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var addressTextLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
     @IBOutlet weak var copyLabel: UILabel!
     @IBOutlet weak var setAmountLabel: UILabel!
     @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var shareImage: UIImageView!
    
    @IBOutlet weak var nodaWalletLabel: UILabel!
        
    var currencyList:CurrencyListDatas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAppColor()
        if currencyList.currencyName == "Bitcoin" {
            self.loadAddressDetails(selectedAddress: currencyList.address)
        } else if currencyList.currencyName == "Litecoin" {
            self.loadAddressDetails(selectedAddress: currencyList.address)
        } else if currencyList.currencyName == "Binance" {
            self.loadAddressDetails(selectedAddress: currencyList.address)
        } else if currencyList.type == "BEP2" {
            var address = ""
            let currencyData = LocalDBManager.sharedInstance.getCurrencyListDetailsFromDB()
            for data in currencyData {
                if data.walletID == SelectedWalletDetails.walletID {
                    if data.symbol == "BNB" && data.isToken == "currency" {
                        address = data.address
                    }
                }
            }
            self.loadAddressDetails(selectedAddress: address)
        } else {
            self.loadAddressDetails(selectedAddress: SelectedWalletDetails.walletAddress)
        }
    }
    
    private func updateAppColor() {
        shareImage.image = shareImage.image?.withRenderingMode(.alwaysTemplate)
        shareImage.tintColor = UIColor.white
        
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.backgroundImageView.theme_image = ["Light_Background", "Dark_Background"]
        self.receiveView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        self.addressTextLabel.theme_textColor = ["#000", "#FFF"]
        self.copyLabel.theme_textColor = ["#000", "#FFF"]
        self.setAmountLabel.theme_textColor = ["#000", "#FFF"]
        self.shareLabel.theme_textColor = ["#000", "#FFF"]
        self.nodaWalletLabel.theme_textColor = ["#000", "#FFF"]
        
        self.navLabel.text = "Receive".localized()
        self.copyLabel.text = "Copy".localized()
        self.setAmountLabel.text = "set_amount".localized()
        self.shareLabel.text = "Share".localized()
    }
    
    private func loadAddressDetails(selectedAddress: String) {
        let address = generateQRCode(from: selectedAddress)
        addressTextLabel.text = selectedAddress
        qrCodeImageView.image = address
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
    
    @IBAction func copyAction(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = addressTextLabel.text ?? ""
        self.popUpView(message: "copied_to_clipboard".localized())
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let firstActivityItem = addressTextLabel.text ?? ""

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = (sender)

        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]

        self.present(activityViewController, animated: true, completion: nil)
    }

}
