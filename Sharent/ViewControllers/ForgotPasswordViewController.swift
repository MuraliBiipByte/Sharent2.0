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
    
    @IBOutlet weak var txtCountryCode:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    
    @IBOutlet weak var txtOtp:UITextField!
    
    @IBOutlet weak var viewPassword:UIView!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    
    var arrCountryCodes:NSArray!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtCountryCode.text = Constants.COUNTRY_CODE
        txtCountryCode.isEnabled = false
        
        viewOtp.isHidden = true
        viewPassword.isHidden = true
        txtOtp.delegate = self

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
       
    }
  @IBAction func btnSubmitTapped()
    {
        self.view.endEditing(true)
        if (txtPhoneNumber.text?.isEmpty)!
        {
            self.showAlert(message: "Phone Enter Registered Mobile Number")
            self.txtPhoneNumber.resignFirstResponder()
            return
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"telcode":txtCountryCode.text!,"phone":txtPhoneNumber.text!]
        print("\(paramsDic)")
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
                
                print(result as! [String:AnyObject])
                self.showAlert(message: response["message"] as! String)
                self.viewOtp.isHidden = false
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
            self.txtPhoneNumber.resignFirstResponder()
            return
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"telcode":txtCountryCode.text!,"phone":txtPhoneNumber.text!,"forgotten_password_code":txtOtp.text!]
        print("\(paramsDic)")
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
                self.viewPassword.isHidden = false
                
                self.showAlert(message: message!)
                
            }
        }
    }


    @IBAction func btnResend_Tapped(_ sender: Any) {
        btnSubmitTapped()
        
    }
    @IBAction func btnSubmitPassword()
 {
    if (txtPassword.text?.isEmpty)!
    {
        self.showAlert(message:"Password cannot be empty!")
        self.txtPhoneNumber.resignFirstResponder()
        return
    }
    if (txtConfirmPassword.text?.isEmpty)!
    {
        self.showAlert(message:"ConfirmPassword cannot be empty!")
        self.txtPhoneNumber.resignFirstResponder()
        return
    }
    if (!(txtPassword.text == txtConfirmPassword.text))
    {
        self.showAlert(message: "Password and Confirm Password are not matching")
        self.txtPhoneNumber.resignFirstResponder()
        return
    }
    let paramsDic = ["api_key_data":WebServices.API_KEY,"telcode":txtCountryCode.text!,"phone":txtPhoneNumber.text!,"password":txtPassword.text!,"passconf":txtConfirmPassword.text!]
    print("\(paramsDic)")
    self.view.StartLoading()
    ApiManager().postRequest(service:WebServices.RESET_PASWORD, params: paramsDic)
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
            self.txtPhoneNumber.isEnabled = false
            self.showAlertWithAction(message: message!, selector:#selector(self.LoginVC))
        }
    }
 }
    @IBAction func btm_back_Tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    func showAlert(message:String)
    {
       Message.shared.Alert(Title:Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(LoginVC), Controller: self)], Controller: self)
    }
    @objc func LoginVC()
    {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(login, animated: true, completion: nil)
    }
}
