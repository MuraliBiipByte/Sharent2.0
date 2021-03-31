//
//  OrderConformationViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import Stripe
import LGSideMenuController

class OrderConformationViewController: UIViewController ,UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate
{
  
    @IBOutlet weak var scrollview: UIScrollView!
//    @IBOutlet weak var lblProduct_Name: UILabel!
//    @IBOutlet weak var lblProduct_Description: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_DeliveryFee: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var btnConformPay: UIButton!
    @IBOutlet weak var lbl_preAuthAmount: UILabel!
    @IBOutlet weak var lbl_promoCode: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var btnPromocode: UIButton!
    
    var btnConfirm = false
    var strUserId = String()
//    var refId = String()
    var strDiscount = String()
    var strDeliveryfee = String()
    var strPromocode = String()
    var strTotalAmount = String()
    var strRentalFee = String()
    var strPreauthFee = String()
    
    //We are receiving this customer id from previous class
    var customerId = String()
    var Common_Cart_Id = String()
    
    var arrAllItems = [AnyObject]()
    let dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var allItemsTV: UITableView!
    @IBOutlet weak var btnChangCard: UIButton!
    @IBOutlet weak var cardNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var cardNameHeight: NSLayoutConstraint!
//    @IBOutlet weak var cardDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var summaryTableHeight: NSLayoutConstraint!
    @IBOutlet weak var cardDisplayView: UIView!
    @IBOutlet weak var additionalInfoView: UIView!
    
    
    
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        
        txtPromoCode.delegate = self

        allItemsTV.dataSource = self
        allItemsTV.delegate = self
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        
        allItemsTV.estimatedRowHeight = 80.0
        allItemsTV.rowHeight = UITableViewAutomaticDimension
        self.allItemsTV.separatorColor = UIColor.white
        self.scrollview.isHidden = true
        
       
        self.additionalInfoView.isHidden = true
        self.title = "CHECKOUT"
    }
    
    
    
    func getRecentCard()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":strUserId]
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.LALAMOVE_GET_RECENT_CARD, params: paramsDic )
        { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                
                self.cardNameHeight.constant = 53
                self.cardNumberHeight.constant = 0
                self.cardName.text = "Add New Card"
                self.cardNumber.text = ""
                self.btnChangCard.setTitle("Add", for: UIControlState.normal)
                return
            }
            else
            {
                
                self.cardNumberHeight.constant = 24
                self.cardNameHeight.constant = 20.5
                let response = result as! [String:Any]
                let data = response["data"]as! [String:Any]
                let recentCard = data["recent_card"]as! [String:Any]
                let cardNumber = String(format: "**** **** **** %@", recentCard["card_last4"] as! String )
                let cardName = recentCard["card_brand"]as? String
                self.cardName.text = cardName
                self.cardNumber.text = cardNumber
                self.customerId = recentCard["customer_id"] as! String
                let cardName1 = STPCard.brand(from: cardName!)
                let cardImage = STPImageLibrary.brandImage(for: cardName1)
                self.cardImg.image = cardImage
                self.btnChangCard.setTitle("Change", for: UIControlState.normal)
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getCartSummary()

        self.getRecentCard()
    }
    
    
    
    func getCartSummary() {

        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id" : strUserId]
      
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.CART_SUMMARY, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.scrollview.isHidden = true
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.scrollview.isHidden = false
                
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                
                let summaryData = data["summary"] as? [AnyObject]
                let feeData = summaryData![0]
              
                self.strRentalFee = feeData["total_rental_fee"] as! String
                self.lbl_Price.text  = String(format: "$ %@", self.strRentalFee)
                
                self.strDeliveryfee = feeData["total_delivery_fee"] as! String
                 self.lbl_DeliveryFee.text  = String(format: "$ %@", self.strDeliveryfee)
              
                self.strPreauthFee =  feeData["total_preauth_fee"] as! String
                self.lbl_preAuthAmount.text  = String(format: "$ %@",  self.strPreauthFee)
                
                self.lbl_promoCode.text  = String(format: "$ %@", feeData["total_prmocode_fee"] as! String)
                
                self.strTotalAmount = feeData["total_amount"] as! String
                self.lbl_Total.text  = String(format: "$ %@",self.strTotalAmount )
                

                self.arrAllItems = (data["all_items"] as? [AnyObject]) != nil  ?  (data["all_items"] as! [AnyObject]) : []
                
                
                if self.arrAllItems.count > 0 {
                    self.allItemsTV.reloadData()
                }

            }
        }
        
    }
    
    
    @IBAction func btn_ChangeCard_Tapped(_ sender: Any) {
        let cardsClass = self.storyboard?.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
        self.navigationController?.pushViewController(cardsClass, animated: false)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
        
        cell.lblProductName.text = self.arrAllItems[indexPath.row]["product_name"] as? String
        var startingDate = String()
        var endingDate = String()
            
            //  booking date
            if let startDate = self.arrAllItems[indexPath.row]["start_date"] as? String
            {
                if startDate == "" {
//                    cell.lblBookedDays.text = String(format: "")
                }else{
                    
                    if dateFormatter.dateFormat == "dd-MM-yyyy" as String {
                        let date = dateFormatter.date(from: startDate)
                        dateFormatter.dateFormat = "dd MMM YYYY"
                        startingDate = dateFormatter.string(from: date!)
                      
                    }else{
//                        cell.lblBookingDate.text = String(format: "")
                    }
                    
                }
            }
        if let endDate = self.arrAllItems[indexPath.row]["end_date"] as? String
        {
            if endDate == "" {
                //                    cell.lblBookedDays.text = String(format: "")
            }else{
                
                if dateFormatter.dateFormat == "dd-MM-yyyy" as String {
                    let date = dateFormatter.date(from: endDate)
                    dateFormatter.dateFormat = "dd MMM YYYY"
                    endingDate = dateFormatter.string(from: date!)
                    
                }else{
    //           cell.lblBookingDate.text = String(format: "")
                }
            }
        }
        
        let quantity = self.arrAllItems[indexPath.row]["quantity"] as? String
        
        if startingDate == "" || endingDate == "" {
            cell.lblBookedDays.text = ""
        }else {
             cell.lblBookedDays.text = String(format : "%@ - %@ , Quantity : %@", startingDate,endingDate, quantity!)
        }
      
        cell.rentalFee.text = String(format: "$%@", self.arrAllItems[indexPath.row]["rental_fee"] as! String)
        
        cell.preauthorisationAmount.text = String(format: "$ %@", self.arrAllItems[indexPath.row]["preauth_fee"] as? String ?? "")

        cell .selectionStyle = UITableViewCellSelectionStyle .none
        self.summaryTableHeight.constant = CGFloat(self.arrAllItems.count * 80)
        
        return cell
    }
    @IBAction func btn_ConformPay(_ sender: Any)
    {
        if !btnConfirm {
            
            let alert = UIAlertController(title: "Confirmation",
                                          message: "I have read and agree to the Terms & Conditions and Refund Policy.",
                                          preferredStyle: .alert)
            
            let notAgree = UIAlertAction(title: "I Do Not Agree", style: .default, handler: { (action) -> Void in
                print("NotAgree selected!")
                self.additionalInfoView.isHidden = false
                self.btnConformPay.setTitle("Back To Home", for: UIControl.State.normal)
                self.btnConfirm = true
                
            })
            
            let agree = UIAlertAction(title: "I Agree", style: .default, handler: { (action) -> Void in
                print("Agree selected!")
                
                let paramsDict = ["api_key_data":WebServices.API_KEY,"country":"SG","rental_fee":self.strRentalFee ,"discount_price":self.strDiscount ,"promo_code":self.txtPromoCode.text!,"stripetoken":self.customerId,"shipping_amount":self.strDeliveryfee,"environment":"IOS", "user_id":self.strUserId,"common_cart_id":self.Common_Cart_Id,"total_amount":self.strTotalAmount,"preauth_fee":self.strPreauthFee,"additional_desc":"","currency":"SGD","payment_method":"Stripe"] as [String : Any]
                
                self.view.StartLoading()
                
                ApiManager().postRequest(service:WebServices.ORDER_PLACE, params: paramsDict)
                { (result, success) in
                    self.view.StopLoading()
                    
                    if success == false
                    {
                        
                        self.additionalInfoView.isHidden = true
                        self.btnConformPay.setTitle("Confirm Rental", for: UIControl.State.normal)
                        self.showAlert(message: result as! String)
                        return
                    }
                    else
                    {
                        
                        let response = result as! [String:Any]
                        
                        let refId = response["reference_id"] as? String ?? "0"
                        
                        self.sendReferenceID(refid: refId)
                        self.additionalInfoView.isHidden = false
                        
                    }
                }
            })
            
            alert.view.layer.cornerRadius = 25   // change corner radius
            alert.addAction(notAgree)
            alert.addAction(agree)
            
            present(alert, animated: true, completion: nil)
            
        }else{
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    
    func sendReferenceID(refid : String) {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"reference_id" : refid]
     
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.PAYMENT_HISTORY, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {

//               self.cardDisplayView.isHidden = false
                 self.additionalInfoView.isHidden = true
                self.btnConformPay.setTitle("Confirm Rental", for: UIControl.State.normal)
                
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                 self.scrollview.isHidden = false
//                self.cardDisplayView.isHidden = true
                self.additionalInfoView.isHidden = false
                
                self.btnConformPay.setTitle("Back To Home", for: UIControl.State.normal)
                 self.btnConfirm = true
               
                
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                
                let summaryData = data["summary"] as? [AnyObject]
                let feeData = summaryData![0]
                
                self.strRentalFee = feeData["total_rental_fee"] as! String
                self.lbl_Price.text  = String(format: "$ %@", self.strRentalFee)
                
                self.strDeliveryfee = feeData["total_delivery_fee"] as! String
                self.lbl_DeliveryFee.text  = String(format: "$ %@", self.strDeliveryfee)
                
                self.strPreauthFee =  feeData["total_preauth_fee"] as! String
                self.lbl_preAuthAmount.text  = String(format: "$ %@",  self.strPreauthFee)
                
                self.lbl_promoCode.text  = String(format: "$ %@", feeData["total_prmocode_fee"] as! String)
                
                self.strTotalAmount = feeData["total_amount"] as! String
                self.lbl_Total.text  = String(format: "$ %@",self.strTotalAmount )
                
                
                self.arrAllItems = (data["all_items"] as? [AnyObject]) != nil  ?  (data["all_items"] as! [AnyObject]) : []
                
                
                if self.arrAllItems.count > 0 {
                    self.allItemsTV.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        if !btnConfirm {
            self.navigationController?.popViewController(animated: true)
        }else{
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPromoCode_Tapped(_ sender: Any)   {
        self.view.endEditing(true)
        
        if self.txtPromoCode.text == ""
        {
            self.showAlert(message: "Please Enter PromoCode")
            self.txtPromoCode.resignFirstResponder()
            return
        }
        
        let paramsDict = ["api_key_data":WebServices.API_KEY,"promocode":self.txtPromoCode.text!,"rental_fee":self.strRentalFee ,"shipping_fee": self.strDeliveryfee ,"total_amount":self.strTotalAmount ]
        
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.CHECK_PROMOCODE, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                self.btnPromocode.isUserInteractionEnabled = false
                self.strPromocode = "0"
                self.lbl_promoCode.text = ""
                
                return
            }
            else
            {
                self.lbl_promoCode.text = "PROMO CODE APPLIED"
                let response = result as! [String:Any]
                let data = response["data"]as! [String:Any]
                
                self.strPromocode = self.txtPromoCode.text!
                self.btnPromocode.isUserInteractionEnabled = false
                
                self.strTotalAmount = data["total_amount"] as! String
                self.lbl_Total.text  = String(format: "$ %@", self.strTotalAmount)
                
                self.strDiscount = data["discount_amount"] as! String
                self.lbl_promoCode.text  = String(format: "$ %@", self.strDiscount)
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.txtPromoCode
        {
            self.btnPromocode.setTitle("APPLY", for: UIControlState.normal)
            self.btnPromocode.isUserInteractionEnabled = true
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func btnTerms_Conditions_Tapped(_ sender: Any)
    {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 4
        privacyVc.title = "TERMS & CONDITIONS"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
   
    
    @IBAction func goToPrivacyPolicyConditions(_ sender: Any) {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 0
        privacyVc.title = "PRIVACY POLICY"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
