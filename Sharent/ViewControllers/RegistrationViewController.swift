//
//  RegistrationViewController.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class RegistrationViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
   
    var userType = String()
    var strTermsAccept = String()
    let loginManager = FBSDKLoginManager()
    var userDataDIctionary = [String:Any]()

    var fullName = String()
    var email = String()
    
    @IBOutlet weak var txtusername:UITextField!
    @IBOutlet weak var txttelcode:UITextField!
    @IBOutlet weak var txtphone:UITextField!
    @IBOutlet weak var txtemail:UITextField!
    @IBOutlet weak var txtpassword:UITextField!
    @IBOutlet weak var txtconfpassword:UITextField!
    @IBOutlet weak var txtgender:UITextField!
    @IBOutlet weak var txtdob:UITextField!
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var imgFb: UIImageView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnDob: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnTermsConditions: UIButton!
    
    let arrGender = ["Male","Female","Others"]
    var arrCountryCodes:NSArray!
    var termsAccept = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        txttelcode.text = Constants.COUNTRY_CODE
        txttelcode.isEnabled = false
        
//        imgFb.clipsToBounds = true
//        imgFb.layer.cornerRadius = 15
//        imgFb.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
//
//        imgGoogle.clipsToBounds = true
//        imgGoogle.layer.cornerRadius = 15
//        imgGoogle.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
//
       
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func registrationTapped()
    {
        if termsAccept
        {
            
            strTermsAccept = "yes"
            
        }
        else
        {
            self.showAlert(message: "Please Accept Terms And Conditions")
            return
        }
        
        if (txtusername.text?.isEmpty)!
        {
            self.showAlert(message:"User Name can't be empty!")
            self.txtusername.resignFirstResponder()
            return
        }
        if (txtphone.text?.isEmpty)!
        {
            self.showAlert(message:"Phone Number can't be empty!")
            self.txtusername.resignFirstResponder()
            return
        }
        if (txtemail.text?.isEmpty)!
        {
            self.showAlert(message:"Email Can't be empty")
            self.txtphone .resignFirstResponder()
            return
        }
        if (!(txtemail.text?.isEmpty)!)
        {
            if (!Validations().isValidEmail(testStr: txtemail.text!))
            {
                self.showAlert(message:"Invalid Email")
                return;
            }
        }
        if (txtpassword.text?.isEmpty)!
        {
            self.showAlert(message:"Password cannot be empty!")
            self.txtusername.resignFirstResponder()
            return
        }
        if (txtconfpassword.text?.isEmpty)!
        {
            self.showAlert(message:" Confirm Password Can't be empty")
            self.txtphone .resignFirstResponder()
            return
        }
        if txtpassword.text! != txtconfpassword.text!
        {
            self.showAlert(message:"Password and Confirm Password Not matching")
            self.txtphone .resignFirstResponder()
            return
        }
        if ((txtgender.text?.isEmpty)! || (txtgender.text == "Gender"))
        {
            self.showAlert(message:"Please Select Gender")
            self.txtphone .resignFirstResponder()
            return
        }
        if ((txtdob.text?.isEmpty)! || (txtdob.text == "DOB"))
        {
            self.showAlert(message: "Please select date of birth")
            self.txtphone .resignFirstResponder()
            return
        }
        
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"username":txtusername.text!,"telcode":txttelcode.text!,"phone":txtphone.text!,"dob":txtdob.text!,"email":txtemail.text!,"password":txtpassword.text!,"confpassword":txtconfpassword.text!,"login_type":"buyer","user_type":userType]
        
          self.view.endEditing(true)
           self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.CREATE_ACCOUNT, params: paramsDic) { (result, success) in
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
                if User.mobileverify! == "NO"
                {
                    let message = resultDictionary["message"] as? String
                    self.showAlertWithAction(message: message!)
                    
                }
                
                
            }
        }
        
    }
    @objc func mobileVc()
    {
        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as!  MobileVerificationViewController
        mobileVc.userLoginType = userType
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

    @IBAction func btn_Dateofbirth_Tapped(_ sender: Any)
    {
 
        let datePicker = ActionSheetDatePicker(title: "DOB", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock:
        {
            picker, value, index in
    
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyy"
          
            self.txtdob.text = formatter.string(from: value as! Date)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;

        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
    
        
        datePicker?.show()
        
    }
    @IBAction func btn_Gender_Tapped(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Choose Gender", rows: arrGender, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
         
            self.txtgender.text = self.arrGender[value]
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    @IBAction func btn_Terms_CheckMark_tapped(_ sender: Any) {
        
        if termsAccept {
            termsAccept = false
               btnTermsConditions.setImage(#imageLiteral(resourceName: "uncheckPrivacy"), for:.normal)
        }
        else{
            termsAccept = true
            btnTermsConditions.setImage(#imageLiteral(resourceName: "checkPrivacy"), for:.normal)
        }
        
    }
    @IBAction func btn_TermsConditions_Tapped(_ sender: Any) {
        
        let terms = storyboard?.instantiateViewController(withIdentifier: "RegisterTermsViewController")as! RegisterTermsViewController
        self.present(terms, animated: true, completion: nil)
    }
    
    @IBAction func btn_CreateAccount_Tapped(_ sender: Any) {
    }
    
    @IBAction func btn_FbLogin_Tapped(_ sender: Any) {
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
                        self.showAlert(message: "Not getting Required information please register Manually")
                       
                    }
                    else
                    {
                        self.existingEmailChecking(userDetails:self.userDataDIctionary)
                    }
                    
                    
                    
                }
        }
    }
    
    
    @IBAction func btn_Google_Tapped(_ sender: Any) {
        
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
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY, "email":email, "user_type":userType]
        ApiManager().postRequest(service: WebServices.EXISTING_EMAIL_CHECKING, params: paramsDict) { (result, success) in
            
            if success == false
            {
                if self.userType == UserType.MERCHANT
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
                
                if self.userType == UserType.MERCHANT
                {
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                }
                else{
                    
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
                        
                        
                        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
                        let userDataDictionary = UserDefaults.standard.dictionary(forKey: "userDetails")!
                        
                        
                        mobileVc.networkType = (userDataDictionary["login_type"] as? String)!
                        self.present(mobileVc, animated: true, completion: nil)
                        
                    }
                    
                }
            }
        }
    }
    func registrationWithSocialnetworkvc(userDetails:[String:Any])
    {
        let registrationWithSocialnetworkvc = storyboard?.instantiateViewController(withIdentifier: "RegistrationWithSocialNetworkViewController") as! RegistrationWithSocialNetworkViewController
        
        UserDefaults.standard.set(userDetails, forKey: "userDetails")
        self.present(registrationWithSocialnetworkvc, animated: true, completion: nil)
        
    }
    
    @IBAction func btn_back_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
