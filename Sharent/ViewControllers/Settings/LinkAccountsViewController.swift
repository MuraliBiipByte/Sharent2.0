//
//  LinkAccountsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class LinkAccountsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 

    @IBOutlet weak var tblLinkAccount: UITableView!
    var arrAccounts = [String]()
    var arrAccountimages = [UIImage]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrAccounts = ["Facebook","google"]
        arrAccountimages = [#imageLiteral(resourceName: "facebook"),#imageLiteral(resourceName: "gmail")]
        
        tblLinkAccount.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  arrAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")as! HistoryTableViewCell
        cell.lblLinkAccount.text = arrAccounts[indexPath.row]
        cell.imgLinkAccount.image = arrAccountimages[indexPath.row]
        
        return cell
    }
    
    @IBAction func btn_back_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
