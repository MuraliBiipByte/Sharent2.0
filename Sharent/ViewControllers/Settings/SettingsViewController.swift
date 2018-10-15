//
//  SettingsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    var arrSettings = [String]()
    

    @IBOutlet weak var tblSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
arrSettings = ["Push Notification","Email Notification"]
        
        tblSettings.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")as! HistoryTableViewCell
        cell.lblSettings.text = arrSettings[indexPath.row]
        
        return cell
    }
//    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        switch indexPath.row {
//        case 0:
//            let linkVC = storyboard?.instantiateViewController(withIdentifier: "LinkAccountsViewController")as! LinkAccountsViewController
//            self.navigationController?.pushViewController(linkVC, animated: true)
        case 0:
            let pushVC = storyboard?.instantiateViewController(withIdentifier: "PushNotificationsViewController")as! PushNotificationsViewController
            self.navigationController?.pushViewController(pushVC, animated: true)
        case 1:
            let emailVC = storyboard?.instantiateViewController(withIdentifier: "EmailNotificationsViewController")as! EmailNotificationsViewController
            self.navigationController?.pushViewController(emailVC, animated: true)
        default:
            return
        }
        
    }
    
    @IBAction func btn_Menu_Tapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations:{
            self.sideMenuController?.leftViewWidth = 280
            self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
        })
    }
    
}
