//
//  BuyerRatingViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class BuyerRatingViewController: UIViewController,UITextViewDelegate
{

    var referenceId = String()
    var strUserId = String()
    var strUserType = String()
    var strProductId = String()
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSUbmiteReview: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ratingView.delegate = self as? FloatRatingViewDelegate
        ratingView.contentMode = UIViewContentMode.scaleAspectFit
        txtComment.text = "Write your comment"
        txtComment.textColor = UIColor.lightGray
       
        
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        if textView == txtComment
        {
            if self.txtComment.textColor == UIColor.lightGray
            {
                self.txtComment.text = nil
                self.txtComment.textColor = Constants.NAVIGATION_COLOR
            }
        }
       
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView == txtComment
        {
            
            if self.txtComment.text.isEmpty
            {
                txtComment.text = "Write your comment"
                txtComment.textColor = UIColor.lightGray
                
            }
        }
       
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
       
    }
    
    @IBAction func btnSubmitReview_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)
        if (txtComment.text?.isEmpty)!
        {
            self.showAlert(message: "Please enter your comment")
            return
        }
        if self.ratingView.rating == 0.0
        {
            self.showAlert(message: "Please Choose Rating")
            return
        }
        print(self.ratingView.rating)
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"user_id":strUserId,"rate":self.ratingView.rating,"comment":txtComment.text!,"reference_id":referenceId] as [String : Any]
        print(paramsDic)
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
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
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
