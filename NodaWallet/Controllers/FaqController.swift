//
//  FaqController.swift
//  NodaWallet
//
//  Created by macOsx on 08/04/20.
//  .
//

import UIKit

class FaqController: UIViewController {
    
   @IBOutlet weak var navigationView: UIView!
   @IBOutlet weak var navTitle: UILabel!
   @IBOutlet weak var tableView: UITableView!

    var arrayHeader = [Int]()
    var faqArray = [[String: AnyObject]]()
    
    var selectedLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "faq".localized()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.tableView.theme_backgroundColor = ["#FFF", "#000"]
        if let language = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.AppLanguage) as? String {
            self.selectedLanguage = language
        }
        setUpTableView()
    }
    
    private func setUpTableView() {
         tableView.delegate = self
         tableView.dataSource = self
         let nib = UINib.init(nibName: "FaqTableCell", bundle: nil)
         self.tableView.register(nib, forCellReuseIdentifier: "FaqTableCell")
         tableView.allowsSelection = false
         tableView.separatorStyle = .none
        // let headernib = UINib.init(nibName: "FaqHeaderView", bundle: nil)
        // self.faqTableView.register(headernib, forHeaderFooterViewReuseIdentifier: "FaqHeaderView")
         tableView.tableFooterView = UIView()
         //faqTableView.reloadData()
         self.getFaqData()
    }
    
    private func getFaqData() {
        DataManager.getFAQRequest{ (success, msg, data, error) in
            if success {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data ?? Data.init(), options: [])
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        return
                    }
                    if let faqArr = jsonArray["message"] as? [[String: AnyObject]] {
                        self.faqArray = faqArr
                    }
                    if self.faqArray.count == 0 {
                        self.tableView.setEmptyMessage("no_records_found".localized())
                    } else {
                        self.tableView.restore()
                    }
                    for _ in self.faqArray {
                        self.arrayHeader.append(0)
                    }
                    self.tableView.reloadData()
                } catch(let error) {
                    print(error)
                }
            } else {
                self.popUpView(message: msg)
            }
        }
    }
}

extension FaqController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func tapSection(sender: UIButton) {
        arrayHeader[sender.tag] = arrayHeader[sender.tag] == 1 ? 0 : 1
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayHeader[indexPath.row] == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableCell", for: indexPath) as! FaqTableCell
            cell.faqHiddenAction.tag = indexPath.row
            cell.faqHiddenAction.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
            let contentData = faqArray[indexPath.row]
            let question = contentData["question"] as? String
            let answer = contentData["answer"] as? String
            
            let russianQuestion = contentData["question_rs"] as? String
            let russianAnswer = contentData["answer_rs"] as? String
            
            if selectedLanguage == "English" {
                cell.questionLabel.text = question
                cell.answerLabel.text = answer?.htmlToAttributedString?.string
            } else {
                cell.questionLabel.text = russianQuestion
                cell.answerLabel.text = russianAnswer?.htmlToAttributedString?.string
            }
            
            cell.HiddenView.isHidden = false
            cell.arithmaticLabel.text = "-"
            cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
            cell.theme_backgroundColor = ["#FFF", "#000"]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableCell", for: indexPath) as! FaqTableCell
            cell.faqHiddenAction.tag = indexPath.row
            cell.faqHiddenAction.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
            cell.HiddenView.isHidden = true
            
            let contentData = faqArray[indexPath.row]
            let question = contentData["question"] as? String
            let answer = contentData["answer"] as? String
            
            let russianQuestion = contentData["question_rs"] as? String
            let russianAnswer = contentData["answer_rs"] as? String
            
            if selectedLanguage == "English" {
                cell.questionLabel.text = question
                cell.answerLabel.text = answer?.htmlToAttributedString?.string
            } else {
                cell.questionLabel.text = russianQuestion
                cell.answerLabel.text = russianAnswer?.htmlToAttributedString?.string
            }
            
            cell.arithmaticLabel.text = "+"
            cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
            cell.theme_backgroundColor = ["#FFF", "#000"]
            return cell
        }
       // return UITableViewCell.init()
    }
}
