//
//  MobileVerificationViewController.swift
//  Sharent
//
//  Created by Biipbyte on 30/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MobileVerificationViewController: UIViewController,UITextFieldDelegate
{
     
    var userLoginType = String()
    var phoneNumber = String()
    var telecode = String()
    var networkType = String()
    
    
    @IBOutlet weak var lblTelecodePhoneNumber:UILabel!

    @IBOutlet weak var txtOtp:UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblTelecodePhoneNumber.text = "\(User.email!)"
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super .viewWillAppear(animated)
    
    }
    
    @IBAction func btnResendOtpTapped()
    {
        self.view.endEditing(true)
        let paramsDic = ["api_key_data":WebServices.API_KEY,"email":User.email!]
         self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.RESEND_VERIFY_CODE, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
              self.showAlert(message: result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.txtOtp.text = nil
                self.showAlert(message: message!)
            }
        }
        
        
    }
    @IBAction func btnSubmitOtpTapped()
    {
        self.view.endEditing(true)
        if (txtOtp.text?.isEmpty)!
        {
            self.showAlert(message: "Otp cannot be empty!")
            self.txtOtp.becomeFirstResponder()
            return
        }
 
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":userLoginType,"email":User.email!,"email_otp":txtOtp.text!]
            self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.VERIFY_EMAIL_ACCOUNT, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                
                if self.networkType == GMAIL_USER || self.networkType == FB_USER
                {
                    
                    UserDefaults.standard.set(User.userID, forKey: "user_id")
                    UserDefaults.standard.set(User.username, forKey: "userName")
                    UserDefaults.standard.set(User.photouser, forKey: "userImage")
                    UserDefaults.standard.set(User.usertype, forKey: "user_type")
                    UserDefaults.standard.set(User.phone, forKey: "user-phone")
                    UserDefaults.standard.set(User.usercompany, forKey: "company")
                    UserDefaults.standard.set(User.useraddress, forKey: "address")
                    UserDefaults.standard.set(User.userCity, forKey: "city")
                    UserDefaults.standard.set(User.gender, forKey: "gender")
                    UserDefaults.standard.set(User.latitude, forKey: "lat")
                    UserDefaults.standard.set(User.longtitude, forKey: "lng")
                    UserDefaults.standard.set(User.email, forKey: "email")
                    
                    
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                    
                }
                else
                {
                    let message = resultDictionary["message"] as? String
                    
                    self.showAlertWithAction(message: message!)
                }
            }
        }
       
    }
    
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    @objc func loginVC()
    {
        UserDefaults.standard.set(User.userID, forKey: "user_id")
        UserDefaults.standard.set(User.username, forKey: "userName")
        UserDefaults.standard.set(User.photouser, forKey: "userImage")
        UserDefaults.standard.set(User.usertype, forKey: "user_type")
        UserDefaults.standard.set(User.phone, forKey: "user-phone")
        UserDefaults.standard.set(User.usercompany, forKey: "company")
        UserDefaults.standard.set(User.useraddress, forKey: "address")
        UserDefaults.standard.set(User.userCity, forKey: "city")
        UserDefaults.standard.set(User.gender, forKey: "gender")
        UserDefaults.standard.set(User.latitude, forKey: "lat")
        UserDefaults.standard.set(User.longtitude, forKey: "lng")
        UserDefaults.standard.set(User.email, forKey: "email")

        
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
        self.present(navigateToHome!, animated: true, completion: nil)
     

    }
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(loginVC), Controller: self)], Controller: self)
    }
}
