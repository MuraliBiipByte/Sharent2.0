//
//  NewLoginViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import GoogleSignIn
import ActionSheetPicker
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
import LGSideMenuController

class NewLoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate{

    
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var lblUnderBtnUser: UILabel!
    @IBOutlet weak var btnMerchant: UIButton!
    @IBOutlet weak var lblUnderMerchant: UILabel!
    @IBOutlet weak var btnFbHeight: NSLayoutConstraint!
    @IBOutlet weak var btnGoogleHeight: NSLayoutConstraint!
    @IBOutlet weak var createAccountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createAccountView: UIView!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var userLoginType = String()
    var userChecking = String()
     let loginManager = FBSDKLoginManager()
    var fullName = String()
    var email = String()
     var username = String()
    
    var userDataDIctionary = [String:Any]()
     var arrCountryCodes:NSArray!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblUnderBtnUser.backgroundColor = APP_COLOR
        lblUnderMerchant.backgroundColor = UIColor.white
        
        btnFbHeight.constant = 45.0
        btnFbHeight.isActive = true
        btnGoogleHeight.constant = 45.0
        btnGoogleHeight.isActive = true
       
        userLayout()
         btnMerchant.layer.shadowColor = APPEARENCE_COLOR.cgColor
        userLoginType = BUYER
        
    }
    
    
    
    @IBAction func signin_Tapped(_ sender: Any) {
        
        
        if (txtEmail.text?.isEmpty)!
        {
            self.showAlert(message:"Email can't be empty!")
            self.txtEmail.resignFirstResponder()
            return
        }
        if (txtPassword.text?.isEmpty)!
        {
            self.showAlert(message:"Password Can't be empty")
            self.txtPassword .resignFirstResponder()
            return
        }
        
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "email":self.txtEmail.text!,
                          "password":self.txtPassword.text!,
                          "user_type":userLoginType]
//        print("\(paramsDict)")
        self.view.endEditing(true)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.LOGIN_ACCOUNT, params: paramsDict)
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
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                
                if self.userLoginType == BUYER
                {
                   
                    if User.emailverify == "YES"
                    {
                    
                        print(User.userID)
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
                        self.showAlertWithAction(message: message!,selector:#selector(self.mobileVc))
                    }
                }
                    
                else
                {
                    
                    UserDefaults.standard.set(User.userID, forKey: "user_id")
                    UserDefaults.standard.set(User.username, forKey: "userName")
                    UserDefaults.standard.set(User.photouser, forKey: "userImage")
                    UserDefaults.standard.set(User.usertype, forKey: "user_type")
                    UserDefaults.standard.set(User.phone, forKey: "user-phone")
                    UserDefaults.standard.set(User.usercompany, forKey: "company")
                    UserDefaults.standard.set(User.merchantType, forKey: "merchantType")
                    UserDefaults.standard.set(User.useraddress, forKey: "address")
                    UserDefaults.standard.set(User.userCity, forKey: "city")
                    UserDefaults.standard.set(User.gender, forKey: "gender")
                    UserDefaults.standard.set(User.latitude, forKey: "lat")
                    UserDefaults.standard.set(User.longtitude, forKey: "lng")
                    UserDefaults.standard.set(User.email, forKey: "email")
                    
                    let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                    navigationController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier:"MerchantHomeViewController"))!], animated: false)
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
                    mainViewController.rootViewController = navigationController
                    let window = UIApplication.shared.delegate!.window!!;
                    window.rootViewController = mainViewController
                    
                }
            }
            
            self.fcmRegistration()
        }
        
        
    }
    
    @IBAction func forgotPassword_Tapped(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(forgotVc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func googleSignin_Tapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
        
    }
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        
        if let error = error
        {
            print("\(error.localizedDescription)")
        }
        else
        {
            
            print(user)
            fullName = user.profile.name
            email = user.profile.email
            userLoginType = GMAIL_USER
            self.userDataDIctionary = ["email":self.email,"name":self.fullName,"login_type":userLoginType,"device_type":DEVICE_TYPE,"user_type":BUYER]
            self.existingEmailChecking(userDetails: self.userDataDIctionary)
            
            
        }
    }
    func existingEmailChecking(userDetails: [String:Any])
    {

         var fbId = String()
        var image  = String()

        
        email = userDetails["email"] as! String
        fullName = userDetails["name"] as! String
        fbId = userDetails["id"] as! String
        let picture = userDetails["picture"] as! NSDictionary
        let Details  = picture["data"] as! NSDictionary
        image =  Details["url"] as! String
        
        
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY, "email":email, "user_type":BUYER,"login_type":self.userLoginType,"device_type":DEVICE_TYPE,"username":fullName,"fb_id":fbId,"fb_image":image]
       
        
        ApiManager().postRequest(service: WebServices.SOCIAL_MEDIA_LOGIN, params: paramsDict) { (result, success) in
            
            
            if success == false
            {
                if self.userLoginType == MERCHANT
                {
                    self.showAlert(message: "Please Contact admin to register your mail as merchant")
                }
                else
                {
                    self.registrationWithSocialnetworkvc(userDetails: userDetails)
                }
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary?["userdata"] as? [String : Any]
                
                _ = User(userDictionay: userDataDictionary!)
                
                if self.userLoginType == MERCHANT
                {
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                }
                else
                {
                    
//                    if User.mobileverify == "YES"
//                    {
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
                        
//                    }
//                    else
//                    {
//
//                        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
//                        mobileVc.userLoginType = self.userLoginType
//                        mobileVc.networkType = userDetails["login_type"] as! String
//                        self.present(mobileVc, animated: true, completion: nil)
//
//                    }
                    
                }
            }
        }
    }
    
    func getFBUserData()
    {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, birthday, email, gender, name, picture.type(large)"]).start()
            {
                (connection, result, error) in
                
                if (error == nil)
                {
                    self.userDataDIctionary = result as! [String : Any]
                    
                    self.userDataDIctionary.updateValue(FB_USER, forKey:"login_type")
                    
                    let strFbEmail = self.userDataDIctionary["email"] as? String
                    
                    if strFbEmail == nil || strFbEmail! == ""
                    {
                        self.showAlertWithAction(message: "Not getting Required information please register Manually",selector:#selector(self.registerVc))
                    }
                    else
                    {
                        
                        self.userLoginType = FB_USER
                        
                        self.existingEmailChecking(userDetails:self.userDataDIctionary)
                    }
                    
                }
        }
    }
    
    @objc func registerVc()
    {
        let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
        self.present(registerVc!, animated: true, completion: nil)
        
    }
    
    func registrationWithSocialnetworkvc(userDetails:[String:Any])
    {
        let registrationWithSocialnetworkvc = storyboard?.instantiateViewController(withIdentifier: "RegistrationWithSocialNetworkViewController") as! RegistrationWithSocialNetworkViewController
        
        registrationWithSocialnetworkvc.strEmail = userDetails["email"] as? String
        registrationWithSocialnetworkvc.strname = userDetails["name"] as? String
        registrationWithSocialnetworkvc.strLoginType = userDetails["login_type"] as? String
        
        if let picture = userDetails["picture"] as? NSDictionary
        {
            if let data = picture["data"] as? NSDictionary
            {
                registrationWithSocialnetworkvc.strPhoto = data["url"] as? String
                
            }
        }
        
        registrationWithSocialnetworkvc.userType = userLoginType
        self.present(registrationWithSocialnetworkvc, animated: true, completion: nil)
        
    }
    
    @IBAction func btn_FacebookTapped(_ sender: Any) {
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        loginManager.loginBehavior = FBSDKLoginBehavior.web
        loginManager.logIn(withReadPermissions: ["email","public_profile","user_birthday","user_gender"], from: self)
        {
            (result, error) -> Void in
            
            if let error = error
            {
                print(error.localizedDescription)
                
                return
            }
                
            else if (result?.isCancelled)!
            {
                print("Cancelled")
                
                return
            }
            else
            {
                self.getFBUserData()
                
            }
        }
        
    }
    
    //Uitextfiled Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func mobileVc()
    {
        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController") as! MobileVerificationViewController
        mobileVc.userLoginType = User.usertype!
        self.present(mobileVc, animated: true, completion: nil)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    @IBAction func user_tapped(_ sender: Any) {
        
        lblUnderBtnUser.backgroundColor = APP_COLOR
        lblUnderMerchant.backgroundColor = UIColor.white
        btnFbHeight.constant = 45.0
        btnGoogleHeight.constant = 45.0
        createAccountViewHeight.constant = 88
        createAccountViewHeight.isActive = true
        createAccountView.isHidden = false
      
        userLayout()
        userLoginType = BUYER
        btnMerchant.layer.shadowColor = APPEARENCE_COLOR.cgColor
        
    }
    
    @IBAction func merchant_Tapped(_ sender: Any) {
        
        lblUnderBtnUser.backgroundColor = UIColor.white
        lblUnderMerchant.backgroundColor = APP_COLOR
        btnFbHeight.constant = 0.0
        btnGoogleHeight.constant = 0.0
        createAccountViewHeight.constant = 0.0
        createAccountViewHeight.isActive = true
        createAccountView.isHidden = true
        
        merchantLayout()
      userLoginType = MERCHANT
        btnUser.layer.shadowColor = APPEARENCE_COLOR.cgColor
        
    }
    
    func userLayout() {
        
        btnUser.layer.shadowColor = APP_COLOR.cgColor
        btnUser.layer.shadowOpacity = 1.5
        btnUser.layer.shadowOffset = CGSize.zero
        btnUser.layer.shadowRadius = 2
        userChecking = "buyer"
        btnUser.layer.masksToBounds = false
        
    }
    
    func merchantLayout() {
        
        btnMerchant.layer.shadowColor = APP_COLOR.cgColor
        btnMerchant.layer.shadowOpacity = 1.5
        btnMerchant.layer.shadowOffset = CGSize.zero
        btnMerchant.layer.shadowRadius = 2
        userChecking = "merchant"
        btnMerchant.layer.masksToBounds = false
        
    }
    
    
    @IBAction func createAccount_Tapped(_ sender: Any) {
        
        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")as! RegistrationViewController
        signUp.userType = userLoginType
        self.present(signUp, animated: true, completion: nil)
        
        
    }
    
    func fcmRegistration()
    {
        let  userFcmToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY,"user_id":User.userID!, "fcm_regid":userFcmToken!, "user_type":userLoginType,"type":"ios"]
        ApiManager().postRequest(service: WebServices.FCMREGISTRATION_USER, params: paramsDict)
        { (result, success) in
            
            print(result)
            
        }
    }
    
}
