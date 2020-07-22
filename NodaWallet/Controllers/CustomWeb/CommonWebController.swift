//
//  CommonWebController.swift
//  NodaWallet
//
//  Created by macOsx on 02/04/20.
//  .
//

import UIKit
import WebKit

class CommonWebController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var webTitleLabel: UILabel!
    
    var myTitle = ""
    var webUrl = ""
    
    var isExplorer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webTitleLabel.text = myTitle
        self.closeBttn.setTitle("Cancel".localized(), for: .normal)
        self.loadWebView()
    }
    
    private func loadWebView() {
        if isExplorer {
            if webUrl.count > 0 {
                webView.load(NSURLRequest(url: NSURL(string: webUrl)! as URL) as URLRequest)
            }
        } else {
             webView.loadHTMLString(webUrl, baseURL: nil)
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
