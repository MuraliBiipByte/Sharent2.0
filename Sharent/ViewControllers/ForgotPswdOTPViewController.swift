//
//  ForgotPswdOTPViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ForgotPswdOTPViewController: UIViewController
{

    //We are receiving values from before class
    var emailReference = String()
    
    @IBOutlet weak var txtOtp:UITextField!
    @IBOutlet weak var lblTelecodePhoneNumber:UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblTelecodePhoneNumber.text = "\(emailReference)"

        // Do any additional setup after loading the view.
    }
    @IBAction func btnSubmitTapped()
    {
        self.view.endEditing(true)
        let paramsDic = ["api_key_data":WebServices.API_KEY,"email":emailReference,]
      
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.FORGOTPASSWORD_ACCOUNT, params: paramsDic)
        {
            (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                let response = result as! [String:AnyObject]
                self.txtOtp.text = nil
                self.showAlert(message: response["message"] as! String)
                return
            }
        }
    }
    @IBAction func btnVerifyOtpSubmitTapped()
    {
        self.view.endEditing(true)
        if (txtOtp.text?.isEmpty)!
        {
            self.showAlert(message: "Otp cannot be empty!")
            self.txtOtp.becomeFirstResponder()
            return
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"email":emailReference,"forgotten_password_code":txtOtp.text!]
       print(paramsDic)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.FORGOTPASSWORD_VERIFY_OTP, params: paramsDic)
        {
            (result, success) in
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
                let reset = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
               
                reset.email = self.emailReference
                self.present(reset, animated: true, completion: nil)
                self.showAlert(message: message!)
                
            }
        }
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(LoginVC), Controller: self)], Controller: self)
    }
    @IBAction func btm_back_Tapped(_ sender: Any)
    {
        LoginVC()
    }
    @objc func LoginVC()
    {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
        self.present(login, animated: true, completion: nil)
    }

}
