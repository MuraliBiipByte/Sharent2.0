//
//  ViewOrderSummaryViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit

class ViewOrderSummaryViewController: UIViewController {

     var OrderSummary = [String:Any]()
    
    @IBOutlet weak var bookingIdLbl: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDateLbl: UILabel!
    @IBOutlet weak var rentalFeeLbl: UILabel!
    @IBOutlet weak var deliveryFeeLbl: UILabel!
    @IBOutlet weak var promocodeLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "BOOKING SUMMARY"
        
        _ = ProductInformation.init(productDetailsDictionay: OrderSummary)
        
        self.bookingIdLbl.text = String(format:"Booking #%@",  ProductInformation.productOrderId!)
        
        self.productName.text = ProductInformation.productName!
        
        let quantity : String = ProductInformation.productMaximumQunantity!
        let startingDate : String = ProductInformation.productFromDate!
        let enddate : String = ProductInformation.productToDate!
        
        if enddate != "" {
            self.productDateLbl.text = String(format : "%@ - %@ , Quantity : %@", startingDate,enddate, quantity)
        }else{
            self.productDateLbl.text = String(format : "%@", startingDate)
        }
        
        
        
        self.rentalFeeLbl.text = String(format : "$ %@", ProductInformation.productRental!)
       
         self.deliveryFeeLbl.text = String(format : "$ %@", ProductInformation.productShipping!)
        
         self.promocodeLbl.text = String(format : "($ %@)", ProductInformation.productDiscount!)
        
         self.totalAmountLbl.text = String(format : "$ %@", ProductInformation.productTotalFee!)
        
        
    }
    
    @IBAction func email_receiptTapped(_ sender: Any) {
        
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"order_id":ProductInformation.productOrderId!,"merchant_id":ProductInformation.marchantId!] as [String : Any]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.MERCHANT_EMAIL_RECEIPT, params: paramsDic)
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
                self.showAlert(message: message!)
                
            }
        }
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
      
        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "BookedProductDetailsViewController") as! BookedProductDetailsViewController
         Vc.OrderId = ProductInformation.productOrderId!
        self.navigationController?.pushViewController(Vc, animated: false)
        
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    @IBAction func termsConditions_Tapped(_ sender: Any) {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 4
        privacyVc.title = "TERMS & CONDITIONS"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    
    @IBAction func refundPolicy_Tapped(_ sender: Any) {
        let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        privacyVc.urlIndex = 0
        privacyVc.title = "PRIVACY POLICY"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    
}
