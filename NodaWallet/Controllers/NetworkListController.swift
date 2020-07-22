//
//  NetworkListController.swift
//  NodaWallet
//
//  Created by iOS on 13/03/20.
//  .
//

import UIKit

class NetworkListController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var networkListTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
        self.view.theme_backgroundColor = ["#FFF", "#000"]
        self.networkListTableView.theme_backgroundColor = ["#FFF", "#000"]
        networkListTableView.delegate = self
        networkListTableView.dataSource = self
        networkListTableView.register(UINib(nibName: "NetworkListCell", bundle: nil), forCellReuseIdentifier: "NetworkListCellID")
        networkListTableView.tableFooterView = UIView()
    }
    
}

extension NetworkListController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkListCellID", for: indexPath) as! NetworkListCell
        cell.contentView.theme_backgroundColor = ["#FFF", "#000"]
        cell.coinNameLabel.theme_textColor = ["#000", "#FFF"]
        return cell
    }
    
    
}
