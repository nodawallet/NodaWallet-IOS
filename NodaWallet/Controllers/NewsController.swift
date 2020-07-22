//
//  NewsController.swift
//  NodaWallet
//
//  Created by macOsx on 08/04/20.
//  .
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    var dataArr = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateLocalisedAndColor()
        self.showNewsDetails()
    }
    
    private func updateLocalisedAndColor() {
        self.newsTitle.text = "news".localized()
        self.newsTableView.theme_backgroundColor = ["#FFF", "#000"]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
    }
    
    private func showNewsDetails() {
        DataManager.getNewsData { (success, msg, responseArr, data, error) in
            if success {
                self.dataArr = responseArr
                self.newsTableView.reloadData()
            } else {
                self.popUpView(message: msg)
            }
        }
    }

}

extension NewsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCellID", for: indexPath) as? NewsTableCell {
            cell.newsTitleLabel.theme_textColor = ["#000", "#FFF"]
            cell.contentView.theme_backgroundColor = ["#FFF", "#000"]

            let contentData = dataArr[indexPath.row]
            cell.newsImageView.sd_setImage(with: URL(string: contentData["image"] as? String ?? ""), completed: nil)
            cell.newsTitleLabel.text = contentData["heading"] as? String ?? ""
            if let description = contentData["content"] as? String {
                cell.newsContentLabel.text = description.htmlToString
            }
            cell.calendarImageView.updateTintColor()
            let date = contentData["date"] as? String ?? ""
            let time = contentData["time"] as? String ?? ""
            cell.dateLabel.text = date + " " + time
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
