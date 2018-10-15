//
//  OrderViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Stripe

class OrderViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    
    
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnStartTime: UIButton!
    @IBOutlet weak var btnEndTime: UIButton!
    @IBOutlet weak var txtAddionalNote: UITextView! //Delivery Remarks
    @IBOutlet weak var txtMarchantRemarks: UITextView!
    @IBOutlet weak var btnCollectionType: UIButton!
    @IBOutlet weak var btnReturnType: UIButton!
    @IBOutlet weak var btnProceedToPay: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMarchant_address: UILabel!
    @IBOutlet weak var lblMarchantAddresTitle: UILabel!
    
    
    //Card Related Details
    @IBOutlet weak var btnChangeCard: UIButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNameHeight: NSLayoutConstraint!
    @IBOutlet weak var cardNumberHeight: NSLayoutConstraint!
    
    var customerId =  String()
    
    var strProductId = String()
    var strProductName = String()
    var strUserId = String()
    var strUserName = String()
    var strUserPhone = String()
    var strUserCode = String()
    var strProductDescription = String()
    
    var strAttribute1 = String()
    var strAttribute2 = String()
    var strAttribute1Name = String()
    var strAttribute2Name = String()
    
    var strRentalAmount = String()
    var strDeliveryCharge = String()
    var strStartDate = String()
    var strStartTime = String()
    var strEndDate = String()
    var strEndTime = String()
    
    var startdate = String()
    var enddate = String()
    var arrCollectionType = NSMutableArray()
    var arrReutrnType = NSMutableArray()
    
    var strCollectionType = String()
    var strReturnType = String()
    var strPaymentMethod = "Credit/Debit Card"
    var placesClient: GMSPlacesClient!
    var arrAddress = [String]()
    var minutes = Int()
    var minimumTime = String()
    var strPromoCodeType1 = ""
    var strPromoCodeType2 = ""

    var refStr = String()
    var recentCard = String()
    var recentCardName = String()

    
    var strDeliveryRemarks = String()
    var strMerchantRemarks = String()
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Checkout"
        
        txtAddionalNote.text = "E.g Unit Number, Comments for driver"
        txtAddionalNote.textColor = UIColor.lightGray
        txtMarchantRemarks.text = "E.g Any special request for the merchant"
        txtMarchantRemarks.textColor = UIColor.lightGray
        
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        strUserName = UserDefaults.standard.value(forKey: "userName")! as! String
        strUserPhone = UserDefaults.standard.value(forKey: "user-phone")! as! String
    
        print("Product is is \(strProductId)")
        placesClient = GMSPlacesClient.shared()
        
        arrCollectionType = ["Lalamove","Self Collection"]
        arrReutrnType = ["Lalamove","Self Return"]
       
        
        self.lblMarchant_address.text = "  \(ProductInformation.marchantAddress ?? "")"
        
        let total = Int(ProductInformation.productPrice!)! -  Int(ProductInformation.productDiscount ?? "0" )!
        ProductInformation.productTotalFee = String(total)
        
        self.getRecentCard()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        if textView == txtAddionalNote
        {
            if self.txtAddionalNote.textColor == UIColor.lightGray
            {
                self.txtAddionalNote.text = nil
                self.txtAddionalNote.textColor = Constants.NAVIGATION_COLOR
            }
        }
       else
        {
            if self.txtMarchantRemarks.textColor == UIColor.lightGray
            {
            self.txtMarchantRemarks.text = nil
            self.txtMarchantRemarks.textColor = Constants.NAVIGATION_COLOR
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtAddionalNote
        {
        
            if self.txtAddionalNote.text.isEmpty
            {
            txtAddionalNote.text = "E.g Unit Number, Comments for driver"
            txtAddionalNote.textColor = UIColor.lightGray
         
            }
        }
        else{
            if self.txtMarchantRemarks.text.isEmpty
            {
         
            txtMarchantRemarks.text = "E.g Any special request for the merchant"
            txtMarchantRemarks.textColor = UIColor.lightGray
            }
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCard), name: NSNotification.Name(rawValue: "cardSelect"), object: nil)
    }
    @objc func refreshCard(notification: NSNotification)
    {
        
        let dict = notification.object as! NSDictionary
        let cardNumber = dict["card_last4"] as! String
        let cardName = dict["card_brand"] as! String
        self.customerId = dict["customer_id"] as! String
        self.lblCardNumber.text = String(format: " **** **** **** %@", cardNumber)
        self.lblCardName.text = cardName
        let cardName1 = STPCard.brand(from: cardName)
        let cardImage = STPImageLibrary.brandImage(for: cardName1)
        self.cardImage.image = cardImage
        self.btnChangeCard .setTitle("CHANGE", for: UIControlState.normal)
    }
    @IBAction func btn_EndDate_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if self.startdate .isEmpty || self.strStartTime .isEmpty
        {
            self.showAlert(message: "Please Select Start Date and Time")
            return
        }
        
        //This formeter is to set Current time to picker and incraes day
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        let date = dateFormatter.date(from: self.startdate) //according to date format your date string
        let tomorrow = Calendar.current.date(byAdding: .day, value: Int(ProductInformation.minimumdays!)!, to: date!)
        
        
        let datePicker = ActionSheetDatePicker(title: "End Date", datePickerMode: UIDatePickerMode.date, selectedDate: tomorrow, doneBlock:
        {
            picker, value, index in
            
            self.enddate = dateFormatter.string(from: value as! Date)
            self.btnEndDate.setTitle("  \(self.enddate)", for: UIControlState.normal)
            self.btnEndTime.setTitle("  \(self.strStartTime)", for: UIControlState.normal)
            
            ///Caleculating the difference
            let dateFrom = dateFormatter.date(from: self.startdate)
            let dateTo = dateFormatter.date(from: self.enddate)//according to date format your date string
            let  differenceInDays = Int((dateTo?.timeIntervalSince(dateFrom!))! / (60 * 60 * 24))
            
            ProductInformation.productFromDate = self.startdate
            ProductInformation.productToDate = self.enddate
            

            let finalStartDateTime = String(format: "%@ %@:00", self.startdate,self.strStartTime)
            
            let finalEndDateTime = String(format: "%@ %@:00", self.enddate,self.strStartTime)
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let showStartDate = inputFormatter.date(from: finalStartDateTime)
            let showEndDate = inputFormatter.date(from: finalEndDateTime)
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //This formatter is to Convert Date to UTC
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let toUTC = formatter.string(from: showStartDate!)
            let toUTC1 = formatter.string(from: showEndDate!)
            
            let convertedDate = formatter.date(from: toUTC)
            let convertedDate1 = formatter.date(from: toUTC1)
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            
            
            ProductInformation.productFromDateUTC = formatter.string(from: convertedDate!)
            print(ProductInformation.productFromDateUTC!)
            
            
            ProductInformation.productToDateUTC = formatter.string(from:convertedDate1!)
            print(ProductInformation.productToDateUTC!)
            
            ProductInformation.productRentalDays = String("\(differenceInDays)")
            ProductInformation.productRental = String("\(differenceInDays * Int(ProductInformation.productPrice!)! )" )
            
            let total = Int(ProductInformation.productRental!)! -  Int(ProductInformation.productDiscount ?? "0" )!
            ProductInformation.productTotalFee = String(total)
            
            print(differenceInDays)
            
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        
        
        datePicker?.minimumDate = tomorrow
        datePicker?.show()

     
    }
    
    @IBAction func btn_StartDate_Tapped(_ sender: Any)
    {
      
        self.view.endEditing(true)
        
        self.btnEndDate.setTitle("  Select", for: UIControlState.normal)
        self.btnStartTime.setTitle("  Select", for: UIControlState.normal)
        self.btnEndTime.setTitle("  Select", for: UIControlState.normal)
        self.strStartTime = ""
        self.enddate = ""
        ProductInformation.productFromDateUTC = ""
        ProductInformation.productFromDate = ""
        
        let datePicker = ActionSheetDatePicker(title: "Start Date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock:
        {
            picker, value, index in
            
            //This formeter is to show only Selected Date to User
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.startdate = dateFormatter.string(from: value as! Date)
            self.btnStartDate .setTitle(" \(self.startdate)", for: UIControlState.normal)
            
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.minimumDate = Date()
        
        datePicker?.show()
        
    }
    @IBAction func btn_StartTime_Tapped(_ sender: Any)
    {
        if self.startdate .isEmpty
        {
            self.showAlert(message: "Please Select Start Date")
            return
        }
        let startDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDateString = dateFormatter.string(from: startDate)
        
        let strStartTime = Date()
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        var extendedTime = Date()
        if self.startdate == currentDateString
        {
            extendedTime = calendar.date(byAdding: .hour, value: 4, to: strStartTime)!
        }
        self.view.endEditing(true)
        let datePicker = ActionSheetDatePicker(title: "Start Time", datePickerMode: UIDatePickerMode.time, selectedDate: extendedTime, doneBlock:
        {
            picker, value, index in
            
            let dateFormatte = DateFormatter()
            dateFormatte.dateFormat = "HH:mm"
            
            self.strStartTime = dateFormatte.string(from: value as! Date)
            self.btnStartTime.setTitle("  \(self.strStartTime)", for: UIControlState.normal)
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        if self.startdate == currentDateString
        {
            datePicker?.minimumDate = extendedTime
        }
        datePicker?.show()
        
    }

    @IBAction func btn_CollectionType_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)

        ActionSheetStringPicker.show(withTitle: "Select Method", rows: arrCollectionType as? [Any], initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            self.strCollectionType = (String(describing: index!) )
            self.strPromoCodeType1 = (String(describing: index!) )
            self.btnCollectionType.setTitle("  \(self.strCollectionType)", for: UIControlState.normal)
            if let spaceRange = self.strCollectionType.range(of: " ")
            {
        self.strPromoCodeType1.removeSubrange(spaceRange.lowerBound..<self.strCollectionType.endIndex)
        self.strCollectionType.removeSubrange(spaceRange.lowerBound..<self.strCollectionType.endIndex)
            }
 
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func btn_ReturnType_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)

        
        ActionSheetStringPicker.show(withTitle: "Select Method", rows: arrReutrnType as! [Any], initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            
            self.strReturnType = (String(describing: index!) )
            self.strPromoCodeType2 = (String(describing: index!) )
            self.btnReturnType.setTitle("  \(self.strReturnType)", for: UIControlState.normal)
            if let spaceRange = self.strReturnType.range(of: " ")
            {
        self.strPromoCodeType2.removeSubrange(spaceRange.lowerBound..<self.strReturnType.endIndex)
        self.strReturnType.removeSubrange(spaceRange.lowerBound..<self.strReturnType.endIndex)
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func btn_ProceedTotap_Tapped(_ sender: Any)
    {
        self.view.endEditing(true)

        if self.startdate .isEmpty || self.strStartTime .isEmpty
        {
            self.showAlert(message: "Please Select Start Date and Time")
            return
        }
        if self.enddate .isEmpty
        {
            self.showAlert(message: "Please Select End Date and Time")
            return
        }
        if self.strCollectionType .isEmpty
        {
            self.showAlert(message: "Please Select Collection Type")
            return
        }
        if self.strReturnType .isEmpty
        {
            self.showAlert(message: "Please Select Return Type")
            return
        }
        if self.strPaymentMethod .isEmpty
        {
            self.showAlert(message: "Please Select Payment Methode")
            return
        }
        if self.lblAddress.text == "Select Address"
        {
            self.showAlert(message: "Please Enter Delivery Address")
            return
        }
        if self.txtAddionalNote.text != ""
        {
            if self.txtAddionalNote.textColor == UIColor.lightGray
            {
                self.strDeliveryRemarks = "NA"
            }
            else
            {
                self.strDeliveryRemarks = self.txtAddionalNote.text
            }
        }
        if self.txtMarchantRemarks.text != ""
        {
            if self.txtMarchantRemarks.textColor == UIColor.lightGray
            {
                self.strMerchantRemarks = "NA"
            }
            else
            {
                self.strMerchantRemarks = self.txtMarchantRemarks.text
            }
        }
        if self.customerId.isEmpty
        {
            self.showAlert(message: "Please Add Card")
            return
        }

        if self.strCollectionType == "Self" && self.strReturnType == "Self"
        {

            let summurypage = self.storyboard?.instantiateViewController(withIdentifier: "OrderConformationViewController")as! OrderConformationViewController
            summurypage.strDeliveryFee = "0"
            summurypage.strProductId = self.strProductId
            summurypage.strFromDate = self.startdate
            summurypage.strToDate = self.enddate
            summurypage.strCollectionType = self.strCollectionType
            summurypage.strReturnType = self.strReturnType
            summurypage.strCollectionCharge = "0"
            summurypage.strReturnCharge = "0"
            summurypage.strPromocode = "0"
            summurypage.strPaymentMethode = self.strPaymentMethod
            summurypage.strPromoCodeType1 = self.strPromoCodeType1
            summurypage.strPromoCodeType2 = self.strPromoCodeType2
            summurypage.customerId = self.customerId
            summurypage.strStartTime = self.strStartTime


        self.navigationController?.pushViewController(summurypage, animated: true)

            return

        }

        let strMarchantName = ProductInformation.marchantName ?? ""
        let strMarchantNumber = ProductInformation.marchantNumber ?? ""
        let strMarchantLat = ProductInformation.marchantLat ?? ""
        let strMarchantLang = ProductInformation.marchantLang ?? ""
        let strMarchantAddress =  ProductInformation.marchantAddress ?? ""

        print(ProductInformation.productVehicle ?? "")

        let paramsDict = ["api_key_data":WebServices.API_KEY,
                          "user_id":strUserId, "product_id":strProductId,"service_type":ProductInformation.productVehicle ?? "","country":"SG","merchant_name":strMarchantName,"merchant_phone": strMarchantNumber,"merchant_lat1":strMarchantLat  ,"merchant_lang1": strMarchantLang ,"merchant_address1": strMarchantAddress ,"merchant_lat2": ProductInformation.productBuyerLat! ,"merchant_lang2":ProductInformation.productBuyerLang!,"merchant_address2":ProductInformation.productBuyerAddress! ,"delivery_user_name": strUserName ,"delivery_user_phone":"\(String(describing: "+65"))\(String(describing: strUserPhone))","delivery_remarks":self.txtAddionalNote.text! ,"collection_method":strCollectionType,"collection_date":ProductInformation.productFromDateUTC!,"return_method":strReturnType,"return_date":ProductInformation.productToDateUTC!]
        print(paramsDict)
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.PROCEED_ORDER, params: paramsDict )
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
                let data = response["data"]as! [String:Any]
                print(data)

                let result = data["results"]as! [String:Any]
                print(result)

                let qutation = result["quotation"]as! [String:Any]
                print(qutation)

                var collectionCharge = String()
                var returnCharge = String()

                if self.strCollectionType == "Lalamove"
                {
                     collectionCharge = qutation["collection_fee"]as! String
                    print(collectionCharge)

                }

                else
                {
                    collectionCharge = "0"
                    print(collectionCharge)

                }
                if self.strReturnType == "Lalamove"
                {
                     returnCharge = qutation["return_fee"]as! String
                    print(returnCharge)
                }
                else
                {
                    returnCharge = "0"
                    print(returnCharge)

                }


                let deliveryCharge = Int(collectionCharge)! + Int(returnCharge)!
                print(deliveryCharge)

                ProductInformation.productDeliveryCharges = String(deliveryCharge)

                let summurypage = self.storyboard?.instantiateViewController(withIdentifier: "OrderConformationViewController")as! OrderConformationViewController
                summurypage.strCollectionType = self.strCollectionType
                summurypage.strReturnType = self.strReturnType
                summurypage.strCollectionCharge = collectionCharge
                summurypage.strReturnCharge = returnCharge
                summurypage.strPromocode = "0"
                summurypage.strAdditionalNote = self.strDeliveryRemarks
                summurypage.strPaymentMethode = self.strPaymentMethod
                summurypage.strMarchantremark = self.strMerchantRemarks
                summurypage.strPromoCodeType1 = self.strPromoCodeType1
                summurypage.strPromoCodeType2 = self.strPromoCodeType2
                summurypage.customerId = self.customerId
                summurypage.strStartTime = self.strStartTime
                self.navigationController?.pushViewController(summurypage, animated: true)


            }
        }
    }
    @IBAction func btnChangeCard_Tapped()
    {
        let cardsClass = self.storyboard?.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
        self.navigationController?.pushViewController(cardsClass, animated: false)
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
                    self.cardNameHeight.constant = 40
                    self.cardNumberHeight.constant = 0
                    self.lblCardName.text = "Add New Card"
                    self.lblCardNumber.text = ""
                    self.btnChangeCard .setTitle("ADD", for: UIControlState.normal)
                    return
                }
                else
                {
                    self.cardNumberHeight.constant = 15
                    self.cardNameHeight.constant = 15
                    let response = result as! [String:Any]
                    let data = response["data"]as! [String:Any]
                    let recentCard = data["recent_card"]as! [String:Any]
                    let cardNumber = String(format: "**** **** **** %@", recentCard["card_last4"] as! String )
                    let cardName = recentCard["card_brand"]as? String
                    self.lblCardName.text = cardName
                    self.lblCardNumber.text = cardNumber
                    self.customerId = recentCard["customer_id"] as! String
                    let cardName1 = STPCard.brand(from: cardName!)
                    let cardImage = STPImageLibrary.brandImage(for: cardName1)
                    self.cardImage.image = cardImage
                }
            }
        
        
    }
    @IBAction func btn_backtapped(_ sender: Any)
    {
        self.view.endEditing(true)

        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btn_Address_tapped(_ sender: Any)
    {
        
        self.arrAddress.removeAll()

        self.arrAddress.append(((UserDefaults.standard.value(forKey: "address")) != nil ? (UserDefaults.standard.value(forKey: "address") as! String) : ""))
        if self.arrAddress[0] == ""
        {
            let autocompleteController = GMSAutocompleteViewController()
            let filter = GMSAutocompleteFilter()
            filter.country = "SG"
            autocompleteController.autocompleteFilter = filter
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        else{
            
            self.arrAddress.append("Add New Address")
            ActionSheetStringPicker.show(withTitle: "Select Address ", rows: self.arrAddress, initialSelection: 0, doneBlock: {
                picker, value, index in
                
                print("value = \(value)")
                print("index = \(String(describing: index))")
                
                if value == 0
                {
                    
                    let lat = UserDefaults.standard.value(forKey: "lat")
                    let lang = UserDefaults.standard.value(forKey: "lng")
                    
                    if lat == nil || lang == nil
                    {
                        self.showAlert(message: "Please Select Different Address")
                    }
                    else{
                        self.lblAddress.text = "\(UserDefaults.standard.value(forKey: "address") as! String)"

                        ProductInformation.productBuyerLat =  "\(UserDefaults.standard.value(forKey: "lat") as! String)"
                        ProductInformation.productBuyerLang = "\(UserDefaults.standard.value(forKey: "lng") as! String)"
                        ProductInformation.productBuyerAddress = "\(UserDefaults.standard.value(forKey: "address") as! String)"
                    }
                        
                    
                }
                else{
                    let autocompleteController = GMSAutocompleteViewController()
                    let filter = GMSAutocompleteFilter()
                    filter.country = "SG"
                    autocompleteController.autocompleteFilter = filter
                    autocompleteController.delegate = self
                    self.present(autocompleteController, animated: true, completion: nil)
                }
             
                
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        }
        
        
        
        
       
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
extension OrderViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
       self.lblAddress.text = "\(place.name),\(place.formattedAddress!)"
    
        print("\(place.name)")
       
        ProductInformation.productBuyerLat =  "\(place.coordinate.latitude)"
        ProductInformation.productBuyerLang = "\(place.coordinate.longitude)"
        ProductInformation.productBuyerAddress = "\(place.name),\(place.formattedAddress!)"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

