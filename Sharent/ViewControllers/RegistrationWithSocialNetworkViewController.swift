//
//  RegistrationWithSocialNetworkViewController.swift
//  Sharent
//
//  Created by Biipbyte on 06/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker

class RegistrationWithSocialNetworkViewController: UIViewController
{
    var userDataDictionary = [String:Any]()
    
    var paramsDic = [String:Any]()
    
    var userType = String()
    
    var url = String()
    
    var strname,strEmail,strPhoto,strLoginType:String?
    
    var arrCountryCodes:NSArray!

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txttelcode:UITextField!
    @IBOutlet weak var txtphone:UITextField!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txttelcode.text = Constants.COUNTRY_CODE
        txttelcode.isEnabled = false
        
     //   userType = UserDefaults.standard.string(forKey: "user_type")!
        
        userDataDictionary = UserDefaults.standard.dictionary(forKey: "userDetails")!
        strname = userDataDictionary["name"] as? String
        strEmail = userDataDictionary["email"] as? String
        strLoginType = userDataDictionary["login_type"] as? String
        
        
        if let picture = userDataDictionary["picture"] as? NSDictionary
        {
            if let data = picture["data"] as? NSDictionary
            {
                strPhoto = data["url"] as? String
                
            }
        }
        
        if strname != nil
        {
            lblName.text = strname!
        }
        if strEmail != nil
        {
            lblEmail.text = strEmail!
        }
        
        
    }
    
    @IBAction func registrationTapped()
    {
        if (txtphone.text?.isEmpty)!
        {
            self.showAlert(message:"Phone Number cannot be empty!")
            self.txtphone.resignFirstResponder()
            return
        }
        
        if strLoginType == "gmail_user"
        {
            paramsDic = ["api_key_data":WebServices.API_KEY,"name":strname!,"telcode":txttelcode.text!,"phone":txtphone.text!,"email":strEmail!,"user_type":userType]
            url = WebServices.REGISTER_ACCOUNT_GMAIL
        }
            
        else
        {
            paramsDic = ["api_key_data":WebServices.API_KEY,"name":strname!,"telcode":txttelcode.text!,"phone":txtphone.text!,"email":strEmail!,"user_type":userType,"fb_image":strPhoto!]
            
            url = WebServices.REGISTER_ACCOUNT_FACEBOOK
        }
        
        self.view.endEditing(true)
        self.view.StartLoading()
        
        ApiManager().postRequest(service: url, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                let userDataDictionary:[String:Any]? = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                
                UserDefaults.standard.set(User.userID, forKey: "user_id")
                UserDefaults.standard.set(User.username, forKey: "userName")
                UserDefaults.standard.set(User.photouser, forKey: "userImage")
                UserDefaults.standard.set(User.usertypeid, forKey: "user_type")
                
                
                if User.mobileverify == "YES"
                {
                    
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                }
                else
                {
                    let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
                    mobileVc.networkType = self.strLoginType!
                    self.present(mobileVc, animated: true, completion: nil)
                    
                }
                
                
            }
            
        }
        
    }
    @objc func mobileVc()
    {
        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
        mobileVc.networkType = strLoginType!
        self.present(mobileVc, animated: true, completion: nil)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:Constants.APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(mobileVc), Controller: self)], Controller: self)
    }

    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

