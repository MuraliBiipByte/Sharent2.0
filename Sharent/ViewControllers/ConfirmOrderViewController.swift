//
//  ConfirmOrderViewController.swift
//  Sharent
//
//  Created by Biipbyte on 06/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController,UITextViewDelegate
{
    var userId = String()
    var userLoginType = String()
    var orderId = String()
    var productUserId = String()
    var merchantId = String()
    
    var paramsdic = [String:Any]()
    
    var urlService = String()
    
    // We have to send the value 0(not good) or 1(good) for productcondition
    
    @IBOutlet weak var txtViewMessage:UITextView!
    @IBOutlet weak var btnProductConditionGood:UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "CONFIRM ORDER"
        
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
        
        txtViewMessage.text = " Further comments on condition of the item."
        txtViewMessage.textColor = UIColor.lightGray
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btn_send_tapped()
    {
        self.view.endEditing(true)
        
        if btnProductConditionGood.isSelected
        {
            self.updateConfirmOrder(productConditon: "1")
        }
        else
        {
            let otherAlert = UIAlertController(title:APP_NAME, message: "Did you receive product in bad condition?", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler:
            {(alert: UIAlertAction!) in
                
                self.updateConfirmOrder(productConditon: "1")
            })
            
            let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:
            {(alert: UIAlertAction!) in
                
                self.updateConfirmOrder(productConditon: "0")
            })
            otherAlert.addAction(okAction)
            otherAlert.addAction(deleteAction)
            present(otherAlert, animated: true, completion: nil)
        }
        
    }
    
    @objc func updateConfirmOrder(productConditon:String)
    {
        if txtViewMessage.textColor == UIColor.lightGray
        {
            self.showAlert(message:"Please enter message")
            self.txtViewMessage.resignFirstResponder()
            return
        }
        paramsdic = ["api_key_data":WebServices.API_KEY,"message":txtViewMessage.text!,"user_type":userLoginType,"order_id":orderId,"good_condition":productConditon]
        
        if userLoginType == BUYER
        {
            urlService = WebServices.BUYER_CONFIRM_ORDER
            paramsdic["user_id"] = userId
            paramsdic["merchant_id"] = merchantId
        }
        else
        {
            urlService = WebServices.MERCHANT_CONFIRM_ORDER
            paramsdic["user_id"] = productUserId
            paramsdic["merchant_id"] = userId
        }
        
        self.view.StartLoading()
        ApiManager().postRequest(service:urlService, params: paramsdic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message:result as! String)
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!,selector:#selector(self.homeVc))
            }
        }
        
        
    }
    
    @IBAction func btn_PoductCondition_Tapped()
    {
        btnProductConditionGood.setImage(UIImage(named: "uncheckPrivacy"), for: .normal)
        btnProductConditionGood.setImage(UIImage(named: "checkPrivacy"), for: .selected)
        
        if btnProductConditionGood.isSelected
        {
            btnProductConditionGood.isSelected = false
        }
        else
        {
            btnProductConditionGood.isSelected = true
        }
    }
    
    @IBAction func btn_Back_Tapped()
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeVc()
    {
        
        if  userLoginType == BUYER
        {
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if txtViewMessage.textColor == UIColor.lightGray
        {
            txtViewMessage.text = nil
            txtViewMessage.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        
        let currentText:String = txtViewMessage.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty
        {
            
            txtViewMessage.text = " Further comments on condition of the item."
            txtViewMessage.textColor = UIColor.lightGray
            txtViewMessage.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: txtViewMessage.beginningOfDocument)
        }
            
        else if txtViewMessage.textColor == UIColor.lightGray && !text.isEmpty
        {
            txtViewMessage.textColor = UIColor.black
            txtViewMessage.text = text
        }
        else
        {
            return true
        }
        return false
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
