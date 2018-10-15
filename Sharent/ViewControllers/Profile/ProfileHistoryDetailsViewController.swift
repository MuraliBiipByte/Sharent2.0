//
//  ProfileHistoryDetailsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ProfileHistoryDetailsViewController: UIViewController
{

    var referenceId = String()
    var strUserId = String()
    var strUserType = String()
    var strProductId = String()
    
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var btnWriteReview:UIButton!

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
    
    
    var productStartDate = String()
    var productEndDate = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.scrollView.isHidden = true
        self.btnWriteReview.isHidden = true

        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
    
        getReferenceDetails()
    }
    func getReferenceDetails()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"reference_id":referenceId]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BUYER_HISTORY_DETAILS, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                self.scrollView.isHidden = true
                return
                
            }
            else
            {
                self.scrollView.isHidden = false

                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as! [String:AnyObject]
                print(dataDictionary)
                let productsDetailsDictionary = dataDictionary["products"]as! [String:AnyObject]
                _ = ProductInformation.init(productDetailsDictionay: productsDetailsDictionary)
                self.strProductId = ProductInformation.productID!
                print(self.strProductId)
                self.productStartDate = ProductInformation.productFromDate!
                self.productEndDate = ProductInformation.productToDate!
                self.lblProductname.text = ProductInformation.productName!
                self.lblProductRentalPeriodDays.text = String(format: "%@ Days", String(describing:ProductInformation.productRentalDays!))
                self.lblProductRentalPeriodDates.text = String(format: "(%@ - %@)", self.productStartDate,self.productEndDate)
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
                
                if ProductInformation.productOrderstatus! == "14"
                {
                    if ProductInformation.productBuyerReviwed == "no"
                    {
                        self.btnWriteReview.isHidden = false
                    }
                    else
                    {
                        self.btnWriteReview.isHidden = true
                        
                    }
                }
            }
        }
        
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    @IBAction func btnReview_Tapped(_ sender: Any)
    {
        let WriteReview = storyboard?.instantiateViewController(withIdentifier: "BuyerRatingViewController")as! BuyerRatingViewController
        WriteReview.strProductId = self.strProductId
        WriteReview.referenceId = self.referenceId
        self.navigationController?.pushViewController(WriteReview, animated: true)
        
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)

    }
    
}
