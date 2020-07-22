//
//  CollectionController.swift
//  NodaWallet
//

import UIKit
import XLPagerTabStrip

class CollectionController: UIViewController {

    var itemInfo: IndicatorInfo = "Collection"
    var dataArr = [[String: AnyObject]]()
    
    var searchArr = [[String : Any]]()
    var isSearched = false
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.staticView.collectionSlideView = slideView
       // slideView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        self.searchTF.delegate = self
        self.searchTF.placeholder = "Search".localized()
        self.view.theme_backgroundColor = ["#FFF", Constants.NavigationColor.darkMode]
        self.searchView.layer.cornerRadius = 4.0
        self.searchView.theme_backgroundColor = ["#EBEBEB", "#000"]
        self.searchView.theme_alpha = [0.5, 0.5]
        self.searchTF.theme_textColor = ["#000", "#FFF"]
        
        self.newsTableView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]
        self.collectionView.theme_backgroundColor = ["#EBE9E7", Constants.BackgroundColor.darkMode]
        self.slideView.theme_backgroundColor = ["#EBE9E8", "#373431"]
        //self.refreshButton.theme_setTitleColor(["#000", "#FFF"], forState: .normal)
        if Constants.User.isDarkMode {
            self.collectionView.layer.shadowColor = UIColor.darkGray.cgColor
            self.newsTableView.separatorColor = .white
            self.searchTF.placeHolderColor = .white
        } else {
            self.collectionView.layer.shadowColor = UIColor.lightGray.cgColor
            self.searchTF.placeHolderColor = .black
        }
        self.newsTableView.tableFooterView = UIView()
        
        self.showNewsDetails()
    }
    
    private func showNewsDetails() {
        DataManager.getNewsData { (success, msg, responseArr, data, error) in
            if success {
                self.dataArr = responseArr.reversed()
                if self.dataArr.count == 0 {
                    self.newsTableView.setEmptyMessage("no_records_found".localized())
                }
                self.newsTableView.reloadData()
            } else {
                self.popUpView(message: msg)
            }
        }
    }

}

extension CollectionController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Collections".localized())
    }
}

extension CollectionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched {
            return searchArr.count
        }
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentNewsTableCellID", for: indexPath) as? InvestmentNewsTableCell {
            cell.newsTitleLabel.theme_textColor = ["#000", "#FFF"]
            cell.dateLabel.theme_textColor = ["#000", "#FFF"]
            cell.contentView.theme_backgroundColor = ["#FFF", Constants.BackgroundColor.darkMode]

            var contentData = [String: Any]()
            
            if isSearched {
                contentData = searchArr[indexPath.row]
            } else {
                contentData = dataArr[indexPath.row]
            }
            
            cell.newsImageView.sd_setImage(with: URL(string: contentData["image"] as? String ?? ""), completed: nil)
            cell.newsTitleLabel.text = contentData["heading"] as? String ?? ""
            
            cell.calendarImageView.updateTintColor()
            let date = contentData["date"] as? String ?? ""
            let time = contentData["time"] as? String ?? ""
            cell.dateLabel.text = date + " " + time
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contentData = [String: Any]()
        if isSearched {
            contentData = searchArr[indexPath.row]
        } else {
            contentData = dataArr[indexPath.row]
        }
        if let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "InvestmentDetaillControllerID") as? InvestmentDetaillController {
            let date = contentData["date"] as? String ?? ""
            let time = contentData["time"] as? String ?? ""
            detailVc.newsImageStr = contentData["image"] as? String ?? ""
            detailVc.newsTitle = contentData["heading"] as? String ?? ""
            detailVc.newsDate = date + " " + time
            detailVc.newsDescription = contentData["content"] as? String ?? ""
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}

extension CollectionController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTF {
            if searchTF.text!.isEmpty {
                self.isSearched = false
                self.newsTableView.reloadData()
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var filterArr = [[String: Any]]()
        filterArr.removeAll()
        for data in dataArr {
            let heading = data["heading"] as? String ?? ""
            if heading.lowercased().contains(searchTF.text ?? "") {
                filterArr.append(data)
            }
        }
        if filterArr.count > 0 {
            searchArr = filterArr
            isSearched = true
        }
        self.newsTableView.reloadData()
        return true
    }
}
