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
    @IBOutlet weak var lblProductUsername:UILabel!
    @IBOutlet weak var productUserImage:UIImageView!
    @IBOutlet weak var lblProductname:UILabel!
   
    @IBOutlet weak var lblProductAttributes: UILabel!
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
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var btnConfirmOrder:UIButton!
    
    @IBOutlet weak var btn_lalamove_Return_status: UIButton!
    @IBOutlet weak var btn_lalamove_Collection_status: UIButton!
   
    
    var referenceProductId = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Booking Summary"

        scrollView.isHidden = true
        self.btnConfirmOrder.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.btn_lalamove_Collection_status.isHidden = true
        self.btn_lalamove_Return_status.isHidden = true
        
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
                self.showAlert(message: result as! String )
                return
            }
            else
            {
                self.scrollView.isHidden = false
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let productsDetailsDictionary = dataDictionary!["products"] as? [String:Any]
                _ = ProductInformation.init(productDetailsDictionay: productsDetailsDictionary!)
                self.lblProductUsername.text = ProductInformation.userName!
                
                let image =  String("\(WebServices.BASE_URL)\(ProductInformation.userImage ?? "")")
                self.productUserImage?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
                
                self.productUserImage.layer.cornerRadius = self.productUserImage.frame.size.height/2
                self.productUserImage.layer.masksToBounds = true
                
                self.lblProductname.text = ProductInformation.productName!
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
               
                self.lblProductRentalPeriodDays.text = String(format: "%@ Days", ProductInformation.productRentalDays!)
                self.lblProductRentalPeriodDates.text = String(format: "%@ to %@", ProductInformation.productFromDate!,ProductInformation.productToDate!)
                self.lblCollectionMethod.text =  ProductInformation.productCollectionmethod!
                self.lblReturnMethod.text = ProductInformation.productReturnmethod!
                self.lblProductReferenceId.text = ProductInformation.productReferenceId!
                self.lblRentalFee.text = String(format: "$ %@", ProductInformation.productRental!)
                self.lblShippingFee.text = String(format: "$ %@", ProductInformation.productShipping!) 
                self.lblDiscount.text = String(format: "$ %@", ProductInformation.productDiscount!)
                self.lblTotal.text = String(format: "$ %@", ProductInformation.productTotalFee!)
                self.lblProductStatusName.text = ProductInformation.productStatus!
                self.lblProductMerchantRemarks.text = ProductInformation.marchantRemarks!
                self.lblProductStartTime.text = String(format: "%@ %@", ProductInformation.productFromDate!,ProductInformation.productStartTime!)
                 self.lblProductEndTime.text = String(format: "%@ %@", ProductInformation.productToDate!,ProductInformation.productEndTime!)
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
                
                switch Int(ProductInformation.productOrderstatus!)
                {
                case 1,2:if ProductInformation.productCollectionmethod! == "Self"
                        {
                    self.btnConfirmOrder.setTitle("ITEM HAS BEEN COLLECTED", for: .normal)
                    self.btnConfirmOrder.tag = 1
                    self.btnConfirmOrder.isHidden = false
                        }
                    break
                case 4:
                   if ProductInformation.productReturnmethod! == "Self"
                    {
                        self.btnConfirmOrder.setTitle("ITEM HAS BEEN RETURNED", for: .normal)
                        self.btnConfirmOrder.tag = 0
                        self.btnConfirmOrder.isHidden = false
                    }
                case 7,8,9,16,17:
                    self.btnConfirmOrder.setTitle("ITEM HAS BEEN RETURNED", for: .normal)
                    self.btnConfirmOrder.tag = 0
                    self.btnConfirmOrder.isHidden = false
                    break
                default:
                    self.btnConfirmOrder.isHidden = true
                    break
                }
                
            }
        }
        
    }
    @IBAction func btn_confirm_order_tapped(_ sender: UIButton)
    {
        if self.btnConfirmOrder.tag == 0
        {
            let orderConfirmationVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
            orderConfirmationVc.referenceProductId = self.referenceProductId
            orderConfirmationVc.productUserId = ProductInformation.userId!
        self.navigationController?.pushViewController(orderConfirmationVc, animated: false)
        }
        else
        {
            let orderCollectionVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmCollectedViewController") as! ConfirmCollectedViewController
        self.navigationController?.pushViewController(orderCollectionVc, animated: false)
        }
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }

}
