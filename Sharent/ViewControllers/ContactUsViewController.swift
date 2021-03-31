//
//  ContactUsViewController.swift
//  Sharent
//
//  Created by Biipbyte on 24/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController
{
    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPhone:UITextField!
    @IBOutlet weak var txtViewMessage:UITextView!
    
    
    var paramsDIc = [String:Any]()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.title = "CONTACT US"
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func btn_send_tapped()
    {
        self.view.endEditing(true)
        
        if (txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter name")
            self.txtName.resignFirstResponder()
            return
        }
        if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter email")
            self.txtEmail .resignFirstResponder()
            return
        }
        if (txtPhone.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter Phone Number")
            self.txtPhone .resignFirstResponder()
            return
        }
        if (txtViewMessage.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter message")
            self.txtViewMessage .resignFirstResponder()
            return
        }
        
        paramsDIc = ["api_key_data":WebServices.API_KEY,"name":txtName.text!,"email":txtEmail.text!,"mobile":txtPhone.text!,"message":txtViewMessage.text!]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.CONTACT_US, params: paramsDIc) { (result, success) in
         self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String,selector:#selector(self.backVc))
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message! ,selector:#selector(self.backVc))
            }
        }
        
        
        
    }
    
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
       backVc()
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }

    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }

}
