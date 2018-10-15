//
//  PushNotificationsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class PushNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var tblPushNotifications: UITableView!
    
    var arrPushNotifications = [AnyObject]()
    var arrPushNotificationsStatus = [AnyObject]()

    var userLoginType : String = ""
    var userId :String? = ""
    var paramsDic = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        arrPushNotifications = ["Promotion","Message","Reminder","Update","Email"] as [AnyObject]
        arrPushNotificationsStatus = ["0","0","0","0","0"] as [AnyObject]
        tblPushNotifications.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // No need for semicolon
        
        userLoginType = (UserDefaults.standard.value(forKey: "user_type")as? String)!
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
         self.tblPushNotifications.isHidden = true
        getAllSettings()
        
        
    }
    func getAllSettings(){
        

            
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":userId!,"user_type":userLoginType]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BUYER_SETTINGS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            
            if success == false
            {
                self.tblPushNotifications.isHidden = true
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.tblPushNotifications.isHidden = false
                
                let response = result as! [String : Any]
                let data = response ["data"]as! [String:Any]
                
                print(data)
                let promotion = data["promotions"]
                self.arrPushNotificationsStatus[0] = promotion as AnyObject
                let message = data["message"]
                self.arrPushNotificationsStatus[1] = message as AnyObject
                let reminder = data["reminder"]
                self.arrPushNotificationsStatus[2] = reminder as AnyObject
                let updates = data["updates"]
                self.arrPushNotificationsStatus[3] = updates as AnyObject
                let email = data["email"]
                self.arrPushNotificationsStatus[4] = email as AnyObject
                print("Default \(self.arrPushNotificationsStatus)")

                self.tblPushNotifications.reloadData()
                
            }
        }
        
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPushNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")as! HistoryTableViewCell
        cell.lblPushNotifications.text = String(describing:arrPushNotifications[indexPath.row])
        cell.btnPushNotifications.tag = indexPath.row
        cell.btnPushNotifications.addTarget(self, action: #selector(switchTriggered), for: UIControlEvents.valueChanged)
        cell.btnPushNotifications.onTintColor = Constants.APP_COLOR
        let status = String(describing:arrPushNotificationsStatus[indexPath.row])
        
        print(status)
        
        switch Int(status) {
        case 0:
            cell.btnPushNotifications.setOn(false, animated: true)
        case 1:
            cell.btnPushNotifications.setOn(true, animated: true)
       
        default:
            cell.btnPushNotifications.setOn(false, animated: true)

        }
        
        return cell
    }
    @objc func switchTriggered(sender:UISwitch)
    {
        let status = String(describing:arrPushNotificationsStatus[sender.tag])
        
        print(status)
        
        switch Int(status) {
        case 0:
            
            arrPushNotificationsStatus[sender.tag] = "1" as AnyObject
        case 1:
            arrPushNotificationsStatus[sender.tag] = "0" as AnyObject

        default:
            return
        }
        
        print("Changed\(self.arrPushNotificationsStatus)")
        updateStatus()
        
        
    }
    func updateStatus() {
        
        let promotions = String(describing:arrPushNotificationsStatus[0])
        let messages = String(describing:arrPushNotificationsStatus[1])
        let remainders = String(describing:arrPushNotificationsStatus[2])
        let updates = String(describing:arrPushNotificationsStatus[3])
        let email = String(describing:arrPushNotificationsStatus[4])
        
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":userId!,"user_type":userLoginType,"promotions":promotions,"message":messages,"reminder":remainders,"updates":updates,"email":email]
        
        print(paramsDic)
        
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
