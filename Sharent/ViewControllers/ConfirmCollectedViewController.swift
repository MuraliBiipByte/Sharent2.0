//
//  ConfirmCollectedViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ConfirmCollectedViewController: UIViewController
{

    var userId = String()
    var userLoginType = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Booking"
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btn_Yes_tapped()
    {
        
        let paramsdic = ["api_key_data":WebServices.API_KEY,"merchant_id":userId,"user_type":userLoginType,"reference_id":ProductInformation.productReferenceId!]
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.MERCHANT_CONFIRM_COLLECTED, params: paramsdic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String,selector:#selector(self.backVc))
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!,selector:#selector(self.backVc))
            }
        }
    }
    @IBAction func btn_No_tapped()
    {
        self.backVc()
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        backVc()
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    
}
