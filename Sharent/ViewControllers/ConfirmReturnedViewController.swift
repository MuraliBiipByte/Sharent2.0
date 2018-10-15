//
//  ConfirmReturnedViewController.swift
//  Sharent
//
//  Created by Biipbyte on 23/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ConfirmReturnedViewController: UIViewController
{

    var userId = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Booking"

        userId = UserDefaults.standard.value(forKey: "user_id") as! String
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    func confirmReturn(productCondition:String)
    {
        let paramsdic = ["api_key_data":WebServices.API_KEY,"user_id":userId,"reference_id":ProductInformation.productReferenceId!,"good_condition":productCondition]
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.BUYER_CONFIRM_RETURN, params: paramsdic) { (result, success) in
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
                self.showAlertWithAction(message: message!,selector:#selector(self.myBookingVc))
            }
        }
    }
    // We have specify the 0(not good) or 1(good) for productcondition
    
    @IBAction func btn_Yes_tapped()
    {
        self.confirmReturn(productCondition: "1")
    }
    @IBAction func btn_No_tapped()
    {
        self.confirmReturn(productCondition: "0")
    }
    @objc func myBookingVc()
    {
        let mybookingClass = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
        self.navigationController?.pushViewController(mybookingClass, animated: false)
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
