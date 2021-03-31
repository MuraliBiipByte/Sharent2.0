//
//  CancelOrderViewController.swift
//  Sharent
//
//  Created by Biipbyte on 23/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class CancelOrderViewController: UIViewController
{
    
    @IBOutlet weak var lbl_Cancel_Description: UILabel!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Booking"
        
        lbl_Cancel_Description.text = "Are you sure that you want to cancel this order? The delivery fee and $\(ProductInformation.productCancelFee ?? "") cancellation fee will be charged to your account"
        
        btnBack.isEnabled = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_CancelOrder_Yes_Tapped(_ sender: Any)
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"order_id":ProductInformation.productOrderId!,"product_id":ProductInformation.productID!]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.CANCEL_OREDR, params: paramsDic) { (result, success) in
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
    
    @objc func myBookingVc()
    {
        let mybookingClass = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
        self.navigationController?.pushViewController(mybookingClass, animated: false)
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_CancelOrder_No_Tapped(_ sender: Any)
    {
        backVc()
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
}
