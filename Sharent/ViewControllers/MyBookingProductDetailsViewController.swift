 //
//  MyBookingProductDetailsViewController.swift
//  Sharent
//
//  Created by Biipbyte on 17/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import EventKit

class MyBookingProductDetailsViewController: UIViewController
{
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var lblProductname:UILabel!
    @IBOutlet weak var lblProductAttributes:UILabel!
    @IBOutlet weak var lblProductRentalPeriodDays:UILabel!
    @IBOutlet weak var lblProductRentalPeriodDates:UILabel!
    @IBOutlet weak var lblCollectionMethod:UILabel!
    @IBOutlet weak var lblReturnMethod:UILabel!
    @IBOutlet weak var lblProductReferenceId:UILabel!
    @IBOutlet weak var lblRentalFee:UILabel!
    @IBOutlet weak var lblShippingFee:UILabel!
    @IBOutlet weak var lblDiscount:UILabel!
    @IBOutlet weak var lblTotal:UILabel!
    @IBOutlet weak var lblProductStatusName:UILabel!
    @IBOutlet weak var lblProductMerchantRemarks:UILabel!
    @IBOutlet weak var lblProductStartTime:UILabel!
    @IBOutlet weak var lblProductEndTime:UILabel!

    
    
    @IBOutlet weak var btnExtendRentalPeriod:UIButton!
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnConfirmOrder:UIButton!
    @IBOutlet weak var btnConfirmReturned:UIButton!
    
    
    @IBOutlet weak var btnExtendRentalPeriodHeight:NSLayoutConstraint!
    @IBOutlet weak var btnCancelHeight:NSLayoutConstraint!
    @IBOutlet weak var btnConfirmOrderHeight:NSLayoutConstraint!
    @IBOutlet weak var btnConfirmReturnedHeight:NSLayoutConstraint!

    
    @IBOutlet weak var btn_lalamove_Return_status: UIButton!
    @IBOutlet weak var btn_lalamove_Collection_status: UIButton!
    //Please refer the before class that we are receiving some the values from it
    
    var referenceProductId = String()
    var orderStatus = Int()
    var productId = String()
    var productName = String()
    var productDescription = String()
    var productImage = String()
    var productStartDate = String()
    var productEndDate = String()
    
    var merchantId = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Booking"
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
            scrollView.isHidden = true
        
             self.btn_lalamove_Collection_status.isHidden = true
             self.btn_lalamove_Return_status.isHidden = true
        
             self.btnCancel.isHidden = true
             self.btnConfirmOrder.isHidden = true
             self.btnConfirmReturned.isHidden = true
             self.btnExtendRentalPeriod.isHidden = true
        
             btnCancelHeight.constant = 0.0
             btnCancelHeight.isActive = true
        
            //Temporarly we are hiding this Extend Rental Period
             btnExtendRentalPeriodHeight.constant = 0.0
             btnExtendRentalPeriodHeight.isActive = true
        
             btnConfirmOrderHeight.constant = 0.0
             btnConfirmOrderHeight.isActive = true
        
            btnConfirmReturnedHeight.constant = 0.0
            btnConfirmReturnedHeight.isActive = true
        
        
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
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let productsDetailsDictionary = dataDictionary!["products"] as? [String:Any]
                
                _ = ProductInformation.init(productDetailsDictionay: productsDetailsDictionary!)
                
                self.merchantId = ProductInformation.marchantId!
                self.productId = ProductInformation.productID!
                self.productName = ProductInformation.productName!
                self.productImage = ProductInformation.productImage1!
                self.productStartDate = ProductInformation.productFromDate!
                self.productEndDate = ProductInformation.productToDate!
                self.lblProductname.text = self.productName
                self.lblProductRentalPeriodDays.text = String(format: "%@ Days", String(describing:ProductInformation.productRentalDays!))
                self.lblProductRentalPeriodDates.text = String(format: "(%@ to %@)", self.productStartDate,self.productEndDate)
                self.lblCollectionMethod.text = ProductInformation.productCollectionmethod!
                self.lblReturnMethod.text =  ProductInformation.productReturnmethod!
                self.lblProductReferenceId.text = ProductInformation.productReferenceId!
                self.lblRentalFee.text = String(format: "$ %@", ProductInformation.productRental!)
                self.lblShippingFee.text = String(format: "$ %@", ProductInformation.productShipping!)
                self.lblDiscount.text = String(format: "$ %@", ProductInformation.productDiscount!)
                self.lblTotal.text = String(format: "$ %@", ProductInformation.productTotalFee!)
                self.lblProductStatusName.text = ProductInformation.productStatus!
                self.lblProductMerchantRemarks.text = ProductInformation.marchantRemarks! 
                self.lblProductStartTime.text = String(format: "%@ %@", ProductInformation.productFromDate!,ProductInformation.productStartTime!)
                self.lblProductEndTime.text = String(format: "%@ %@", ProductInformation.productToDate!,ProductInformation.productEndTime!)
                
                let strAttr1 = ProductInformation.attribute1Name ?? ""
                let strAttr2 = ProductInformation.attribute2Name ?? ""
                
                if strAttr2 != ""
                {
                    self.lblProductAttributes.text = String(format: "(%@,%@)",strAttr1,strAttr2)
                }
                else
                {
                    self.lblProductAttributes.text = strAttr1
                }
                
                if ProductInformation.productCollectionmethod! == "Lalamove"
                {
                    self.btn_lalamove_Collection_status.isHidden = false
                  self.lblCollectionMethod.attributedText = NSAttributedString(string: ProductInformation.productCollectionmethod!, attributes:[.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
                }
                if ProductInformation.productReturnmethod! == "Lalamove"
                {
                    self.btn_lalamove_Return_status.isHidden = false
                    self.lblReturnMethod.attributedText = NSAttributedString(string: ProductInformation.productReturnmethod!, attributes:[.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
                }
                self.orderStatus = Int(ProductInformation.productOrderstatus!)!
                
                switch self.orderStatus
                {
                case 1...2:
                    
                    self.btnCancel.isHidden = false
                    self.btnCancelHeight.constant = 40.0
    
                default:
                    
                    print("Need to do something")
            
                }
              
                
            }
        }
        
    }
    
  @IBAction func  btnCancelTapped()
    {
        let cancelOrderCalss = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
        self.navigationController?.pushViewController(cancelOrderCalss, animated: false)
    }
    
    @objc func cancelOrder()
    {
        let cancelOrderCalss = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
        self.navigationController?.pushViewController(cancelOrderCalss, animated: false)
    }
    
    @IBAction func btn_Extend_Rental_Period_Tapped()
    {
        let extendDatesVc = self.storyboard?.instantiateViewController(withIdentifier: "ExtendDatesViewController") as! ExtendDatesViewController
        self.navigationController?.pushViewController(extendDatesVc, animated: false)
        
    }
    @IBAction func btn_confirm_Return_Tapped()
    {
        let orderReturnConfirmationVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmReturnedViewController") as! ConfirmReturnedViewController
        self.navigationController?.pushViewController(orderReturnConfirmationVc, animated: false)
    }
    @IBAction func btn_confirm_Order_Tapped()
    {
        let orderConfirmationVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        orderConfirmationVc.referenceProductId = self.referenceProductId
        orderConfirmationVc.merchantId = self.merchantId
        self.navigationController?.pushViewController(orderConfirmationVc, animated: false)
    }
    @IBAction func btn_lalamove_Collection_status_tapped(_ sender: UIButton)
    {
        self.productLalamoveStatus(method: "collection")
    }
    @IBAction func btn_lalamove_Return_status_tapped(_ sender: UIButton)
    {
        self.productLalamoveStatus(method: "return")
    }
    func productLalamoveStatus(method:String)
    {
        if let dotRange = referenceProductId.range(of: "-")
        {
            referenceProductId.removeSubrange(dotRange.lowerBound..<referenceProductId.endIndex)
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"reference_id":referenceProductId,"method":method]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.LALAMOVE_PRODUCT_STATUS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String )
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                _ = Lalamove.init(lalamoveDataDictionay: dataDictionary!)
                let lalamovestatusclass = self.storyboard?.instantiateViewController(withIdentifier: "LalamoveStatusViewController") as! LalamoveStatusViewController
                self.navigationController?.pushViewController(lalamovestatusclass, animated: false)
                
            }
        }
    }
    
    @IBAction func btn_Back_Tapped()
    {
       backVc()
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
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
