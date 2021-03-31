//
//  PreSignUpViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class PreSignUpViewController: UIViewController {
    @IBOutlet weak var lblNameHight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField1Hight: NSLayoutConstraint!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField2Hight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSubmit: UIButton!
    var emailValidate:Bool = false
    var strEmail = String()
    var strName = String()

    
    var PhoneValidate:Bool = false
    var strPhone = String()
    
    var otpValidate:Bool = false
    
    



    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSubmit.setTitle("GET STARTED", for: UIControlState.normal)
        
        lblNameHight.constant = 0
        txtField1Hight.constant = 0
        txtField2.placeholder = "Enter Email"
        txtField2.attributedPlaceholder = NSAttributedString(string: "Enter Email",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }

    @IBAction func btnSubmit_Tapped(_ sender: Any) {
       
        if !emailValidate {
       
            if (self.txtField2.text?.isEmpty)!{
                self.showAlert(message: "Please Enter EmailId")
                return
                
            }
            if (!Validations().isValidEmail(testStr: txtField2.text!))
            {
                self.showAlert(message:"Invalid Email")
                return;
            }
            else{
                check_emilVerify()
                
            }
            
        }
       else if !PhoneValidate {
            if (self.txtField2.text?.isEmpty)!{
                self.showAlert(message: "Please Enter Mobile Number")
                return
            }
            else{
                chk_mobileVerify()
            }
        }
        
        else if !otpValidate{
            if (self.txtField2.text?.isEmpty)!{
                self.showAlert(message: "Please Enter OTP")
                return
            }
            else{
                chk_otpVerify()
            }
        }
        else{
            if (self.txtField1.text?.isEmpty)!{
                self.showAlert(message: "Please Enter Password")
                return
            }
            if (self.txtField2.text?.isEmpty)!{
                self.showAlert(message: "Please ReEnter Password")
                return
            }
            if !(self.txtField1.text! == self.txtField2.text!)
            {
                self.showAlert(message: "Password and ReEnter Password should be same")
                return
            }
             chk_passwordset()
        }
                
      
       
        
    }
    
    func check_emilVerify()
    {
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "email":self.txtField2.text!,
                          ]
      
        self.view.endEditing(true)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.PRE_AUTH_EMAIL_CHECK, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                //   self.showAlert(message: result as! String)
               
                self.showAlert(message: result as! String)
              
                
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"]as! [String:Any]
                //self.showAlert(message: dataDictionary["name"] as! String)
                self.lblNameHight.constant = 21
                self.lblName.text = "Hello \(String(describing: dataDictionary["name"] as! String))"
                self.strName = "\(String(describing: dataDictionary["name"] as! String))"
                
                self.strEmail = self.txtField2.text!
                self.txtField2.text = ""
                
                self.txtField2.attributedPlaceholder = NSAttributedString(string: "Enter MobileNumber",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                
                self.btnSubmit.setTitle("GET OTP", for: UIControlState.normal)
                self.emailValidate = true
                
            }
        }
    }
    func chk_mobileVerify()
    {
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "email":strEmail,"mobile":"+65\(self.txtField2.text!)","telcode":"+65"
        ]
        
        self.view.endEditing(true)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.PRE_AUTH_MOBILENUMBER_CHECK, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
              
                self.showAlert(message:result as! String)
           
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["message"]
                self.showAlert(message: (dataDictionary) as! String)
                
                self.strPhone = self.txtField2.text!
                
                self.txtField2.text = ""
                self.emailValidate = true
                self.txtField2.attributedPlaceholder = NSAttributedString(string: "Enter OTP",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                self.lblNameHight.constant = 21
                self.lblName.text = "+65 \(self.strPhone)"
                self.btnSubmit.setTitle("VERIFY", for: UIControlState.normal)
                self.PhoneValidate = true
                
            }
        }
    }
    func chk_otpVerify()
    
        {
            let paramsDict = ["api_key_data":WebServices.API_KEY,
                              "mobile":self.strPhone,"mobile_otp":self.txtField2.text!,"email":strEmail,"telcode":"+65",
            ]
          
            self.view.endEditing(true)
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.PRE_AUTH_OTP_CHECK, params: paramsDict)
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                  
                    self.showAlert(message:result as! String)
                  
                }
                else
                {
                   
                    let resultDictionary = result as! [String : Any]
                    let dataDictionary = resultDictionary["message"]
                    self.showAlert(message: (dataDictionary) as! String)
                    
                    self.txtField1.text = ""
                    self.txtField1Hight.constant = 40
                    self.txtField2.text = ""
                    
                    self.txtField1.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    self.txtField2.attributedPlaceholder = NSAttributedString(string: "Re Enter Password",
                                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    self.btnSubmit.setTitle("SUBMIT", for: UIControlState.normal)
                    self.txtField1.isSecureTextEntry = true
                    self.txtField2.isSecureTextEntry = true

                    self.otpValidate = true
                    
                }
            }
        }
    
    func chk_passwordset()
    {
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "mobile":self.strPhone,"password":self.txtField1.text!,"confpassword":self.txtField2.text!,"email":strEmail,"telcode":"+65","user_type":BUYER,"name":strName
                          ]
       
        self.view.endEditing(true)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.PRE_SIGNUP_PASSWORD_SET, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                
                self.showAlert(message:result as! String)
                return
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["message"]
                self.showAlert(message: (dataDictionary) as! String)
              
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController")as! NewLoginViewController
                self.present(viewController, animated: true, completion: nil)
                
            }
        }
    
    }
    
    

    @IBAction func btnMenu_Tapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, animations:
            {
            self.sideMenuController?.leftViewWidth = self.view.frame.width - 100
            self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
        })
    }
}

extension PreSignUpViewController {
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
