//
//  EmailNotificationsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class EmailNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tblEmailNotifications: UITableView!
    
    var arrEmailNotifications = [AnyObject]()
    var arrEmailNotificationsStatus = [AnyObject]()
    
    var userLoginType : String? = ""
    var userId :String? = ""
    var paramsDic = [String:Any]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrEmailNotifications = ["Email Notifications"] as [AnyObject]
        arrEmailNotificationsStatus =  ["0","0","0","0","0"] as [AnyObject]
        tblEmailNotifications.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // No need for semicolon
        
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        self.tblEmailNotifications.isHidden = true
        getAllSettings()
        
        
    }
    func getAllSettings(){
        
    
            
            paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":userId!]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BUYER_SETTINGS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            
            if success == false
            {
                self.tblEmailNotifications.isHidden = true
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.tblEmailNotifications.isHidden = false
                
                let response = result as! [String : Any]
                let data = response ["data"]as! [String:Any]
                let promotion = data["promotions"]
                self.arrEmailNotificationsStatus[0] = promotion as AnyObject
                let message = data["message"]
                self.arrEmailNotificationsStatus[1] = message as AnyObject
                let reminder = data["reminder"]
                self.arrEmailNotificationsStatus[2] = reminder as AnyObject
                let updates = data["updates"]
                self.arrEmailNotificationsStatus[3] = updates as AnyObject
                let email = data["email"]
                self.arrEmailNotificationsStatus[4] = email as AnyObject
                print("Default \(self.arrEmailNotificationsStatus)")
                
                self.tblEmailNotifications.reloadData()
                
            }
        }
        
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEmailNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")as! HistoryTableViewCell
        cell.lblEmailNotifications.text = String(describing:arrEmailNotifications[indexPath.row])
        cell.btnEmailNotifications.tag = 4
        cell.btnEmailNotifications.addTarget(self, action: #selector(switchTriggered), for: UIControlEvents.valueChanged)
        
        let status = String(describing:arrEmailNotificationsStatus[4])
       
        switch Int(status) {
        case 0:
            cell.btnEmailNotifications.setOn(false, animated: true)
        case 1:
            cell.btnEmailNotifications.setOn(true, animated: true)
            
        default:
            cell.btnEmailNotifications.setOn(false, animated: true)
            
        }
        
        return cell
    }
    @objc func switchTriggered(sender:UISwitch)
    {
        let status = String(describing:arrEmailNotificationsStatus[sender.tag])
        
        switch Int(status) {
        case 0:
            
            arrEmailNotificationsStatus[sender.tag] = "1" as AnyObject
        case 1:
            arrEmailNotificationsStatus[sender.tag] = "0" as AnyObject
            
        default:
            return
        }
        
        updateStatus()
        
        
    }
    func updateStatus() {
        
        let promotions = String(describing:arrEmailNotificationsStatus[0])
        let messages = String(describing:arrEmailNotificationsStatus[1])
        let remainders = String(describing:arrEmailNotificationsStatus[2])
        let updates = String(describing:arrEmailNotificationsStatus[3])
        let email = String(describing:arrEmailNotificationsStatus[4])
        
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":userId!,"promotions":promotions,"message":messages,"reminder":remainders,"updates":updates,"email":email]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BUYER_SETTINGS_UPDATE, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            
            if success == false
            {
                
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.getAllSettings()
                
            }
        }
    }

    @IBAction func btn_back_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
