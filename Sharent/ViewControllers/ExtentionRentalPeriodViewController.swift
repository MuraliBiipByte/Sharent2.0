//
//  ExtentionRentalPeriodViewController.swift
//  Sharent
//
//  Created by Biipbyte on 23/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import Stripe

class ExtentionRentalPeriodViewController: UIViewController,STPAddCardViewControllerDelegate
{
    
    var userId = String()
    var referenceProductId = String()
    var strCurrentExtendEndDate = String()
    var extentionRentalDays = Int()
    var totalextentionRentalDays = String()
    var totalRentalDays = String()
    var extentionRentalFee = String()
  
    @IBOutlet weak var scrollView:UIScrollView!
   
    @IBOutlet weak var lblProductname:UILabel!
    @IBOutlet weak var lblProductAttributes:UILabel!
    @IBOutlet weak var lblProductRentalPeriodDays:UILabel!
    @IBOutlet weak var lblProductRentalPeriodDates:UILabel!
    @IBOutlet weak var lblCollectionMethod:UILabel!
    @IBOutlet weak var lblReturnMethod:UILabel!
    @IBOutlet weak var lblProductReferenceId:UILabel!
    @IBOutlet weak var lblRentalExtentionFee:UILabel!
    @IBOutlet weak var lblRentalExtentionRentalDays:UILabel!
    @IBOutlet weak var lblTotal:UILabel!
    @IBOutlet weak var lblNote:UILabel!
    @IBOutlet weak var btnPrivacyPolicy:UIButton!
    @IBOutlet weak var btnPrivacyPolicyText:UIButton!
    @IBOutlet weak var txtPaymentMethod:UITextField!
    @IBOutlet weak var btnConfirmPay:UIButton!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        
         userId = UserDefaults.standard.value(forKey: "user_id") as! String

         scrollView.isHidden = true
         btnConfirmPay.isHidden = true
        
        lblRentalExtentionRentalDays.text = String(format: " %d Days", self.extentionRentalDays)
        lblNote.text = " Note: Please Contact LaLamove or your driver to make changes of dates "
        btnPrivacyPolicyText.setTitle(" I agree to the Terms of Service & Privacy Policy ", for: .normal)
        self.txtPaymentMethod.text = "  Credit/Debit card"
        self.txtPaymentMethod.isEnabled = false
        
         getProductDetails()
  
    }
    
    func getProductDetails()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"reference_id":referenceProductId]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.HISTORY_PRODUCTDETAILS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String,selector:#selector(self.backVc))
                return
            }
            else
            {
                self.scrollView.isHidden = false
                self.btnConfirmPay.isHidden = false
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let productsDetailsDictionary = dataDictionary!["products"] as? [String:Any]
                _ = ProductInformation.init(productDetailsDictionay: productsDetailsDictionary!)
                
                
                self.lblProductname.text = ProductInformation.productName
                self.lblProductAttributes.text = ProductInformation.productDescription
                
                let totalRentalPeriodDays = self.extentionRentalDays + Int(ProductInformation.productRentalDays!)!
                self.totalRentalDays = String(format: "%d", totalRentalPeriodDays)
                self.lblProductRentalPeriodDays.text = String(format: "%d Days", totalRentalPeriodDays)
                self.lblProductRentalPeriodDates.text = String(format: "(%@ - %@)", ProductInformation.productFromDate!,self.strCurrentExtendEndDate)
                self.lblCollectionMethod.text =  ProductInformation.productCollectionmethod!
                self.lblReturnMethod.text = ProductInformation.productReturnmethod!
                self.lblProductReferenceId.text = ProductInformation.productReferenceId!
                let extentionRentalfee = Int(ProductInformation.productPrice!)! * self.extentionRentalDays
                self.extentionRentalFee = String(format: "%d", extentionRentalfee)
                self.lblRentalExtentionFee.text = String(format: "$%d", extentionRentalfee)
                self.lblTotal.text = "$\(self.extentionRentalFee)"
                self.totalextentionRentalDays = String(format: "%d", self.extentionRentalDays)
                let strAttr1 = ProductInformation.attribute1Name ?? ""
                let strAttr2 = ProductInformation.attribute2Name ?? ""
                
                if strAttr1 != ""
                {
                    self.lblProductAttributes.text = String(format: "(%@,%@)",strAttr1,strAttr2)
                }
                else
                {
                    self.lblProductAttributes.text = strAttr1
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btn_privacy_ploicy_tapped()
    {
        btnPrivacyPolicy.setImage(UIImage(named: "uncheckPrivacy"), for: .normal)
        btnPrivacyPolicy.setImage(UIImage(named: "checkPrivacy"), for: .selected)
        
            if btnPrivacyPolicy.isSelected
            {
                btnPrivacyPolicy.isSelected = false
            }
            else
            {
                btnPrivacyPolicy.isSelected = true
            }
    }
    
    @IBAction func btn_confirm_pay_tapped()
    {

       if btnPrivacyPolicy.isSelected
       {
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            addCardViewController.title = "$\(extentionRentalFee)"
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            present(navigationController,animated: true)
       }
       else
       {
        showAlert(message: " Please confirm Privacy Policy ")
       }
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController)
    {
        dismiss(animated: true, completion: nil)
        
        self.scrollView.isHidden = false
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock)
    {
        dismiss(animated: true, completion: nil)
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":userId,"product_id":ProductInformation.productID!,"product_name":ProductInformation.productName!,"extended_days":self.totalextentionRentalDays,"total_days":totalRentalDays,"start_date":ProductInformation.productFromDate!,"end_date":self.strCurrentExtendEndDate,"reference_id":self.referenceProductId,"total_amount":self.extentionRentalFee,"old_total_amount":ProductInformation.productTotalFee!,"merchant_id":ProductInformation.marchantId!,"merchant_name":ProductInformation.marchantName!,"stripetoken":token.tokenId]
        self.view.StartLoading()
        
        ApiManager().postRequest(service:WebServices.UPDATE_ORDER, params: paramsDic){ (result, success) in
        self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                self.scrollView.isHidden = false
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let title = resultDictionary["message"] as! String
                let message = "Enjoy your order and be a responsible member by taking good care of it!"
                let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                successClass.strTitle = title
                successClass.strMessage = message
                self.navigationController?.pushViewController(successClass, animated: true)
            }
        }
    }

    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        backVc()
        
    }
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func homeVc()
    {
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
        self.present(navigateToHome!, animated: true, completion: nil)
    }
    @IBAction func btn_privacy_policy_tapped(_ sender: UIButton)
    {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 4
        privacyVc.title = "Terms & Conditions"
        self.navigationController?.pushViewController(privacyVc, animated: true)
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
