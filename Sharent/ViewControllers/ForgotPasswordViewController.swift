//
//  ForgotPasswordViewController.swift
//  Sharent
//
//  Created by Biipbyte on 30/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate
{

    
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func sendEmail_Tapped(_ sender: Any) {
        
        if self.emailText.text == "" {
            self.showAlert(message: "Email should not be empty!")
        }else{
            print("call web service")
            
            let paramsDict = ["api_key_data":WebServices.API_KEY,"email": self.emailText.text!] as [String : Any]
            print(paramsDict)
            
           self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.FORGOTPASSWORD_ACCOUNT, params: paramsDict )
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    let response = result as! [String:AnyObject]
                    self.forgototpVC()
                    self.showAlert(message: response["message"] as! String)
                    return
                }
            }
           
            
            
        }
    }
    
    
    
    
    
    
    
//  @IBAction func btnSubmitTapped()
//    {
//        self.view.endEditing(true)
//        if (txtEmail.text?.isEmpty)!
//        {
//            self.showAlert(message: "Email should not be empty")
//            self.txtEmail.resignFirstResponder()
//            return
//        }
//
//        let paramsDic = ["api_key_data":WebServices.API_KEY,"email ":txtEmail.text!]
//
//        print("\(paramsDic)")
//        self.view.StartLoading()
//    ApiManager().postRequest(service:WebServices.FORGOTPASSWORD_ACCOUNT, params: paramsDic)
//        {
//            (result, success) in
//           self.view.StopLoading()
//            if success == false
//            {
//                self.showAlert(message: result as! String)
//                return
//            }
//            else
//            {
//                let response = result as! [String:AnyObject]
//                self.forgototpVC()
//                self.showAlert(message: response["message"] as! String)
//                return
//            }
//        }
//    }
  
    @IBAction func btm_back_Tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    func showAlert(message:String)
    {
       Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    @objc func forgototpVC()
    {
        let forgot = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPswdOTPViewController") as! ForgotPswdOTPViewController
//        forgot.telecode = txtCountryCode.text!
        forgot.emailReference = emailText.text!
        self.present(forgot, animated: true, completion: nil)
    }
    
}
