//
//  BuyerRatingViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class BuyerRatingViewController: UIViewController,UITextViewDelegate,FloatRatingViewDelegate
{

    var strOrderId = String()
    var strUserId = String()
    var strUserType = String()
    var strProductId = String()
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSUbmiteReview: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ratingView.delegate = self
        ratingView.contentMode = UIViewContentMode.scaleAspectFit
        txtComment.placeholder = "Write your comment."
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
       
    }
    
    @IBAction func btnSubmitReview_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if self.ratingView.rating == 0.0
        {
            self.showAlert(message: "Please Choose Rating")
            return
        }
        if (txtComment.text?.isEmpty)! || txtComment.text == ""
        {
            self.showAlert(message: "Please enter your comment")
            return
        }
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"user_id":strUserId,"rate":self.ratingView.rating,"comment":txtComment.text!,"order_id":strOrderId] as [String : Any]
     
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BUYER_SUBMIT_RATING, params: paramsDic)
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
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!, selector:#selector(self.backVc))
            }
        }
        
 }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Back_Taooed(_ sender: Any)
    {
       backVc()
    }
}
