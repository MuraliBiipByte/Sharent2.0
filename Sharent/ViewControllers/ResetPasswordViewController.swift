//
//  ResetPasswordViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController
{
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    
    //We are receiving values from before class
    var telecode = String()
    var email = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSubmitPassword()
    {
        if (txtPassword.text?.isEmpty)!
        {
            self.showAlert(message:"Password cannot be empty!")
            self.txtPassword.resignFirstResponder()
            return
        }
        if (txtConfirmPassword.text?.isEmpty)!
        {
            self.showAlert(message:"ConfirmPassword cannot be empty!")
            self.txtConfirmPassword.resignFirstResponder()
            return
        }
        if (!(txtPassword.text == txtConfirmPassword.text))
        {
            self.showAlert(message: "Password and Confirm Password are not matching")
            self.txtPassword.resignFirstResponder()
            return
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"email":email,"password":txtPassword.text!,"passconf":txtConfirmPassword.text!]
     
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
                self.showAlertWithAction(message: message!, selector:#selector(self.LoginVC))
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
        login.userLoginType = BUYER
        self.present(login, animated: true, completion: nil)
    }
}
