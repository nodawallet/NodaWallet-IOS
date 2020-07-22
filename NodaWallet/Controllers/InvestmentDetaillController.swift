//
//  InvestmentDetaillController.swift
//  NodaWallet
//
//  Created by macOsx on 08/05/20.
//  .
//

import UIKit

class InvestmentDetaillController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var calendarIamge: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var newsImageStr = ""
    var newsTitle = ""
    var newsDate = ""
    var newsDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarIamge.updateTintColor()
        self.newsImage.loadImage(string: newsImageStr)
        self.newsTitleLabel.text = newsTitle
        self.dateLabel.text = newsDate
        self.descriptionTextView.text = newsDescription.htmlToString
        self.updateAppColor()
    }
    
    private func updateAppColor() {
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.descriptionTextView.theme_backgroundColor = ["#FFF", "#000"]
        self.newsTitleLabel.theme_textColor = ["#000", "#FFF"]
        self.dateLabel.theme_textColor = ["#000", "#FFF"]
        self.descriptionTextView.theme_textColor = ["#000", "#FFF"]
    }

}
