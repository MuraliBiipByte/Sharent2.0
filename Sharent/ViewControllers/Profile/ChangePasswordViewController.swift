//
//  ChangePasswordViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var txtCurrent_Password: UITextField!
    @IBOutlet weak var txt_New_Password: UITextField!
    @IBOutlet weak var txt_ReEnter_Password: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Save_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)
        if (self.txtCurrent_Password.text?.isEmpty)!
        {
            self.showAlert(message: "Please Enter Current Password")
            return
        }
        if (self.txt_New_Password.text?.isEmpty)! {
            self.showAlert(message: "Please Enter New Password")
            return
        }
        if (self.txt_ReEnter_Password.text?.isEmpty)! {
            self.showAlert(message: "Please Re Enter Password")
            return
        }
        
      if !(self.txt_New_Password.text! == self.txt_ReEnter_Password.text!)
            {
                self.showAlert(message: "New Password and Re Enter Password Should be Same")
                return
            }
        if self.txtCurrent_Password.text == self.txt_New_Password.text
        {
            self.showAlert(message: "Current Password and New Password Should not be Same")
            return
        }
        
        if ((self.txt_New_Password.text?.count)! <= 5) || ((self.txt_ReEnter_Password.text?.count)! <= 5)
        {
            self.showAlert(message: "New Password and Re Enter Password Length Should be greate than 5")
            return
        }
        self.view.StartLoading()
        let paramsDist = ["api_key_data":WebServices.API_KEY,"user_id":User.userID!,"user_type":User.usertype!,"telcode":User.telcode!,"phone":User.phone!,"password":self.txtCurrent_Password.text!,"new_password":self.txt_New_Password.text!,"new_confirm_password":self.txt_ReEnter_Password.text!] as [String : Any]
        print(paramsDist)
        ApiManager().postRequest(service: WebServices.CHANGE_PASSWORD, params: paramsDist)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!, selector:#selector(self.backVc))
            }
        }
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
