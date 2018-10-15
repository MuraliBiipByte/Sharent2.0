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
    

    @IBOutlet weak var txtOtp:UITextField!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var lblMobileText: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lblMobileText.text = "One time password has been set to your mobile number \(User.telcode!) \(User.phone!) please check and enter Verification code (OTP)"
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super .viewWillAppear(animated)
    
        tf1.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(textField:UITextField)
    {
        let text = textField.text
        if text?.utf16.count == 1
        {
            switch textField
            {
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
             readOTP()
            default:
                break
            }
            
        }
        else{
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtOtp
        {
            let str = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            if (str?.count ?? 0) == 4
            {
                txtOtp.text = str
                readOTP()
                txtOtp.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    @IBAction func btnResendOtpTapped()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"telcode":User.telcode!,"phone":User.phone!]
        ApiManager().postRequest(service: WebServices.RESEND_OTP, params: paramsDic) { (result, success) in
            if success == false
            {
              self.showAlert(message: result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.showAlert(message: message!)
            }
        }
        
        
    }
    @IBAction func btnSubmitOtpTapped()
    {
        
       print(userLoginType)
             print(User.telcode!)
             print(User.phone!)
        print((tf1.text!+tf2.text!+tf3.text!+tf4.text!))
        print(WebServices.API_KEY)
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":userLoginType,"telcode":User.telcode!,"phone":User.phone!,"mobile_otp":(tf1.text!+tf2.text!+tf3.text!+tf4.text!)]
        ApiManager().postRequest(service: WebServices.VERIFY_ACCOUNT, params: paramsDic) { (result, success) in
            if success == false
            {
                self.showAlert(message: result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                let userDataDictionary:[String:Any]? = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                let message = resultDictionary["message"] as? String
                self.showAlert(message: message!)
            }
        }
    }
    func readOTP()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":userLoginType,"telcode":User.telcode!,"phone":User.phone!,"mobile_otp":(tf1.text!+tf2.text!+tf3.text!+tf4.text!)]
        ApiManager().postRequest(service: WebServices.VERIFY_ACCOUNT, params: paramsDic) { (result, success) in
            if success == false
            {
                self.showAlert(message: result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                let userDataDictionary:[String:Any]? = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                
                if self.networkType == "gmail_user" || self.networkType == "fb_user"
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
        Message.shared.Alert(Title:Constants.APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
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
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(loginVC), Controller: self)], Controller: self)
    }
}
