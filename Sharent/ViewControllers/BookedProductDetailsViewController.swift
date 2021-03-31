//
//  BookedProductDetailsViewController.swift
//  Sharent
//
//  Created by Biipbyte on 05/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class BookedProductDetailsViewController: UIViewController
{
   
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var btnConfirmOrder:UIButton!
    @IBOutlet weak var btnConfirmHeight: NSLayoutConstraint!
    @IBOutlet weak var merchantCancelOrder: UIButton!
    @IBOutlet weak var merchantCancelHeight: NSLayoutConstraint!
    
    var ProductSummary = [String:Any]()
    var userId = String()
    var OrderId = String()
    var ProductId = String()
    var userLoginType = String()
    var statusDetail = String()
    var listingType = String()
    
    @IBOutlet weak var ProductnameLbl : UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var deliveryTypeLbl: UILabel!
    @IBOutlet weak var productRateLbl: UILabel!
//    @IBOutlet weak var attributeLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var BookingStatus: UILabel!
//    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    // product
    @IBOutlet weak var bookedCircleLbl: UILabel!
    @IBOutlet weak var lineLbl1: UILabel!
    @IBOutlet weak var circleLbl2: UILabel!
    @IBOutlet weak var confirmedLbl: UILabel!
    
    @IBOutlet weak var lineLbl2: UILabel!
    @IBOutlet weak var circleLbl3: UILabel!
    @IBOutlet weak var dispatchedLbl: UILabel!
    
    @IBOutlet weak var lineLbl3: UILabel!
    @IBOutlet weak var circleLbl4: UILabel!
    @IBOutlet weak var returnedLbl: UILabel!
    
    
    // venue or service
    @IBOutlet weak var vBookedCirlcle: UILabel!
    
    @IBOutlet weak var vline1: UILabel!
    @IBOutlet weak var vline2: UILabel!
    
    @IBOutlet weak var vCircle3: UILabel!
    
    @IBOutlet weak var vCircle2: UILabel!
    
    @IBOutlet weak var vConfirmedLbl: UILabel!
    
    @IBOutlet weak var vReturned: UILabel!
    
    @IBOutlet weak var bookingPlacedViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bookingPlacedView: UIView!
    
    
    // Buyer
    
    @IBOutlet weak var btnCancelBooking: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var btnCancelHeight: NSLayoutConstraint!
    @IBOutlet weak var btnReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookingStatusDetailLbl: UILabel!
   
    
    @IBOutlet weak var venueStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var venueStatusView: UIView!
    
    @IBOutlet weak var productStatusView: UIView!
    @IBOutlet weak var productStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var DescriptionLbl: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "BOOKING #\(OrderId)"
        
        scrollView.isHidden = true
        self.btnConfirmOrder.isHidden = true
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
       
        bookingPlacedView.isHidden = true
        bookingPlacedViewHeight.constant = 0
    
        self.lineLbl1.isHidden = false
        self.circleLbl2.isHidden = false
        self.lineLbl2.isHidden = false
        self.circleLbl3.isHidden = false
        self.lineLbl3.isHidden = false
        self.circleLbl4.isHidden = false
        
        
        self.vline1.isHidden = false
        self.vline2.isHidden = false
        self.vCircle2.isHidden = false
        self.vCircle3.isHidden = false
      
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        bookedCircleLbl.backgroundColor = APP_COLOR
        
        self.productStatusView.isHidden = true
        productStatusViewHeight.constant = 0.0
        productStatusViewHeight.isActive = true
        
        self.venueStatusView.isHidden = true
        venueStatusViewHeight.constant = 0.0
        venueStatusViewHeight.isActive = true
        
        
        self.btnCancelBooking.isHidden = true
        btnCancelHeight.constant = 0.0
        btnCancelHeight.isActive = true

        self.btnReview.isHidden = true
        btnReviewHeight.constant = 0.0
        btnReviewHeight.isActive = true
        
       
        self.btnConfirmOrder.isHidden = true
        btnConfirmHeight.constant = 0.0
        btnConfirmHeight.isActive = true
        
        
        self.merchantCancelOrder.isHidden = true
        merchantCancelHeight.constant = 0.0
        merchantCancelHeight.isActive = true
        
        getProductDetails()
    }

    @objc func getProductDetails()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"order_id":OrderId]
       
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.HISTORY_PRODUCTDETAILS, params: paramsDic) { (result, success) in
        self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String )
                return
            }
            else
            {
                self.scrollView.isHidden = false
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let productsDetailsDictionary = dataDictionary!["products"] as? [String:Any]
                self.ProductSummary = productsDetailsDictionary!
                _ = ProductInformation.init(productDetailsDictionay: productsDetailsDictionary!)
                
                // view1
                let image =  String("\(WebServices.BASE_URL)\(ProductInformation.productImage1 ?? "")")
                self.productImage?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
                
                self.ProductnameLbl.text = ProductInformation.productName!
                self.ProductId = ProductInformation.productID!
                
//                self.listingType = ProductInformation.listingType!
                
                 self.listingType = PRODUCT
                
                if ProductInformation.productToDate != "" {
                    self.startDateLbl.text = String(format: "%@ - %@", ProductInformation.productFromDate!,ProductInformation.productToDate!)
                    self.statusDetail = ProductInformation.productToDate!
                    
                }else{
                     self.startDateLbl.text = String(format: "%@", ProductInformation.productFromDate!)
                        self.statusDetail = ProductInformation.productFromDate!
                }
                
                self.deliveryTypeLbl.text =   ProductInformation.productDeliveryType  ?? ""
                
                self.productRateLbl.text = String(format:"$%@", ProductInformation.productTotalFee!)
                
                self.DateLbl.text = String(format:"%@",ProductInformation.modifiedDate!)

                // view 2

            self.BookingStatus.text =  ProductInformation.productStatus
           
                // user name & image
            self.userNameLbl.text = ProductInformation.userName!
           
                
                if self.listingType == PRODUCT {
                    self.productStatusView.isHidden = false
                    self.productStatusViewHeight.constant = 50.0
                }else{
                    
                    self.venueStatusView.isHidden = false
                   self.venueStatusViewHeight.constant = 50.0
                }
             
                
                if self.userLoginType == BUYER
                {
                  
                    print(Int(ProductInformation.productOrderstatus!)!)
                    switch 6
                    {
                        
                    case 1,2:
                        // booked
                        self.btnCancelBooking.isHidden = false
                        self.btnCancelHeight.constant = 40.0

                       
                        self.DescriptionLbl.text = " This Item booking has been received. Plase ensure that the product need to Confirm by the merchant.Thank you."
                        
                    self.bookingStatusDetailLbl.text = " Pending Merchant Confirmation"
                        
                        if self.listingType == PRODUCT{
                             self.booked()
                        }else{
                            self.vline1.backgroundColor = GUEST_COLOR
                            self.vCircle2.backgroundColor = GUEST_COLOR
                            self.vline2.backgroundColor = GUEST_COLOR
                            self.vCircle3.backgroundColor = GUEST_COLOR
                            self.vConfirmedLbl.textColor = GUEST_COLOR
                            self.vReturned.textColor = GUEST_COLOR
                        }
                        
                        break
                        
                    case 3,21,19:
                        // confirmed
                        // No buttons
                        self.DescriptionLbl.text = " This Item has been confirmed by the Merchant"
                        
                        self.bookingStatusDetailLbl.text = "Booking Scheduled for \(self.statusDetail)"
                        
                        if self.listingType == PRODUCT {
                            self.confirmed()
                        }else{
                            self.vline1.backgroundColor = APP_COLOR
                            self.vCircle2.backgroundColor = APP_COLOR
                            self.vline2.backgroundColor = GUEST_COLOR
                            self.vCircle3.backgroundColor = GUEST_COLOR
                            self.vConfirmedLbl.textColor = APP_COLOR
                            self.vReturned.textColor = GUEST_COLOR
                            
                        }
                        break
                        
                    case 4,5,6,7,8:
                        // dispatched
                        
                        self.DescriptionLbl.text = " This Item has been Dispatched."
                        
                        self.dispatched()
                        self.bookingStatusDetailLbl.text = "Delivery scheduled for \(self.statusDetail)"
                    break
                        
                    case 10,11,9,14 :
                        // returned
                        // no buttons
                        
                        self.DescriptionLbl.text = " This Item has been returned as of \(self.statusDetail). We hope that you enjoyed using the item and we would like to thankyou gor going beyond ownership"
                        self.btnConfirmOrder.isHidden = false
                        self.btnConfirmHeight.constant = 40.0
                        self.btnConfirmOrder.setTitle("View Order Summary", for: .normal)
                        self.btnConfirmOrder.tag = 4
                        
                        if self.listingType == PRODUCT {
                            self.returned()
                        }else{
                            self.vline1.backgroundColor = APP_COLOR
                            self.vCircle2.backgroundColor = APP_COLOR
                            self.vline2.backgroundColor = APP_COLOR
                            self.vCircle3.backgroundColor = APP_COLOR
                            self.vConfirmedLbl.textColor = APP_COLOR
                            self.vReturned.textColor = APP_COLOR
                            
                        }

                        if Int(ProductInformation.productOrderstatus!) == 14 {
                            if ProductInformation.productBuyerReviwed == "no"
                            {
                                self.btnReview.isHidden = false
                                self.btnReviewHeight.constant = 40.0
                               
                            }
                            
                        }
                        
                        
                        self.bookingStatusDetailLbl.text = "Item Returned on \(self.statusDetail)"
                        break
                    
                    case 12,20,22,13,17,18 :
                        // order cancelled
                        self.lineLbl1.backgroundColor = APP_COLOR
                        self.circleLbl4.backgroundColor = APP_COLOR
                        self.returnedLbl.text = "Declined"
                        //                        self.returnedLbl.textColor = APP_COLOR
                        self.DescriptionLbl.text = " This Item has been Cancelled."
                        
                        self.lineLbl1.isHidden = false
                        self.circleLbl2.isHidden = true
                        self.lineLbl2.isHidden = true
                        self.circleLbl3.isHidden = true
                        self.lineLbl3.isHidden = true
                        self.circleLbl4.isHidden = false
                        
                        self.confirmedLbl.textColor = .clear
                        self.dispatchedLbl.textColor = .clear
                        self.returnedLbl.textColor = APP_COLOR
                        
                        
                        self.bookingStatusDetailLbl.text = "Booking Declined by Merchant"
                        
                        self.vline1.isHidden = false
                        self.vline1.backgroundColor = APP_COLOR
                        
                        self.vCircle2.isHidden = true
                        self.vline2.isHidden = true
                        
                        self.vCircle3.backgroundColor = APP_COLOR
                        self.vCircle3.isHidden = false
                        
                        self.vConfirmedLbl.textColor = .clear
                        self.vReturned.textColor = APP_COLOR
                        
                        
                        break
                        
//                    case 18 :
//                        // issue flagged
//                        self.lineLbl1.backgroundColor = APP_COLOR
//                        self.circleLbl4.backgroundColor = APP_COLOR
//                        break
                    default:
                        
                        self.bookingStatusDetailLbl.text = "Booking Declined by Merchant"
                        self.DescriptionLbl.text = "This item has been Declined by Merchant"
                        
                        print("Need to do something")
                        
                    }
                }
                else{
                    
                    
                    self.bookingPlacedView.isHidden = false
                    self.bookingPlacedViewHeight.constant = 40
                     self.bookingStatusDetailLbl.text = ""
                    print(Int(ProductInformation.productOrderstatus!)!)
                    switch Int(ProductInformation.productOrderstatus!)!
                    {
                    case 1,2:
                        
                        
                        
                        self.btnConfirmOrder.setTitle("Accept Booking", for: .normal)
                        self.merchantCancelOrder.setTitle("Decline Booking", for: .normal)
                       self.DescriptionLbl.text = " This Item booking has been received. Plase ensure that the product need to Confirm by the merchant Thank you."
                        
                        self.btnConfirmOrder.isHidden = false
                        self.btnConfirmHeight.constant = 40.0
                         self.btnConfirmOrder.tag = 0
                        
                        self.merchantCancelOrder.isHidden = false
                        self.merchantCancelHeight.constant = 40.0
//                        self.merchantCancelOrder.tag = 0
                        
                          if self.listingType == PRODUCT {
                            self.booked()
                          }else{
                            self.vline1.backgroundColor = GUEST_COLOR
                            self.vCircle2.backgroundColor = GUEST_COLOR
                            self.vline2.backgroundColor = GUEST_COLOR
                            self.vCircle3.backgroundColor = GUEST_COLOR
                            self.vConfirmedLbl.textColor = GUEST_COLOR
                            self.vReturned.textColor = GUEST_COLOR
                            
                            
                        }
                       
                     
                        break
                        
                    case 3,19,21:
                        
                        self.DescriptionLbl.text = " This Item has been confirmed by the Merchant"
                        
                        if self.listingType == PRODUCT {
                            self.confirmed()
                           
                            self.btnConfirmOrder.setTitle("Product Dispatched", for: .normal)
                            
                            self.btnConfirmOrder.isHidden = false
                            self.btnConfirmHeight.constant = 40.0
                            
                        }
                        else{
                            self.btnConfirmOrder.setTitle("Booking Completed", for: .normal)
                           
                            self.vline1.backgroundColor = APP_COLOR
                            self.vCircle2.backgroundColor = APP_COLOR
                            self.vline2.backgroundColor = GUEST_COLOR
                            self.vCircle3.backgroundColor = GUEST_COLOR
                            self.vConfirmedLbl.textColor = APP_COLOR
                            self.vReturned.textColor = GUEST_COLOR
                            self.btnConfirmOrder.isHidden = false
                            self.btnConfirmHeight.constant = 40.0
                           
                        }
                       self.btnConfirmOrder.tag = 1
                        
                        break
                    case 4,5,6,7,8:
                        
                        self.dispatched()
                        
                      
                        
                        if self.listingType == PRODUCT {
                              self.DescriptionLbl.text = " This Item has been Dispatched."
                        }else{
                            self.DescriptionLbl.text = ""
                        }
                        self.btnConfirmOrder.setTitle("Product Received", for: .normal)
                        
                        self.btnConfirmOrder.isHidden = false
                        self.btnConfirmHeight.constant = 40.0
                        self.btnConfirmOrder.tag = 2
                        self.DescriptionLbl.text = ""
                        
                      
                        break
                    case 10,11,9,14:
                        
                          if self.listingType == PRODUCT {
                             self.returned()
                          }else{
                            
                            self.vline1.backgroundColor = APP_COLOR
                            self.vCircle2.backgroundColor = APP_COLOR
                            self.vline2.backgroundColor = APP_COLOR
                            self.vCircle3.backgroundColor = APP_COLOR
                            self.vConfirmedLbl.textColor = APP_COLOR
                            self.vReturned.textColor = APP_COLOR
                            self.btnConfirmOrder.isHidden = false
                            self.btnConfirmHeight.constant = 40.0
                            
                          }
                       
                          self.DescriptionLbl.text = " This Item has been returned as of \(self.statusDetail). We hope that you enjoyed using the item and we would like to thankyou gor going beyond ownership"
                          
                    
                        if Int(ProductInformation.productOrderstatus!) == 14 {
                            
                            self.btnConfirmOrder.isHidden = false
                            self.btnConfirmHeight.constant = 40.0
                            self.btnConfirmOrder.tag = 3
                            self.btnConfirmOrder.setTitle("Email Receipt", for: .normal)
                        }
                        
                        break
                        
                    case 12,20,22,13,17,18:
                        
                        
                        self.lineLbl1.backgroundColor = APP_COLOR
                        self.circleLbl4.backgroundColor = APP_COLOR
                        self.returnedLbl.text = "Declined"
                       
                        self.lineLbl1.isHidden = false
                        self.circleLbl2.isHidden = true
                        self.lineLbl2.isHidden = true
                        self.circleLbl3.isHidden = true
                        self.lineLbl3.isHidden = true
                        self.circleLbl4.isHidden = false
                        
                        self.confirmedLbl.textColor = .clear
                        self.dispatchedLbl.textColor = .clear
                        self.returnedLbl.textColor = APP_COLOR
                        
                      
                        self.vline1.isHidden = false
                        self.vline1.backgroundColor = APP_COLOR
                        
                        self.vCircle2.isHidden = true
                        self.vline2.isHidden = true
                        
                        self.vCircle3.backgroundColor = APP_COLOR
                        self.vCircle3.isHidden = false
                        
                        self.vConfirmedLbl.textColor = .clear
                        self.vReturned.textColor = APP_COLOR
                        self.bookingStatusDetailLbl.text = "Booking Declined by Merchant"
                        
                          self.DescriptionLbl.text = "This item has been Cancelled by Merchant"
                        break
                        
                        
                    default:
                        self.btnConfirmOrder.isHidden = true
                        self.merchantCancelOrder.isHidden = true
                        self.DescriptionLbl.text = "This item has been Declined by Merchant"
                        
                        break
                    }
                }
  
            }
        }
    }
    
    
    
    
    func booked() {
        
        self.lineLbl1.backgroundColor = GUEST_COLOR
        self.circleLbl2.backgroundColor = GUEST_COLOR
        self.lineLbl2.backgroundColor = GUEST_COLOR
        self.circleLbl3.backgroundColor = GUEST_COLOR
        self.lineLbl3.backgroundColor = GUEST_COLOR
        self.circleLbl4.backgroundColor = GUEST_COLOR
        self.confirmedLbl.textColor = GUEST_COLOR
        self.dispatchedLbl.textColor = GUEST_COLOR
        self.returnedLbl.textColor = GUEST_COLOR
    }
    func confirmed() {
        
        self.lineLbl1.backgroundColor = APP_COLOR
        self.circleLbl2.backgroundColor = APP_COLOR
        self.lineLbl2.backgroundColor = GUEST_COLOR
        self.circleLbl3.backgroundColor = GUEST_COLOR
        self.lineLbl3.backgroundColor = GUEST_COLOR
        self.circleLbl4.backgroundColor = GUEST_COLOR
        self.confirmedLbl.textColor = APP_COLOR
        self.dispatchedLbl.textColor = GUEST_COLOR
        self.returnedLbl.textColor = GUEST_COLOR
    }
    
    func dispatched() {
        self.lineLbl1.backgroundColor = APP_COLOR
        self.circleLbl2.backgroundColor = APP_COLOR
        self.lineLbl2.backgroundColor = APP_COLOR
        self.circleLbl3.backgroundColor = APP_COLOR
        self.lineLbl3.backgroundColor = GUEST_COLOR
        self.circleLbl4.backgroundColor = GUEST_COLOR
        self.confirmedLbl.textColor = APP_COLOR
        self.dispatchedLbl.textColor = APP_COLOR
        self.returnedLbl.textColor = GUEST_COLOR
    }
    
    func returned() {
        self.lineLbl1.backgroundColor = APP_COLOR
        self.circleLbl2.backgroundColor = APP_COLOR
        self.lineLbl2.backgroundColor = APP_COLOR
        self.circleLbl3.backgroundColor = APP_COLOR
        self.lineLbl3.backgroundColor = APP_COLOR
        self.circleLbl4.backgroundColor = APP_COLOR
        self.confirmedLbl.textColor = APP_COLOR
        self.dispatchedLbl.textColor = APP_COLOR
        self.returnedLbl.textColor = APP_COLOR
    }
    
    func merchantAcceptOrder(order_id: String,shipping_status : String) {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"order_id":order_id,"merchant_id":userId,"shipping_status":shipping_status]
        
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.MERCHANT_ACTIVATE_ORDER, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
              
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                
                self.getProductDetails()

            }
        }
    }
    
    
    @IBAction func btn_confirm_order_tapped(_ sender: UIButton)
    {
        if self.btnConfirmOrder.tag == 0
        {
            // accept order
             merchantAcceptOrder(order_id: OrderId, shipping_status: "19")
            
           
        }else if self.btnConfirmOrder.tag == 1 {
            let orderCollectionVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmCollectedViewController") as! ConfirmCollectedViewController
            if self.listingType == PRODUCT {
                orderCollectionVc.strStatus = "4"
            }else{
                orderCollectionVc.strStatus = "14"

            }
           
            self.navigationController?.pushViewController(orderCollectionVc, animated: false)
        }else if self.btnConfirmOrder.tag == 2 {
            
            let orderConfirmationVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
            orderConfirmationVc.orderId = self.OrderId
            orderConfirmationVc.productUserId = ProductInformation.userId!
            self.navigationController?.pushViewController(orderConfirmationVc, animated: false)
        }else if self.btnConfirmOrder.tag == 3 {
            getEmailReceipt()
           
        }
        else if self.btnConfirmOrder.tag == 4 {
           // view order summary
            
            let orderSummaryVc = self.storyboard?.instantiateViewController(withIdentifier: "ViewOrderSummaryViewController") as! ViewOrderSummaryViewController
            orderSummaryVc.OrderSummary = self.ProductSummary
//            orderConfirmationVc.productUserId = ProductInformation.userId!
            self.navigationController?.pushViewController(orderSummaryVc, animated: false)
            
        }
    
    }
    
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        let orderConfirmationVc = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsViewController") as! MyBookingsViewController
        
        self.navigationController?.pushViewController(orderConfirmationVc, animated: false)
//        self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func btn_lalamove_Collection_status_tapped(_ sender: UIButton)
//    {
//        self.productLalamoveStatus(method: "collection")
//    }
    func productLalamoveStatus(method:String)
    {
        if let dotRange = OrderId.range(of: "-")
        {
            OrderId.removeSubrange(dotRange.lowerBound..<OrderId.endIndex)
        }
        let paramsDic = ["api_key_data":WebServices.API_KEY,"reference_id":OrderId,"method":method]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.LALAMOVE_PRODUCT_STATUS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String,selector:#selector(self.backVc))
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
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    
    @IBAction func Cancel_Order_Tappped(_ sender: Any) {
        
        merchantAcceptOrder(order_id: OrderId, shipping_status: "20")
    }
    
    
    
    @IBAction func btnCancelBooking_Tapped(_ sender: Any) {
        let cancelOrderCalss = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
        self.navigationController?.pushViewController(cancelOrderCalss, animated: false)
    }
    
    @IBAction func review_Tapped(_ sender: Any) {
        let WriteReview = storyboard?.instantiateViewController(withIdentifier: "BuyerRatingViewController")as! BuyerRatingViewController
        WriteReview.strProductId = self.ProductId
        WriteReview.strOrderId = self.OrderId
        self.navigationController?.pushViewController(WriteReview, animated: true)
        
    }
    
    func getEmailReceipt() {
        
      
        let paramsDic = ["api_key_data":WebServices.API_KEY,"order_id":OrderId,"merchant_id":userId]
        
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
    
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }

}
