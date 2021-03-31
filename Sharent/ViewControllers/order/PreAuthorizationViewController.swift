//
//  PreAuthorizationViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class PreAuthorizationViewController: UIViewController
{

    //We are getting this params from previous class
    var paramsDictionary = [String:AnyObject]()
    
    @IBOutlet weak var lblPreauthPercentage:UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        lblPreauthPercentage.text = "A pre-authorisation fee of $\(ProductInformation.productFeePercentage!) will be held in your bank account until the rented item is safely returned to the Merchant in good condition"

    }
    
    @IBAction func btn_PreAutorizatio_Tapped()
    {
        self.view.StartLoading()
        
        ApiManager().postRequest(service:WebServices.PLACE_ORDER, params: paramsDictionary)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                
                let response = result as! [String:Any]
                let title = response["message"] as! String
                let message = "Enjoy your order and be a responsible member by taking good care of it!"
                let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                successClass.strTitle = title
                successClass.strMessage = message
                self.navigationController?.pushViewController(successClass, animated: true)
            }
        }
    }
    @IBAction func btn_TermsAndConditions_Tapped()
    {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 4
        privacyVc.title = "Terms & Conditions"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    @IBAction func btn_FAQ_Tapped()
    {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 3
        privacyVc.title = "FAQ"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
