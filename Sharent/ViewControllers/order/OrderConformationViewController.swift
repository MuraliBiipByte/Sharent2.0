//
//  OrderConformationViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class OrderConformationViewController: UIViewController ,UITextFieldDelegate
{
  
    
    @IBOutlet weak var lblProduct_Name: UILabel!
    @IBOutlet weak var lblProduct_Description: UILabel!
    @IBOutlet weak var lbl_NumberOf_Days: UILabel!
    @IBOutlet weak var lbl_Dates: UILabel!
    @IBOutlet weak var lblCollection_return: UILabel!
    @IBOutlet weak var lblReturntype: UILabel!
    @IBOutlet weak var lbl_Bookingreference: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_DeliveryFee: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    @IBOutlet weak var btnConformPay: UIButton!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTermsAndCondtions: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var btnPromocode: UIButton!
    
    var termsAccept = false

    var strDeliveryFee = String()
    var strUserId = String()
    var strUserName = String()
    var strUserPhone = String()
    var strProductId = String()
    var strFromDate = String()
    var strToDate = String()
    var strCollectionType = String()
    var strReturnType = String()
    var strCollectionCharge = String()
    var strReturnCharge = String()
    var strDiscount = String()
    var strPromocode = String()
    
    var strAttr1 = String()
    var strAttr1Name = String()
    var strAttr1FullAttribute = String()
    var strAttr2 = String()
    var strAttr2Name = String()
    var strAttr2FullAttribute = String()
    
    var strAdditionalNote = String()
    var strPaymentMethode = String()
    var strMarchantremark = String()

    var strPromoCodeType1 = ""
    var strPromoCodeType2 = ""
    
    //We are receiving this customer id from previous class
    var customerId = String()
    var strStartTime = String()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtPromoCode.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "Summary"
        
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        strUserName = UserDefaults.standard.value(forKey: "userName")! as! String
        strUserPhone = UserDefaults.standard.value(forKey: "user-phone")! as! String
        
        print("Product is is \(strProductId)")
        print("Customer Id \(customerId)")
        
        lblProduct_Name.text = ProductInformation.productName!
        
        lbl_Dates.text = "\(ProductInformation.productFromDate!) to \(ProductInformation.productToDate!)"
        
        
        lbl_NumberOf_Days.text = "\(String(ProductInformation.productRentalDays!)) Days"
        lblCollection_return.text = "\(strCollectionType)"
        lblReturntype.text = "\(strReturnType)"
        lbl_Price.text = "$\(ProductInformation.productRental!)"
        lbl_DeliveryFee.text = "$\(ProductInformation.productDeliveryCharges ?? "0")"
        lbl_Discount.text = "$\(ProductInformation.productDiscount ?? "0")"

        ProductInformation.productTotalFee = String(Int(ProductInformation.productRental!)! + Int(ProductInformation.productDeliveryCharges ?? "0")! - Int(ProductInformation.productDiscount ?? "0")!)
        
        print(ProductInformation.productTotalFee!)
        print(strDeliveryFee)

        lbl_Total.text = "$\( ProductInformation.productTotalFee!)"
        lbl_Bookingreference.text = strPaymentMethode
        
        guard let attributes = ProductInformation.attribute else
        {
            lblProduct_Description.text = nil
            strAttr1FullAttribute = ""
            strAttr2FullAttribute = ""
            return
        }
        let keys = Array(attributes.keys)
        
        switch keys.count
        {
        case 1:
            strAttr1 = attributes["attribute_1"] as! String
            strAttr1Name = ProductInformation.attribute1Name!
            lblProduct_Description.text = String(format: "(%@:%@)", strAttr1,strAttr1Name)
            strAttr1FullAttribute = String(format: "%@:%@", strAttr1,strAttr1Name)
        case 2:
            strAttr1 = attributes["attribute_1"] as! String
            strAttr1Name = ProductInformation.attribute1Name!
            strAttr2 = attributes["attribute_2"] as! String
            strAttr2Name = ProductInformation.attribute2Name!
            lblProduct_Description.text = String(format: "(%@:%@,%@:%@)", strAttr1,strAttr1Name,strAttr2,strAttr2Name)
            strAttr1FullAttribute = String(format: "%@:%@", strAttr1,strAttr1Name)
            strAttr2FullAttribute = String(format: "%@:%@", strAttr2,strAttr2Name)
        default:
            lblProduct_Description.text = nil
            strAttr1FullAttribute = ""
            strAttr2FullAttribute = ""
        }
        
        
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_ConformPay(_ sender: Any)
    {
        
        if termsAccept
        {
            
                print("Accepted")
        }
        else
        {
            self.showAlert(message: "Please Accept Terms And Conditions")
            return
        }
        
        let strMarchantId   =  ProductInformation.marchantId ?? ""
        let strMarchantName = ProductInformation.marchantName ?? ""
        let strMarchantNumber = ProductInformation.marchantNumber ?? ""
        let strMarchantLat = ProductInformation.marchantLat ?? ""
        let strMarchantLang = ProductInformation.marchantLang ?? ""
        let strMarchantAddress =  ProductInformation.marchantAddress ?? ""
        let strDiscount =  ProductInformation.productDiscount ?? "0.0"
        
        var paramsDict = [String:AnyObject]()
        paramsDict = ["api_key_data":WebServices.API_KEY,
                      "user_id":strUserId, "product_id":ProductInformation.productID!,"service_type":ProductInformation.productVehicle!,"country":"SG","merchant_name":strMarchantName,"merchant_phone": strMarchantNumber,"merchant_lat1":strMarchantLat ,"merchant_lang1": strMarchantLang ,"merchant_address1": strMarchantAddress ,"merchant_lat2": ProductInformation.productBuyerLat! ,"merchant_lang2":ProductInformation.productBuyerLang!,"merchant_address2":ProductInformation.productBuyerAddress! ,"delivery_user_name": strUserName ,"delivery_user_phone":"+65\(String(describing: strUserPhone))","delivery_remarks":self.strAdditionalNote,"total_amount":ProductInformation.productTotalFee!,"currency":"SGD","environment":"IOS","stripetoken":self.customerId,"payment_method":"Stripe","collection_method":strCollectionType,"collection_date":("\(ProductInformation.productFromDateUTC!)"),"return_method":strReturnType,"return_date":"\(ProductInformation.productToDateUTC!)","rental_period_days":ProductInformation.productRentalDays!,"shipping_amount":strCollectionCharge,"return_shipping_amount":strReturnCharge,"buyer_name":strUserName,"seller_id":strMarchantId,"rental_fee":ProductInformation.productRental!,"discount_price":strDiscount,"product_name":ProductInformation.productName!,"attribute1":strAttr1FullAttribute,"attribute2":strAttr2FullAttribute,"promo_code":strPromocode ,"additional_desc":strMarchantremark,"rental_period_startdate":ProductInformation.productFromDate!,"rental_period_enddate":ProductInformation.productToDate!,"product_fee":ProductInformation.productFee!,"product_fee_percentage":ProductInformation.productFeePercentage!,"start_time":self.strStartTime,"end_time":self.strStartTime] as [String : AnyObject]
        
        let preauthClass = self.storyboard?.instantiateViewController(withIdentifier: "PreAuthorizationViewController") as! PreAuthorizationViewController
        preauthClass.paramsDictionary = paramsDict
        self.navigationController?.pushViewController(preauthClass, animated: true)
        
    }
    
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_chk_Tapped(_ sender: Any)
    {
        if termsAccept
        {
            termsAccept = false
            btnCheck.setImage(#imageLiteral(resourceName: "uncheckPrivacy"), for:.normal)
        }
        else
        {
            termsAccept = true
            btnCheck.setImage(#imageLiteral(resourceName: "checkPrivacy"), for:.normal)
        }
    }
    @IBAction func btnPromoCode_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)
       
        if self.txtPromoCode.text == ""
        {
            self.showAlert(message: "Please Enter PromoCode")
            self.txtPromoCode.resignFirstResponder()
            return
        }
        
        var promocodeType = ""
        
        if self.strPromoCodeType1 == "Lalamove" || self.strPromoCodeType2 ==  "Lalamove"
        {
            promocodeType = "lalamove"
        }
        else{
            promocodeType = "Self"
            
        }
        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "promocode":self.txtPromoCode.text!,"shipping_method":promocodeType,"rental_fee":ProductInformation.productRental!,"shipping_fee":ProductInformation.productDeliveryCharges ?? "0"
        ]
        
        print("\(paramsDict)")
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.APPLY_PROMOCODE, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                self.btnPromocode.setImage(#imageLiteral(resourceName: "notverified"), for: UIControlState.normal)
                self.btnPromocode.backgroundColor = UIColor.clear
                self.btnPromocode.setTitle("", for: UIControlState.normal)
                self.btnPromocode.isUserInteractionEnabled = false
                self.strPromocode = "0"
                
                
                return
            }
            else
            {
                
                let response = result as! [String:Any]
                let data = response["data"]as! [String:Any]
                print(data)
                
                self.btnPromocode.setImage(#imageLiteral(resourceName: "verified"), for: UIControlState.normal)
                self.btnPromocode.backgroundColor = UIColor.clear
                self.btnPromocode.setTitle("", for: UIControlState.normal)
                self.strPromocode = self.txtPromoCode.text!
                self.btnPromocode.isUserInteractionEnabled = false
                
                let discount = data["discount"]as! String
                
                let total = (Int(ProductInformation.productTotalFee!))! - (Int(discount))!
                
                ProductInformation.productDiscount = String(describing: data["discount"]!)
                ProductInformation.productTotalFee = String(total)
                
               self.lbl_Price.text = "$\(ProductInformation.productRental!)"
               self.lbl_DeliveryFee.text = "$\(ProductInformation.productDeliveryCharges ?? "0")"
                self.lbl_Discount.text = "$\(ProductInformation.productDiscount ?? "0")"
                
                ProductInformation.productTotalFee = String(Int(ProductInformation.productRental!)! + Int(ProductInformation.productDeliveryCharges ?? "0")! - Int(ProductInformation.productDiscount ?? "0")!)

                self.lbl_Total.text = "$\( ProductInformation.productTotalFee!)"
                
                
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.txtPromoCode
        {
            self.btnPromocode.setTitle("APPLY", for: UIControlState.normal)
            self.btnPromocode.backgroundColor = UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1.0)
            self.btnPromocode.setImage(nil, for: UIControlState.normal)
            self.btnPromocode.isUserInteractionEnabled = true
            
            
            //Adjusting Price Details after removing promocode
            
            
            ProductInformation.productDiscount = "0"
             ProductInformation.productTotalFee = String(Int(ProductInformation.productRental!)! + Int(ProductInformation.productDeliveryCharges ?? "0")! - Int(ProductInformation.productDiscount ?? "0")!)
            self.lbl_Price.text = "$\(ProductInformation.productRental!)"
            self.lbl_DeliveryFee.text = "$\(ProductInformation.productDeliveryCharges ?? "0")"
            self.lbl_Discount.text = "$\(ProductInformation.productDiscount ?? "0")"
            self.lbl_Total.text = "$\( ProductInformation.productTotalFee!)"
            
            
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
        privacyVc.title = "Terms & Conditions"
        self.navigationController?.pushViewController(privacyVc, animated: true)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
