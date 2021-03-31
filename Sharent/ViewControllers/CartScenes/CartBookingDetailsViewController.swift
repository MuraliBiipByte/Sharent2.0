//
//  CartBookingDetailsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class CartBookingDetailsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    var arrVenueList = [AnyObject]()
    @IBOutlet weak var venueTableView: UITableView!
    var arrServiceList = [AnyObject]()
    @IBOutlet weak var serviceTableView: UITableView!
    var arrProductList = [AnyObject]()
    
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var lblReturnType: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
//    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var productViewHeight: NSLayoutConstraint!
    @IBOutlet weak var venueRentalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var VenueView: UIView!
    @IBOutlet weak var ServiceView: UIView!
    
    @IBOutlet weak var ProductsView: UIView!
    
    @IBOutlet weak var serviceRentalViewHeight: NSLayoutConstraint!
    
    var strUserId = String()
    var Common_CartID = String()
    var cartId = String()
    var startdate = String()
    var enddate = String()
    var strStartTime = String()
    var CollectionArr = [String]()
    var deliveryTpe = String()
    var arrAddress = [String]()
    var productId = String()
    
    @IBOutlet weak var addressTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BOOKING DETAILS"
        
        venueTableView.dataSource = self
        venueTableView.delegate = self
        
        serviceTableView.dataSource = self
        serviceTableView.delegate = self
        self.addressTxt.text = UserDefaults.standard.value(forKey: "address") != nil ? (UserDefaults.standard.value(forKey: "address") as! String) : ""
        
        CollectionArr = ["Self", "Delivery"]
        self.strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        venueTableView.estimatedRowHeight = 112.0
        venueTableView.rowHeight = UITableViewAutomaticDimension
        
        serviceTableView.estimatedRowHeight = 112.0
        serviceTableView.rowHeight = UITableViewAutomaticDimension
        
        
        if (self.arrVenueList.count > 0)
        {
            self.venueRentalViewHeight.constant = CGFloat((self.arrVenueList.count * 112) + 36)
            self.venueTableView.reloadData()
            self.VenueView.isHidden = false
            
        }else{
            self.venueRentalViewHeight.constant = 0
            self.VenueView.isHidden = true
        }
   
        if (self.arrServiceList.count > 0)
        {
            self.serviceRentalViewHeight.constant = CGFloat((self.arrServiceList.count * 112) + 36)
            self.serviceTableView.reloadData()
            self.ServiceView.isHidden = false
            
        }
        else{
            self.serviceRentalViewHeight.constant = 0
            self.ServiceView.isHidden = true
        }
        
        
        if self.arrProductList.count > 0 {
            self.productViewHeight.constant = 380
            self.ProductsView.isHidden = false
        }else{
            self.productViewHeight.constant = 0
            self.ProductsView.isHidden = true
        }
    }
    
    var ProductDetails = [String:Any]()
    func getProductDetails(product_id: String)
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":product_id,"user_id":strUserId]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_PRODUCT_DETAILS, params: paramsDic)
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
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                
                self.ProductDetails = (dataDictionary!["products"]as? [String:Any])!
                
                _ = ProductInformation.init(productDetailsDictionay: self.ProductDetails)
                
                let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmAddtoCartVC")as! ConfirmAddtoCartVC
                orderVc.cartID = self.cartId
                orderVc.ProductData = self.ProductDetails
                orderVc.updateCart = true
                
                
                self.navigationController?.pushViewController(orderVc, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == venueTableView {
            return self.arrVenueList.count
        }
        else if  tableView == serviceTableView {
            return self.arrServiceList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListTableCell") as! CartListTableCell
        
        if tableView == venueTableView {
            
            cell.lblProductName.text = self.arrVenueList[indexPath.row]["product_name"] as? String
            let image =  "\(WebServices.BASE_URL)\(self.arrVenueList[indexPath.row]["product_image"] as! String)"
            cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
            if let startDate = self.arrVenueList[indexPath.row]["start_date"] as? String
            {
                if startDate == "" {
                    cell.lblBookingDate.text = String(format: "")
                }else{
                    
                    cell.lblBookingDate.text = String(format: "Booking Date : %@",startDate)
                }
            }
            
            if let startTime = self.arrVenueList[indexPath.row]["start_time"] as? String {
                if startTime == "" {
                    cell.lblBookingTime.text = String(format: "")
                }else{
                    
                    cell.lblBookingTime.text = String(format : "Booking Start Time  : %@", startTime)
                }
                
            }else {
                cell.lblBookingTime.text = String(format: "")
            }
            
            cell.btn_deleteSelectedItem.addTarget(self, action: #selector(self.deleteVenueItem), for: .touchUpInside)
            cell.btn_deleteSelectedItem.tag = indexPath.row
            
            
            cell.btn_viewOrder_Details.addTarget(self, action: #selector(self.viewVenueOrderDetails), for: .touchUpInside)
            cell.btn_viewOrder_Details.tag = indexPath.row
            
            
        } else  if tableView == serviceTableView {
            
            cell.lblProductName.text = self.arrServiceList[indexPath.row]["product_name"] as? String
           
            let image =  "\(WebServices.BASE_URL)\(self.arrServiceList[indexPath.row]["product_image"] as! String)"
            cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
            //  booking date
            if let startDate = self.arrServiceList[indexPath.row]["start_date"] as? String
            {
                if startDate == "" {
                    cell.lblBookingDate.text = String(format: "")
                }else{
                    
                    cell.lblBookingDate.text = String(format: "Booking Date : %@",startDate)
                }
            }
            
            //  booking time
            if let startTime = self.arrServiceList[indexPath.row]["start_time"] as? String {
                if startTime == "" {
                    cell.lblBookingTime.text = String(format: "")
                }else{
                    
                    cell.lblBookingTime.text = String(format : "Booking Start Time  : %@", startTime)
                }
                
            }else {
                cell.lblBookingTime.text = String(format: "")
            }
            
            cell.btn_deleteSelectedItem.addTarget(self, action: #selector(self.deleteServiceItem), for: .touchUpInside)
            cell.btn_deleteSelectedItem.tag = indexPath.row
            
            
            cell.btn_viewOrder_Details.addTarget(self, action: #selector(self.viewServiceOrderDetails), for: .touchUpInside)
            cell.btn_viewOrder_Details.tag = indexPath.row
            
        }
        
        cell .selectionStyle = UITableViewCellSelectionStyle .none
       
        return cell
    }
    
    
    @objc func viewServiceOrderDetails(sender : UIButton?) {
        print("service order details")
        let dictObj = self.arrServiceList[(sender?.tag)!]
        self.productId = dictObj["product_id"] as! String
        self.cartId = dictObj["cart_id"] as! String
        
        self.getProductDetails(product_id: self.productId)
        
    }
    
    
    @objc func viewVenueOrderDetails(sender : UIButton?) {
        print("venue order details")
        let dictObj = self.arrVenueList[(sender?.tag)!]
        self.productId = dictObj["product_id"] as! String
         self.cartId = dictObj["cart_id"] as! String
        
        self.getProductDetails(product_id: self.productId)
    }
    
    
    @objc func deleteVenueItem(sender : UIButton?) {
        let dictObj = self.arrVenueList[(sender?.tag)!]
        self.cartId = dictObj["cart_id"] as! String
        
        self.arrVenueList.remove(at: sender!.tag)
        deleteSelectedItemfromCart(cart_Id:  self.cartId)
        venueTableView.reloadData()
        
        if (self.arrVenueList.count > 0)
        {
            self.venueRentalViewHeight.constant = CGFloat((self.arrVenueList.count * 112) + 36)
            self.venueTableView.reloadData()
            self.venueTableView.isHidden = false
            
        }else{
            self.venueRentalViewHeight.constant = 0
            self.venueTableView.isHidden = true
        }
        
        if self.arrProductList.count == 0 && self.arrVenueList.count == 0 &&
            self.arrServiceList.count == 0  {
            self.scrollview.isHidden = true
        }
    }
    
    
    @objc func deleteServiceItem(sender : UIButton?) {
        let dictObj = self.arrServiceList[(sender?.tag)!]
        self.cartId = dictObj["cart_id"] as! String
        
        self.arrServiceList.remove(at: sender!.tag)
        deleteSelectedItemfromCart(cart_Id:  self.cartId)
        serviceTableView.reloadData()
        
        
        if (self.arrServiceList.count > 0)
        {
            self.serviceRentalViewHeight.constant = CGFloat((self.arrServiceList.count * 112) + 36)
            self.serviceTableView.reloadData()
            self.ServiceView.isHidden = false
            
        }
        else{
            self.serviceRentalViewHeight.constant = 0
            self.ServiceView.isHidden = true
        }
        
        if self.arrProductList.count == 0 && self.arrVenueList.count == 0 &&
            self.arrServiceList.count == 0  {
            self.scrollview.isHidden = true
        }
        
    }
    
    
    func deleteSelectedItemfromCart(cart_Id : String) {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":self.strUserId,"cart_id":cart_Id] as [String : Any]
        
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.DELETE_CART_ITEM, params: paramsDic as [String : Any] )
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlertForDeletesuccess(message: result as! String)
                return
            }
            else
            {
                let response = result as! [String : Any]
                let message = response ["message"]
                self.showAlertForDeletesuccess(message: message as! String)
                
            }
        }
    }
    
    func showAlertForDeletesuccess(message : String) {
        
        
        let confirmationAlert = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.venueTableView.separatorColor = UIColor.clear;
            self.venueTableView.estimatedRowHeight = 125.0
            self.venueTableView.rowHeight = UITableViewAutomaticDimension
            
            self.serviceTableView.separatorColor = UIColor.clear
            self.serviceTableView.estimatedRowHeight = 125.0
            self.serviceTableView.rowHeight = UITableViewAutomaticDimension
            
        }))
        
        present(confirmationAlert, animated: true, completion: nil)
        
    }
    
    @objc func deleteSelectedItem(sender : UIButton?){
        
        
        let confirmationAlert = UIAlertController(title: APP_NAME, message: "Are you sure to delete Selected Item", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            
            let dictObj = self.arrVenueList[(sender?.tag)!]
            let cartId = dictObj["cart_id"] as? String
            
            let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":self.strUserId,"cart_id":cartId!] as [String : Any]
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.DELETE_CART_ITEM, params: paramsDic as [String : Any] )
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    let response = result as! [String : Any]
                    let message = response ["message"]
                    self.showAlert(message: message as! String)
                }
            }
            
            
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(confirmationAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btn_deliveryTime_Tapped(_ sender: Any) {
        
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
            
//            let fullNameArr = self.strStartTime.components(separatedBy: ":")
//            let hour    = fullNameArr[0]
            //let minutes    = fullNameArr[1]
            
//            if Int(hour)! < 10 || Int(hour)! >= 17
//            {
//                self.showAlert(message: "We will process orders only between 10AM to 5PM")
//                self.strStartTime = ""
//                return
//            }
//            else
//            {
            
                self.startTimeTF.text = self.strStartTime
//            }
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        if self.startdate == currentDateString
        {
            datePicker?.minimumDate = extendedTime
        }
        
        datePicker?.show()
        
    }
    
    
    @IBAction func btn_collectionTime_Tapped(_ sender: Any) {
        
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
            
//            let fullNameArr = self.strStartTime.components(separatedBy: ":")
//            let hour    = fullNameArr[0]
            //let minutes    = fullNameArr[1]
            
//            if Int(hour)! >= 17
//            {
//                self.showAlert(message: "We will process orders only between 10AM to 5PM")
//                self.strStartTime = ""
//                return
//            }
//            else
//            {
//
                self.endTimeTF.text = self.strStartTime
//            }
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        if self.startdate == currentDateString
        {
            datePicker?.minimumDate = extendedTime
        }
        
        datePicker?.show()
        
    }
    
    
    @IBAction func SelectCollectioonMethod(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose Collection Type", rows: self.CollectionArr as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                self.lblReturnType.text = index as? String
                self.deliveryTpe = String(value)
                
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
        textField.leftViewMode = .always
        
    }
    
//    @IBAction func select_AddressTapped(_ sender: Any) {
//
//        self.arrAddress.removeAll()
//
//        self.arrAddress.append(((UserDefaults.standard.value(forKey: "address")) != nil ? (UserDefaults.standard.value(forKey: "address") as! String) : ""))
//        if self.arrAddress[0] == ""
//        {
//            let autocompleteController = GMSAutocompleteViewController()
//            let filter = GMSAutocompleteFilter()
//            filter.country = "SG"
//            autocompleteController.autocompleteFilter = filter
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//        }
//        else{
//
//            self.arrAddress.append("Add New Address")
//            ActionSheetStringPicker.show(withTitle: "Select Address ", rows: self.arrAddress, initialSelection: 0, doneBlock: {
//                picker, value, index in
//
//                print(self.arrAddress)
//                if value == 0
//                {
//
//                    let lat = UserDefaults.standard.value(forKey: "lat")
//                    let lang = UserDefaults.standard.value(forKey: "lng")
//
//                    if lat == nil || lang == nil
//                    {
//                        self.showAlert(message: "Please Select Different Address")
//                    }
//                    else
//                    {
//                        self.addressLbl.text = "\(UserDefaults.standard.value(forKey: "address") as! String)"
//
//                        ProductInformation.productBuyerLat =  "\(UserDefaults.standard.value(forKey: "lat") as! String)"
//                        ProductInformation.productBuyerLang = "\(UserDefaults.standard.value(forKey: "lng") as! String)"
//                        ProductInformation.productBuyerAddress = "\(UserDefaults.standard.value(forKey: "address") as! String)"
//                    }
//
//
//                }
//                else
//                {
//                    let autocompleteController = GMSAutocompleteViewController()
//                    let filter = GMSAutocompleteFilter()
//                    filter.country = "SG"
//                    autocompleteController.autocompleteFilter = filter
//                    autocompleteController.delegate = self
//                    self.present(autocompleteController, animated: true, completion: nil)
//                }
//
//
//                return
//            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//        }
//
//    }
    
    
    func insertBookingDetails() {
       
        let paramsDic = ["api_key_data":WebServices.API_KEY,"common_cart_id":Common_CartID,"user_id":strUserId,"shipping_method":self.deliveryTpe,"shipping_address": self.addressTxt.text!] as [String: AnyObject]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.BOOKING_DETAILS_INSERT, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderConformationViewController") as! OrderConformationViewController
                
                orderVC.Common_Cart_Id = self.Common_CartID
                self.navigationController?.pushViewController(orderVC, animated: true)
                
            }
            
        }
    }
    
    
    @IBAction func proceedtoCheckout_Tapped(_ sender: Any) {
        
        if arrProductList.count > 0 {
            if (lblReturnType.text?.isEmpty)!
            {
                self.showAlert(message:"Please Select Collection Method")
//                self.lblReturnType.resignFirstResponder()
                return
            }
            if (startTimeTF.text?.isEmpty)!
            {
                self.showAlert(message:"Please Select Start time!")
//                self.txtPassword .resignFirstResponder()
                return
            }
            if (endTimeTF.text?.isEmpty)!
            {
                self.showAlert(message:"Please Select End time!")
                //                self.txtPassword .resignFirstResponder()
                return
            }
            if (addressTxt.text?.isEmpty)!
            {
                self.showAlert(message:"Please add Address")
                self.addressTxt.resignFirstResponder()
                return
            }
        }
       
        insertBookingDetails()
       
    }
    
    
    @IBAction func btn_go_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}




extension CartBookingDetailsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.addressTxt.text = "\(place.name),\(place.formattedAddress!)"
        
        ProductInformation.productBuyerLat =  "\(place.coordinate.latitude)"
        ProductInformation.productBuyerLang = "\(place.coordinate.longitude)"
        ProductInformation.productBuyerAddress = "\(place.name),\(place.formattedAddress!)"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
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
