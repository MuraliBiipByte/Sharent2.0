//
//  ConfirnAddtoCartVC.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import UITextView_Placeholder

class ConfirmAddtoCartVC: UIViewController, FloatRatingViewDelegate,UITextViewDelegate {

   
    var count : Int = 0
    var strAttribute1 = String()
    var strAttribute2 = String()
    var position1 = String()
    var position2 = String ()
    var qtyposition = String ()

    var strClrPosition : String = "0"
    var strSizePosition : String = "0"
    var strQtyPosition : String = "0"
    var categoryId = String()
    var ProductData = [String:Any]()
    var attribute1 = String()
    var attribute2 = String()
    
    var minimumDays = Int()
    var maximumQty = Int()
    
    var advanceBookingDays = Int()
    var cartID = String()
    var dateFormatter = DateFormatter()
    var updateCart = false
    
    @IBOutlet weak var txtColour: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var colourViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sizeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var StartTimeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var QuantityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var EndDateViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDetails: UILabel!
    @IBOutlet weak var merchantImage: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var specialRequestTxt: UITextView!
    
    @IBOutlet weak var btnConfirmCart: UIButton!
    
    @IBOutlet weak var attribute1Title: UILabel!
    @IBOutlet weak var attribute2Title: UILabel!
//    @IBOutlet weak var lblBookingDate: UITextField!
    @IBOutlet weak var lblBookingStart_time: UITextField!
//    @IBOutlet weak var serviceView: UIView!
//    @IBOutlet weak var productsView: UIView!
    
    var type = String()
    var strProductId = String()
     var strUserId = String()
    var strPrice = String()
    
    var selectedArr = [String]()

     var intAttributesCount = Int()
     var arrAttribute1Name = NSMutableArray()
    var arrAttribute2Name = NSMutableArray()
    var arrAttribute1 = [AnyObject]()
    var arrAttribute2 = [AnyObject]()
    
     var arrQuantityName = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "ADD TO CART"
        specialRequestTxt.placeholder = "  Request for the Product "

        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String

        colourViewHeight.constant = 0
        sizeViewHeight.constant = 0
        StartTimeViewHeight.constant = 0
        EndDateViewHeight.constant = 0
        QuantityViewHeight.constant = 0
        
        
        let marchantImage = String("\(WebServices.BASE_URL)\(String(describing: self.ProductData["company_image"]!))")
        self.merchantImage.sd_setImage(with: URL(string: marchantImage), placeholderImage: #imageLiteral(resourceName: "userplaceholder"))

        merchantImage.layer.cornerRadius = merchantImage.frame.size.width / 2
        merchantImage.layer.masksToBounds = true

        self.merchantName.text = self.ProductData["merchant_name"]as? String

        self.lblProductName.text = self.ProductData["product_name"]as? String
        strProductId = self.ProductData["product_id"] as! String
        strPrice = self.ProductData["price"] as! String

        self.lblProductDetails.text = self.ProductData["merchant_address"]as? String
        self.categoryId = self.ProductData["category"] as! String
        
        let advDays = self.ProductData["advance_booking_date"] as Any
        self.advanceBookingDays = Int(advDays as? String ?? "") ?? 0
        
        let minimumDays = self.ProductData["minimum_days"] as Any
        self.minimumDays = Int(minimumDays as? String ?? "") ?? 0
        
        
        self.ratingView.editable = false
        let rating = String(describing:self.ProductData["average_rating"]as AnyObject)
        self.ratingView.rating = Double(rating)!
        self.ratingView.type = .wholeRatings
        self.ratingView.delegate = self
        self.ratingView.backgroundColor = UIColor.clear

        let ratings = String(describing:self.ProductData["total_ratings"]as AnyObject)
        self.lblRate.text = "\(ratings) ratings"
        

        _ = ProductInformation.init(productDetailsDictionay: self.ProductData)
       
        guard let attributes = self.ProductData["attribute"] as? [String:AnyObject] else
        {
            return
        }
        let attributesData = self.ProductData["available_attribute"]as? [String:AnyObject]
        let keys = Array(attributes.keys)
        self.intAttributesCount = keys.count
        switch self.intAttributesCount
        {
        case 1:

            self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
            self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
            self.attributesloop(mainAttributeArray: self.arrAttribute1, arrAttributeName: self.arrAttribute1Name)

            ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String

            break

        case 2:
            self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
            self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
            self.attributesloop(mainAttributeArray: self.arrAttribute1, arrAttributeName: self.arrAttribute1Name)

            ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String

            self.strAttribute2 = ProductInformation.attribute!["attribute_2"] as! String
            self.arrAttribute2 = (attributesData!["available_attribute_2"] as? [AnyObject])!

            self.attributesloop(mainAttributeArray: self.arrAttribute2, arrAttributeName: self.arrAttribute2Name)

            ProductInformation.attribute2Name = self.arrAttribute2Name[0] as? String

            break
        default:

            return
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        if cartID != "" {
            getAttributes(cartid: cartID)
            btnConfirmCart.setTitle("Update to Cart", for: UIControl.State.normal)
        }
        
        attribute1Title.text = strAttribute1.uppercased()
        txtColour.placeholder = "Select \(strAttribute1)"
        attribute2Title.text = strAttribute2.uppercased()
        txtSize.placeholder = "Select \(strAttribute2)"
      
        self.attribute1Title.text = strAttribute1
        self.attribute2Title.text = strAttribute2
       
        self.type  = self.ProductData["type"] as! String
        
        if  self.attribute1Title.text  != "" {
            colourViewHeight.constant = 70
        }
        if self.attribute2Title.text  != "" {
            sizeViewHeight.constant = 70
        }
        
        if type == PRODUCT{
            
            let quantity = self.ProductData["quantity"] as Any
            self.maximumQty = Int(quantity as? String ?? "") ?? 0
            if self.maximumQty != 0 {
                for i in 1...self.maximumQty {
                    arrQuantityName.append(String(i))
                    
                }
            }else{
                 arrQuantityName.append(String(1))
            }
            
          
            StartTimeViewHeight.constant = 0
            EndDateViewHeight.constant = 70
            QuantityViewHeight.constant = 70
            
        }
            
        else {

            StartTimeViewHeight.constant = 70
            EndDateViewHeight.constant = 0
            QuantityViewHeight.constant = 0
            
        }
    }

    
    func getAttributes(cartid : String)
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"cart_id":cartID,"user_id":strUserId]
    
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.EDIT_CART_ITEM, params: paramsDic)
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
                let data = resultDictionary ["data"] as! [String:Any]
                
                let arrProductDetails : [AnyObject] = (data["cart_data"] as? [AnyObject]) != nil  ?  (data["cart_data"] as! [AnyObject]) : []
                
               let dict = arrProductDetails[0]
                self.specialRequestTxt.text =  dict["special_request"] as? String

                self.type  = dict["product_type"] as? String ?? ""
               
               self.position1 = dict["attribute_position1"] as! String
               self.position2 = dict["attribute_position2"] as! String
               self.qtyposition = dict["quantity_position"] as! String

                
                if self.arrAttribute1Name.count > 0  {
                     self.txtColour.text = self.arrAttribute1Name[Int(self.position1)!] as? String
                    self.strClrPosition = self.position1
                    
                }

                if self.arrAttribute2Name.count > 0  {
                     self.txtSize.text = self.arrAttribute2Name[Int(self.position2)!] as? String
                    self.strSizePosition = self.position2
                }
             
                if self.type == PRODUCT {
                    
                    self.txtQuantity.text = "\(self.arrQuantityName[Int(self.qtyposition)!])"
                    
                    self.strQtyPosition = self.qtyposition
                }
                
                   self.txtStartDate.text = dict["start_date"] as? String ?? ""
                   self.txtEndDate.text = dict["end_date"] as? String ?? ""

                    self.lblBookingStart_time.text =  dict["start_time"] as? String ?? ""
 
            }
        }
    }
    
    
    @IBAction func btn_confirmAddToCart_Tapped(_ sender: Any) {
        
        
        if self.type == PRODUCT {
            if self.txtStartDate.text == "" {
                 self.showAlert(message: "Please select Start Date")
            }
            if self.txtEndDate.text == "" {
                 self.showAlert(message: "Please select End Date")
            }
            
            if self.txtQuantity.text == "" {
                self.showAlert(message: "Please select Quantity")
            }
            else if arrAttribute1Name.count != 0  {
                if txtColour.text == "" {
                    self.showAlert(message: "Please select \(strAttribute1)")
                }else{
                    
                    if arrAttribute2Name.count != 0  {
                        if txtSize.text == "" {
                            self.showAlert(message: "Please select \(attribute2)")
                        }
                        else{
                            addSelectedItemToCart()
                        }
                    }else{
                        addSelectedItemToCart()
                    }
                }
                
            }else  if sizeViewHeight.constant != 0 {
                if txtSize.text == "" {
                    self.showAlert(message: "Please select \(strAttribute2)")
                }else{
                    addSelectedItemToCart()
                }
            }
            else{
                addSelectedItemToCart()
            }
         
        }
        else  {
            if txtStartDate.text == ""  {
                self.showAlert(message: "Please select Booking Date")

            }else if lblBookingStart_time.text == "" {
                self.showAlert(message: "Please select Booking Time")
            }else{
                addSelectedItemToCart()
            }
        }

    }
    
    func addSelectedItemToCart() {
       
        if self.attribute1Title!.text != "" {
            strAttribute1 = "\(self.attribute1Title.text!) : \(self.txtColour.text!)"
        }
        
        if self.attribute2Title!.text != "" {
            strAttribute2 = "\(self.attribute2Title.text!) : \(self.txtSize.text!)"
        }
        
         self.view.StartLoading()
        
        if !updateCart {
            
            let paramsDict  = ["api_key_data":WebServices.API_KEY,
                               "user_id":strUserId,
                               "product_id":strProductId,
                               "quantity":txtQuantity.text ?? "",
                               "product_name":self.lblProductName.text!,
                               "product_price":strPrice,
                               "product_type": type,
                               "start_date": self.txtStartDate.text!,
                               "end_date": self.txtEndDate.text!,
                               "start_time":self.strStartTime,
                               "attribute1" : strAttribute1,
                               "attribute2" : strAttribute2 ,
                               "attribute_position1" : strClrPosition,
                               "attribute_position2" : strSizePosition,
                               "quantity_position" : strQtyPosition,
                               "special_request": specialRequestTxt.text!]
                as [String : Any]
           
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.ADDTO_CART, params: paramsDict as [String : Any] )
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    let cartCount = UserDefaults.standard.value(forKey: "cart_count") as! Int
                    UserDefaults.standard.set(cartCount + 1, forKey: "cart_count")
                    
                    let response = result as! [String:Any]
                    let title = response["message"] as! String
                    let message = ""
                    let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                    successClass.strTitle = title
                    successClass.strMessage = message
                    successClass.categoryid = self.categoryId
                    
                    successClass.strFromCart = "AddedToCart"
                    self.navigationController?.pushViewController(successClass, animated: true)
                }
            }
        }
        
        else{
          
            let paramsDict  = ["api_key_data":WebServices.API_KEY,
                               "user_id":strUserId,
                               "cart_id":cartID,
                               "quantity":txtQuantity.text ?? "",
                               "start_date": self.txtStartDate.text!,
                              "end_date": self.txtEndDate.text!,
                               "start_time":self.lblBookingStart_time.text!,
                               "attribute1" : strAttribute1,
                               "attribute2" : strAttribute2 ,
                               "attribute_position1" : strClrPosition,
                               "attribute_position2" : strSizePosition,
                               "quantity_position" : strQtyPosition,
                               "special_request": specialRequestTxt.text!]
                
                as [String : Any]
            
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.UPDATE_CART_ITEM, params: paramsDict as [String : Any] )
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    
//                    let cartCount = UserDefaults.standard.value(forKey: "cart_count") as! Int
//                    UserDefaults.standard.set(cartCount + 1, forKey: "cart_count")
                    
                    let response = result as! [String:Any]
                    let title = response["message"] as! String
                    let message = ""
                    let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                    successClass.strTitle = title
                    successClass.strMessage = message
                    successClass.categoryid = self.categoryId
                    successClass.strFromCart = "AddedToCart"
                   
                    self.navigationController?.pushViewController(successClass, animated: true)
                }
            }
        }
   
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == specialRequestTxt
        {
            let newText = (specialRequestTxt.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                specialRequestTxt.resignFirstResponder()
                showAlert(message: "You can able to enter max 500 Characters")
                return false
            }
        }
        
        
        return true
    }
 
    @IBAction func SelectQuantity_Tapped(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose Quantity", rows: self.arrQuantityName, initialSelection: 0, doneBlock:
            {
                picker, value, index in
             
                self.txtQuantity.text = index as? String
                self.strQtyPosition = String(value)
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
  
    
    @IBAction func btn_changeColour_Tapped(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose \(attribute1)", rows: self.arrAttribute1Name as? [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
              
                    self.txtColour.text = index as? String
                    self.strClrPosition = String(value)
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func btn_selectSize_Tapped(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose \(attribute2)", rows: self.arrAttribute2Name as? [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                
                self.txtSize.text = index as? String
                self.strSizePosition = String(value)
                
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func Select_EndDate_Tapped(_ sender: Any) {

        if self.txtStartDate.text == ""
        {
            self.showAlert(message: "Please Select Start Date")
            return
        }
        else {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        let date = NSDate() //according to date format your date string
        let advBooking = Calendar.current.date(byAdding: .day, value: self.minimumDays, to: date as Date)
        
        let datePicker = ActionSheetDatePicker(title: "Booking Date", datePickerMode: UIDatePicker.Mode.date, selectedDate: advBooking, doneBlock:
        {
            picker, value, index in
            
            //This formeter is to show only Selected Date to User
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            self.RentalEndDate = value as! Date
       
            if self.RentalEndDate < self.RentalStartDate {
                self.showAlert(message: "Please Select End Date more than Start Date")
                return
            }else{
                let enddate = dateFormatter.string(from: self.RentalEndDate)
            
                        self.txtEndDate.text = enddate
            }
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = advBooking
        datePicker?.show()
        
        }
    
    }
    
    var RentalStartDate = Date()
    var RentalEndDate = Date()
    
    @IBAction func btn_bookingDate_Tapped(_ sender: Any) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        let date = NSDate() //according to date format your date string
        let advBooking = Calendar.current.date(byAdding: .day, value: self.advanceBookingDays, to: date as Date)
        
        let datePicker = ActionSheetDatePicker(title: "Booking Date", datePickerMode: UIDatePicker.Mode.date, selectedDate: advBooking, doneBlock:
        {
            picker, value, index in
            
            //This formeter is to show only Selected Date to User
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.RentalStartDate = value as! Date
          
            let startdate = dateFormatter.string(from: value as! Date)
          
            self.txtStartDate.text = startdate
            
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = advBooking
        datePicker?.show()
        
        
    }
    
    
    var strStartTime = String()
    @IBAction func btn_bookingTime_Tapped(_ sender: Any) {
 
        let extendedTime = Date()
            self.view.endEditing(true)
            let datePicker = ActionSheetDatePicker(title: "Start Time", datePickerMode: UIDatePickerMode.time, selectedDate: extendedTime, doneBlock:
            {
                picker, value, index in
                
                let dateFormatte = DateFormatter()
                dateFormatte.dateFormat = "hh:mm"
                self.strStartTime = dateFormatte.string(from: value as! Date)
//
//                 dateFormatte.dateFormat = "hh:mm"
//                let startTime = dateFormatte.string(from: value as! Date)
                
                self.lblBookingStart_time.text = self.strStartTime
                
            }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)

        datePicker?.show()

        
    }
    
    
    @IBAction func btn_backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }

}
