//
//  RegistrationViewController.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import ActionSheetPicker
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import UITextView_Placeholder

class RegistrationViewController: UIViewController, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate
{
    
    var userType = String()
    var strTermsAccept = String()
    let loginManager = FBSDKLoginManager()
    var userDataDIctionary = [String:Any]()
    
    var fullName = String()
    var email = String()
    
    @IBOutlet weak var userScrollview: UIScrollView!
    
    
    var strGender = String()
    var strDob = String()
    
    var arrCountryCodes:NSArray!
    var AccountType = [String]()
    var termsAccept = false

    
   
    @IBOutlet weak var btnTermsConditions: UIButton!
    
    
    @IBOutlet weak var accountTypeTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileNoTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    @IBOutlet weak var dobTxt: UITextField!
    
    @IBOutlet weak var genderTxt: UITextField!
    
    
    @IBOutlet weak var referralCodeTxt: UITextField!
    
    let arrGender = ["Male","Female","Others"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        AccountType = ["Individual","Corporate"]
        
        userType = "buyer"
        self.accountTypeTxt.text = AccountType[0]
 
        userScrollview.isHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func SelectAccountType(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose Account Type", rows:
            self.AccountType as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                if value == 0 {
                    self.userType = "buyer"
                }
                else{
                    self.userType = index as! String
                }
                self.accountTypeTxt.text = index as? String
                
                return
                
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    
    
    
    
    @IBAction func registrationTapped()
    {
        if (accountTypeTxt.text?.isEmpty)!
        {
            self.showAlert(message:"Account Type can't be empty!")
            self.accountTypeTxt.resignFirstResponder()
            return
        }
        
        if (usernameTxt.text?.isEmpty)!
        {
            self.showAlert(message:"User Name can't be empty!")
            self.usernameTxt.resignFirstResponder()
            return
        }
        if (emailTxt.text?.isEmpty)!
        {
            self.showAlert(message:"Email Can't be empty")
            self.emailTxt .resignFirstResponder()
            return
        }
        if (!(emailTxt.text?.isEmpty)!)
        {
            if (!Validations().isValidEmail(testStr: emailTxt.text!))
            {
                self.showAlert(message:"Invalid Email")
                return;
            }
        }
        if (passwordTxt.text?.isEmpty)!
        {
            self.showAlert(message:"Password cannot be empty!")
            self.passwordTxt.resignFirstResponder()
            return
        }
        if (passwordTxt.text?.count)! < 6
        {
            self.showAlert(message:"Password must be minimum 6 characters")
            self.passwordTxt.resignFirstResponder()
            return
        }
        if (confirmPasswordTxt.text?.isEmpty)!
        {
            self.showAlert(message:" Confirm Password Can't be empty")
            self.confirmPasswordTxt .resignFirstResponder()
            return
        }
        if passwordTxt.text! != confirmPasswordTxt.text!
        {
            self.showAlert(message:"Password and Confirm Password Not matching")
            self.passwordTxt .resignFirstResponder()
            return
        }
//        if (txtphone.text?.isEmpty)!
//        {
//            self.showAlert(message:"Mobile Number can't be empty!")
//            self.txtphone.resignFirstResponder()
//            return
//        }
//        if (txtphone.text?.count)! > 9
//        {
//            self.showAlert(message:"Please enter valid Mobile Number")
//            self.txtphone.resignFirstResponder()
//            return
//        }
        
        if ((dobTxt.text?.isEmpty)! || (dobTxt.text == "DOB"))
        {
            strDob = ""
        }
        else
        {
            strDob = dobTxt.text!
        }
        if ((genderTxt.text?.isEmpty)! || (genderTxt.text == "Gender"))
        {
            strGender = ""
        }
        else
        {
            strGender = genderTxt.text!
        }
        if termsAccept
        {
            strTermsAccept = "yes"

        }
        else
        {
            self.showAlert(message: "Please Accept Terms And Conditions")
            return
        }
        // Newly added referral code and device type
        let paramsDic = ["api_key_data":WebServices.API_KEY,"username":usernameTxt.text!,"telcode":"","phone":mobileNoTxt.text!,"gender":strGender,"dob":strDob,"email":emailTxt.text!,"password":passwordTxt.text!,"confpassword":confirmPasswordTxt.text!,"login_type":userType,"referral_code":referralCodeTxt.text!,"device_type":DEVICE_TYPE,"user_type":BUYER]
        
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
                if User.emailverify! == "NO"
                {
                    let message = resultDictionary["message"] as? String
                    self.showAlertWithAction(message: message!, selector: #selector(self.mobileVc))
                    
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
        Message.shared.Alert(Title:APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    @IBAction func btn_Dateofbirth_Tapped(_ sender: Any)
    {

        let calendar = Calendar.current
        var maxDate = Date()
        maxDate = calendar.date(byAdding: .day, value: -1, to: Date())!

        let datePicker = ActionSheetDatePicker(title: "DOB", datePickerMode: UIDatePickerMode.date, selectedDate: maxDate, doneBlock:
        {
            picker, value, index in

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            self.dobTxt.text = formatter.string(from: value as! Date)

            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)

        datePicker?.maximumDate = maxDate

        datePicker?.show()

    }
    @IBAction func btn_Gender_Tapped(_ sender: Any)
    {
        ActionSheetStringPicker.show(withTitle: "Choose Gender", rows: arrGender, initialSelection: 0, doneBlock:
            {
                picker, value, index in

                print("value = \(value)")

                self.genderTxt.text = self.arrGender[value]

                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

    }

    @IBAction func btn_Terms_CheckMark_tapped(_ sender: Any)
    {

        if termsAccept
        {
            termsAccept = false
            btnTermsConditions.setImage(#imageLiteral(resourceName: "uncheckPrivacy"), for:.normal)
        }
        else
        {
            termsAccept = true
            btnTermsConditions.setImage(#imageLiteral(resourceName: "checkPrivacy"), for:.normal)
        }

    }
    @IBAction func btn_TermsConditions_Tapped(_ sender: Any)
    {

        let terms = storyboard?.instantiateViewController(withIdentifier: "RegisterTermsViewController")as! RegisterTermsViewController
        terms.urlIndex = 1
        self.present(terms, animated: true, completion: nil)
    }
    
//    @IBAction func btn_FbLogin_Tapped(_ sender: Any)
//    {
//        loginManager.logOut()
//        FBSDKAccessToken.setCurrent(nil)
//        FBSDKProfile.setCurrent(nil)
//        loginManager.loginBehavior = FBSDKLoginBehavior.web
//        loginManager.logIn(withReadPermissions: ["email","public_profile","user_birthday","user_gender"], from: self)
//        {
//            (result, error) -> Void in
//
//            if let error = error
//            {
//                print(error.localizedDescription)
//
//                return
//            }
//
//            else if (result?.isCancelled)!
//            {
//                print("Cancelled")
//
//                return
//            }
//            else
//            {
//                self.getFBUserData()
//
//            }
//        }
//
//
//    }
//    func getFBUserData()
//    {
//        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, birthday, email, gender, name, picture.type(large)"]).start()
//            {
//                (connection, result, error) in
//
//                if (error == nil)
//                {
//                    self.userDataDIctionary = result as! [String : Any]
//
//                    self.userDataDIctionary.updateValue(FB_USER, forKey:"login_type")
//
//                    let strFbEmail = self.userDataDIctionary["email"] as? String
//
//                    if strFbEmail == nil || strFbEmail! == ""
//                    {
//                        self.showAlert(message: "Not getting Required information please register Manually")
//
//                    }
//                    else
//                    {
//                        self.existingEmailChecking(userDetails:self.userDataDIctionary)
//                    }
//
//
//
//                }
//        }
//    }
    
    
//    @IBAction func btn_Google_Tapped(_ sender: Any)
//    {
//
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().delegate=self
//        GIDSignIn.sharedInstance().uiDelegate=self
//        GIDSignIn.sharedInstance().signIn()
//    }
    
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!)
//    {
//        self.present(viewController, animated: true, completion: nil)
//    }
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!)
//    {
//        self.dismiss(animated: true, completion: nil)
//    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!)
//    {
//        if let error = error
//        {
//            print("\(error.localizedDescription)")
//        }
//        else
//        {
//            fullName = user.profile.name
//            email = user.profile.email
//            self.userDataDIctionary = ["email":self.email,"name":self.fullName,"login_type":GMAIL_USER]
//            self.existingEmailChecking(userDetails: self.userDataDIctionary)
//        }
//    }
//    func existingEmailChecking(userDetails: [String:Any])
//    {
//        email = userDetails["email"] as! String
//        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY, "email":email, "user_type":userType]
//        ApiManager().postRequest(service: WebServices.EXISTING_EMAIL_CHECKING, params: paramsDict) { (result, success) in
//
//            if success == false
//            {
//                if self.userType == MERCHANT
//                {
//                    self.showAlert(message: "Please Contact admit to register your mail as marchant")
//
//                }
//                else
//                {
//                    self.registrationWithSocialnetworkvc(userDetails: userDetails)
//                }
//            }
//            else
//            {
//                let resultDictionary = result as! [String : Any]
//                let dataDictionary = resultDictionary["data"] as? [String:Any]
//                let userDataDictionary = dataDictionary?["userdata"] as? [String : Any]
//
//                _ = User(userDictionay: userDataDictionary!)
//
//                if self.userType == MERCHANT
//                {
//                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
//                    self.present(navigateToHome!, animated: true, completion: nil)
//                }
//                else
//                {
//
//                    if User.mobileverify == "YES"
//                    {
//
//                        UserDefaults.standard.set(User.userID, forKey: "user_id")
//                        UserDefaults.standard.set(User.username, forKey: "userName")
//                        UserDefaults.standard.set(User.photouser, forKey: "userImage")
//                        UserDefaults.standard.set(User.usertype, forKey: "user_type")
//                        UserDefaults.standard.set(User.phone, forKey: "user-phone")
//                        UserDefaults.standard.set(User.usercompany, forKey: "company")
//                        UserDefaults.standard.set(User.useraddress, forKey: "address")
//                        UserDefaults.standard.set(User.userCity, forKey: "city")
//                        UserDefaults.standard.set(User.gender, forKey: "gender")
//                        UserDefaults.standard.set(User.latitude, forKey: "lat")
//                        UserDefaults.standard.set(User.longtitude, forKey: "lng")
//                        UserDefaults.standard.set(User.email, forKey: "email")
//
//
//                        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
//                        self.present(navigateToHome!, animated: true, completion: nil)
//                    }
//                    else
//                    {
//
//                        let mobileVc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationViewController")as! MobileVerificationViewController
//                        mobileVc.networkType = userDetails["login_type"] as! String
//                        self.present(mobileVc, animated: true, completion: nil)
//
//                    }
//
//                }
//            }
//        }
//    }
//    func registrationWithSocialnetworkvc(userDetails:[String:Any])
//    {
//        let registrationWithSocialnetworkvc = storyboard?.instantiateViewController(withIdentifier: "RegistrationWithSocialNetworkViewController") as! RegistrationWithSocialNetworkViewController
//        registrationWithSocialnetworkvc.strEmail = userDetails["email"] as? String
//        registrationWithSocialnetworkvc.strname = userDetails["name"] as? String
//        registrationWithSocialnetworkvc.strLoginType = userDetails["login_type"] as? String
//
//        if let picture = userDetails["picture"] as? NSDictionary
//        {
//            if let data = picture["data"] as? NSDictionary
//            {
//                registrationWithSocialnetworkvc.strPhoto = data["url"] as? String
//
//            }
//        }
//        registrationWithSocialnetworkvc.userType = self.userType
//        self.present(registrationWithSocialnetworkvc, animated: true, completion: nil)
//
//    }
    
    @IBAction func btnMemberTapped()
    {
        UIView.animate(withDuration: 0.4, animations:
            {
                self.userScrollview.isHidden = false
                self.userScrollview.setContentOffset(CGPoint.zero, animated: false)
        })
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
        Merchant.latitude =  "\(place.coordinate.latitude)"
        Merchant.longtitude = "\(place.coordinate.longitude)"
        Merchant.address = "\(place.name),\(place.formattedAddress!)"
       
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func btn_back_tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
        textField.leftViewMode = .always
    }
}
