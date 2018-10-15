//
//  LoginViewController.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import GoogleSignIn
import ActionSheetPicker
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
import LGSideMenuController



class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate
{

    var userLoginType = String()
    let loginManager = FBSDKLoginManager()
    
    var fullName = String()
    var email = String()
    
    var userDataDIctionary = [String:Any]()
    
    @IBOutlet weak var txtCountryCode:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btn_navigation_back: UIButton!
    @IBOutlet weak var imgFb: UIImageView!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    
    var arrCountryCodes:NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtCountryCode.text = Constants.COUNTRY_CODE
        txtCountryCode.isEnabled = false
        
//        imgFb.clipsToBounds = true
//        imgFb.layer.cornerRadius = 15
//        imgFb.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
//        
//        imgGoogle.clipsToBounds = true
//        imgGoogle.layer.cornerRadius = 15
//        imgGoogle.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        if userLoginType == UserType.MERCHANT
        {
            btnSignUp.isHidden = true
            lblDontHaveAccount.isHidden = true
            btnForgot.isHidden = true
        }
   
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    @IBAction func btnLoginTapped()
    {
        
        
        if (txtPhoneNumber.text?.isEmpty)!
        {
            self.showAlert(message:"Phone Number can't be empty!")
            self.txtPhoneNumber.resignFirstResponder()
            return
        }
        if (txtPassword.text?.isEmpty)!
        {
            self.showAlert(message:"Password Can't be empty")
            self.txtPassword .resignFirstResponder()
            return
        }
        
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "telcode":self.txtCountryCode.text!,
                          "phone":self.txtPhoneNumber.text!,
                          "password":self.txtPassword.text!,
                          "user_type":userLoginType]
        print("\(paramsDict)")
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
                
             

            
                if self.userLoginType == UserType.BUYER
                {
                    if User.mobileverify == "YES"
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
    @IBAction func googleSignIn()
    {
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
        
            fullName = user.profile.name
            email = user.profile.email
            self.userDataDIctionary = ["email":self.email,"name":self.fullName,"login_type":"gmail_user"]
            self.existingEmailChecking(userDetails: self.userDataDIctionary)
            
            
        }
    }
    func existingEmailChecking(userDetails: [String:Any])
    {
        email = userDetails["email"] as! String
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY, "email":email, "user_type":userLoginType]
        ApiManager().postRequest(service: WebServices.EXISTING_EMAIL_CHECKING, params: paramsDict) { (result, success) in
            
            if success == false
            {
                if self.userLoginType == UserType.MERCHANT
                {
                   self.showAlert(message: "Please Contact admit to register your mail as marchant")
                    
                }
                else
                {
                self.registrationWithSocialnetworkvc(userDetails: userDetails)
                }
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                let userDataDictionary:[String:Any]? = dataDictionary?["userdata"] as? [String : Any]
         
                _ = User(userDictionay: userDataDictionary!)
                
                if self.userLoginType == UserType.MERCHANT
                {
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                }
                else{
                
                if User.mobileverify == "YES"
                {
                    
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                    
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

                }
                else
                {
                    
                    
                    let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
                   let userDataDictionary = UserDefaults.standard.dictionary(forKey: "userDetails")!
 
                    
                    mobileVc.networkType = (userDataDictionary["login_type"] as? String)!
                    self.present(mobileVc, animated: true, completion: nil)
                    
                }
                
                }
            }
        }
    }
  @IBAction func btnFaceBookloginButtonClicked()
    {
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
    
    func getFBUserData()
    {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, birthday, email, gender, name, picture.type(large)"]).start()
            {
                (connection, result, error) in
                
                if (error == nil)
                {
                    self.userDataDIctionary = result as! [String : Any]
                    
                    self.userDataDIctionary.updateValue("fb_user", forKey:"login_type")
                    
                     let strFbEmail = self.userDataDIctionary["email"] as? String
                    
                    if strFbEmail == nil || strFbEmail! == ""
                    {
                        self.showAlertWithAction(message: "Not getting Required information please register Manually",selector:#selector(self.registerVc))
                    }
                    else
                    {
                        self.existingEmailChecking(userDetails:self.userDataDIctionary)
                    }
                    
                    
                    
                }
             }
    }
    
    func registrationWithSocialnetworkvc(userDetails:[String:Any])
    {
        let registrationWithSocialnetworkvc = storyboard?.instantiateViewController(withIdentifier: "RegistrationWithSocialNetworkViewController") as! RegistrationWithSocialNetworkViewController
     
        
        registrationWithSocialnetworkvc.userType = userLoginType
         UserDefaults.standard.set(userDetails, forKey: "userDetails")
        self.present(registrationWithSocialnetworkvc, animated: true, completion: nil)
        
    }
    
    
@IBAction func btnForgotPasswordTapped()
{
    let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
    self.present(forgotVc, animated: true, completion: nil)
}

    @IBAction func btn_Back_Tapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    //Uitextfiled Delegates
func textFieldShouldReturn(_ textField: UITextField) -> Bool
{
   textField.resignFirstResponder()
    return true
}
  
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    @objc func mobileVc()
    {
        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")
        self.present(mobileVc!, animated: true, completion: nil)
    }
    @objc func registerVc()
    {
        let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController")
        self.present(registerVc!, animated: true, completion: nil)
        
    }
    @IBAction func btn_SignUp_tapped(_ sender: Any) {
        
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

