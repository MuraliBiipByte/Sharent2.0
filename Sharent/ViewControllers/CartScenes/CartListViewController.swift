//
//  CartListViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import LGSideMenuController

class CartListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    var userId :String?
    var cartId = String()
    var CommonCartId = String()
    let dateFormatter = DateFormatter()
    var NoItemsAvailableBtn:UIButton!
    var label : UILabel!
    //venue rental
    var arrVenuDetails = [AnyObject]()
    @IBOutlet weak var venueTable: UITableView!
    
    // service rental
    var arrServiceDetails = [AnyObject]()
    @IBOutlet weak var serviceTable: UITableView!
    
    //product rental
    var arrProductDetails = [AnyObject]()
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var productId = String()
    var ProductDetails = [String:Any]()
    
    var attribute1 = String()
    var attribute2 = String()
    
    @IBOutlet weak var productRentalView: UIView!
    @IBOutlet weak var serviceRentalView: UIView!
    @IBOutlet weak var venueRentalView: UIView!
    
    @IBOutlet weak var venueRentalHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceRentalHeight: NSLayoutConstraint!
    @IBOutlet weak var productRentalHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_proceedToCkOut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CART"
        userId = UserDefaults.standard.string(forKey: "user_id")
        
        self.NoItemsAvailableBtn = UIButton(frame: CGRect(x:0 , y:0, width:180, height: 50))
        self.NoItemsAvailableBtn.titleLabel?.font = NAVIGATION_FONT
        self.NoItemsAvailableBtn.layer.cornerRadius = 8
        self.NoItemsAvailableBtn.layer.masksToBounds = true
        
        self.NoItemsAvailableBtn.center = self.view.center
        self.NoItemsAvailableBtn.setTitle("RETURN TO HOME", for: UIControl.State.normal)
        self.NoItemsAvailableBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.NoItemsAvailableBtn.backgroundColor = APP_COLOR
        NoItemsAvailableBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        label = UILabel(frame: CGRect(x: 0, y: NoItemsAvailableBtn.frame.origin.y-NoItemsAvailableBtn.frame.height, width: self.view.frame.width, height: 30))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "SFProDisplay-Regular", size: 19)!
        label.text = "No Items in Cart"
        self.view.addSubview(label)
        self.view.addSubview(self.NoItemsAvailableBtn)
        
        self.NoItemsAvailableBtn.isHidden = true
        self.label.isHidden = true
        
        venueTable.dataSource = self
        venueTable.delegate = self
        
        serviceTable.dataSource = self
        serviceTable.delegate = self
        
        productTable.dataSource = self
        productTable.delegate = self
        
        scrollView.isHidden = true
        btn_proceedToCkOut.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        venueTable.estimatedRowHeight = 125.0
        venueTable.rowHeight = UITableViewAutomaticDimension
        
        serviceTable.estimatedRowHeight = 112.0
        serviceTable.rowHeight = UITableViewAutomaticDimension
        
        productTable.estimatedRowHeight = 125.0
        productTable.rowHeight = UITableViewAutomaticDimension
        
        getCartListData()
        
    }
    @objc private func goToHome() {
        
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
        self.present(mainViewController, animated: true, completion: nil)
        
    }
    
    func getCartListData() {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id" : userId!]
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.GET_CART_ITEMS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.scrollView.isHidden = true
                self.NoItemsAvailableBtn.isHidden = false
                self.label.isHidden = false
                self.NoItemsAvailableBtn.addTarget(self, action: #selector(self.goToHome), for: UIControl.Event.touchUpInside)
                
                self.btn_proceedToCkOut.isHidden = true
                //                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.scrollView.isHidden = false
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                
                self.arrProductDetails = (data["products"] as? [AnyObject]) != nil  ?  (data["products"] as! [AnyObject]) : []
                
                self.arrVenuDetails = (data["venues"] as? [AnyObject]) != nil  ?  (data["venues"] as! [AnyObject]) : []
                
                self.arrServiceDetails = (data["services"] as? [AnyObject]) != nil  ?  (data["services"] as! [AnyObject]) : []
                
                if (self.arrProductDetails.count > 0)
                {
                    
                    self.productRentalHeight.constant = CGFloat((self.arrProductDetails.count * 125) + 36)
                    self.productTable.reloadData()
                    self.productRentalView.isHidden = false
                    
                }else{
                    self.productRentalHeight.constant = 0
                    self.productRentalView.isHidden = true
                }
                
                if (self.arrServiceDetails.count > 0)
                {
                    self.serviceRentalHeight.constant = CGFloat((self.arrServiceDetails.count * 112) + 36)
                    self.serviceTable.reloadData()
                    self.serviceRentalView.isHidden = false
                    
                }
                else{
                    
                    self.serviceRentalHeight.constant = 0
                    self.serviceRentalView.isHidden = true
                    
                }
                if (self.arrVenuDetails.count > 0)
                {
                    self.venueRentalHeight.constant = CGFloat((self.arrVenuDetails.count * 112) + 36)
                    self.venueTable.reloadData()
                    self.venueRentalView.isHidden = false
                    
                }else{
                    
                    self.venueRentalHeight.constant = 0
                    self.venueRentalView.isHidden = true
                    
                }
            }
        }
    }
    
    func getProductDetails(product_id: String)
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":product_id,"user_id":userId] as [String : AnyObject]
        
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
        
        if tableView == venueTable {
            return self.arrVenuDetails.count
        }
        else if  tableView == serviceTable {
            return self.arrServiceDetails.count
        }
        else if tableView == productTable {
            return self.arrProductDetails.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListTableCell") as! CartListTableCell
        
        if tableView == venueTable {
            
            cell.lblProductName.text = self.arrVenuDetails[indexPath.row]["product_name"] as? String
            CommonCartId = self.arrVenuDetails[indexPath.row]["common_cart_id"] as! String
            
            let image =  "\(WebServices.BASE_URL)\(self.arrVenuDetails[indexPath.row]["product_image"] as! String)"
            cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
            //  booking date
            if let startDate = self.arrVenuDetails[indexPath.row]["start_date"] as? String
            {
                
                if startDate == "" {
                    cell.lblBookingDate.text = String(format: "")
                }else{
                    //                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    //                        let date = dateFormatter.date(from: startDate)
                    //                        dateFormatter.dateFormat = "dd MMM YYYY"
                    //                        let bookingDate = dateFormatter.string(from: date!)
                    cell.lblBookingDate.text = String(format: "Booking Date : %@",startDate)
                }
            }else{
                cell.lblBookingDate.text = String(format: "")
            }
            
            //  booking time
            if let startTime = self.arrVenuDetails[indexPath.row]["start_time"] as? String {
                if startTime == "" {
                    cell.lblBookingTime.text = String(format: "")
                }else{
                    //                    dateFormatter.dateFormat = "hh:mm"
                    //                    let time = dateFormatter.date(from: startTime)
                    //                    let bookingtime = dateFormatter.string(from: time!)
                    cell.lblBookingTime.text = String(format : "Booking Start Time  : %@", startTime)
                }
                
            }else {
                cell.lblBookingTime.text = String(format: "")
            }
            
            cell.btn_deleteSelectedItem.addTarget(self, action: #selector(self.deleteVenueItem), for: .touchUpInside)
            cell.btn_deleteSelectedItem.tag = indexPath.row
            
            cell.btn_viewOrder_Details.addTarget(self, action: #selector(self.viewVenueOrderDetails), for: .touchUpInside)
            cell.btn_viewOrder_Details.tag = indexPath.row
            
            
        } else  if tableView == serviceTable {
            
            cell.lblProductName.text = self.arrServiceDetails[indexPath.row]["product_name"] as? String
            CommonCartId = self.arrServiceDetails[indexPath.row]["common_cart_id"] as! String
            
            let image =  "\(WebServices.BASE_URL)\(self.arrServiceDetails[indexPath.row]["product_image"] as! String)"
            cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
            //  booking date
            //            let dateFormatter = DateFormatter()
            
            if let startDate = self.arrServiceDetails[indexPath.row]["start_date"] as? String
            {
                if startDate == "" {
                    cell.lblBookingDate.text = String(format: "")
                }else{
                    //                    //            let dateFormatter = DateFormatter()
                    //                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    //                    let date = dateFormatter.date(from: startDate)
                    //
                    //                    dateFormatter.dateFormat = "dd MMM YYYY"
                    //                    let bookingDate = dateFormatter.string(from: date!)
                    cell.lblBookingDate.text = String(format: "Booking Date : %@",startDate)
                }
            }else{
                cell.lblBookingDate.text = String(format: "")
            }
            
            //  booking time
            if let startTime = self.arrServiceDetails[indexPath.row]["start_time"] as? String {
                if startTime == "" {
                    cell.lblBookingTime.text = String(format: "")
                }else{
                    //                    dateFormatter.dateFormat = "hh:mm:ss"
                    //                    let time = dateFormatter.date(from: startTime)
                    //                    dateFormatter.dateFormat = "hh:mm a"
                    //                    let bookingtime = dateFormatter.string(from: time!)
                    
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
        else {
            
            cell.lblProductName.text = self.arrProductDetails[indexPath.row]["product_name"] as? String
            CommonCartId = self.arrProductDetails[indexPath.row]["common_cart_id"] as! String
            let image =  "\(WebServices.BASE_URL)\(self.arrProductDetails[indexPath.row]["product_image"] as! String)"
            cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
            
            cell.lblQuantity.text = String(format: "Quantity : %@",(self.arrProductDetails[indexPath.row]["quantity"] as! String))
            
            
            attribute1 = self.arrProductDetails[indexPath.row]["attribute1"] as! String
            
            cell.lblColour.text = String(format: "%@",attribute1)
            
            attribute2 = self.arrProductDetails[indexPath.row]["attribute2"] as! String
            cell.lblSize.text = String(format: "%@",attribute2)
            
            
            cell.btn_deleteSelectedItem.addTarget(self, action: #selector(self.deleteProductItem), for: .touchUpInside)
            cell.btn_deleteSelectedItem.tag = indexPath.row
            
            
            cell.btn_viewOrder_Details.addTarget(self, action: #selector(self.viewProductOrderDetails), for: .touchUpInside)
            cell.btn_viewOrder_Details.tag = indexPath.row
            
        }
        
        cell .selectionStyle = UITableViewCellSelectionStyle .none
        return cell
    }
    
    
    @objc func viewServiceOrderDetails(sender : UIButton?) {
        print("service order details")
        let dictObj = self.arrServiceDetails[(sender?.tag)!]
        self.productId = dictObj["product_id"] as! String
        self.cartId = dictObj["cart_id"] as! String
        
        self.getProductDetails(product_id: self.productId)
        
    }
    
    
    @objc func viewVenueOrderDetails(sender : UIButton?) {
        print("venue order details")
        let dictObj = self.arrVenuDetails[(sender?.tag)!]
        self.productId = dictObj["product_id"] as! String
        self.cartId = dictObj["cart_id"] as! String
        
        self.getProductDetails(product_id: self.productId)
    }
    
    @objc func viewProductOrderDetails(sender : UIButton?) {
        print("venue order details")
        let dictObj = self.arrProductDetails[(sender?.tag)!]
        self.productId = dictObj["product_id"] as! String
        self.cartId = dictObj["cart_id"] as! String
        self.getProductDetails(product_id: self.productId)
    }
    
    
    @IBAction func proceed_ToCheckout_Page(_ sender: Any) {
        
        if !CommonCartId.isEmpty {
            
            let cartBookingVC = self.storyboard?.instantiateViewController(withIdentifier: "CartBookingDetailsViewController") as! CartBookingDetailsViewController
            
            cartBookingVC.Common_CartID = CommonCartId
            cartBookingVC.arrVenueList = self.arrVenuDetails
            cartBookingVC.arrServiceList = self.arrServiceDetails
            cartBookingVC.arrProductList = self.arrProductDetails
            
            self.navigationController?.pushViewController(cartBookingVC, animated: true)
        }else{
            // stay
        }
    }
    
    @objc func deleteProductItem(sender : UIButton?) {
        
        let dictObj = self.arrProductDetails[(sender?.tag)!]
        self.cartId = dictObj["cart_id"] as! String
        
        self.arrProductDetails.remove(at: sender!.tag)
        self.deleteSelectedItemfromCart(cart_Id:  self.cartId)
        productTable.reloadData()
        
        if (self.arrProductDetails.count > 0)
        {
            self.productRentalHeight.constant = CGFloat((self.arrProductDetails.count * 125) + 36)
            self.productTable.reloadData()
            self.productRentalView.isHidden = false
            
        }else{
            self.productRentalHeight.constant = 0
            self.productRentalView.isHidden = true
        }
        
        if self.arrProductDetails.count == 0 && self.arrVenuDetails.count == 0 &&
            self.arrServiceDetails.count == 0  {
            btn_proceedToCkOut.isHidden = true
            self.scrollView.isHidden = true
            self.NoItemsAvailableBtn.isHidden = false
            self.label.isHidden = false
            self.NoItemsAvailableBtn.addTarget(self, action: #selector(self.goToHome), for: UIControl.Event.touchUpInside)
        }
    }
    
    @objc func deleteVenueItem(sender : UIButton?) {
        let dictObj = self.arrVenuDetails[(sender?.tag)!]
        self.cartId = dictObj["cart_id"] as! String
        
        self.arrVenuDetails.remove(at: sender!.tag)
        deleteSelectedItemfromCart(cart_Id:  self.cartId)
        venueTable.reloadData()
        
        if (self.arrVenuDetails.count > 0)
        {
            self.venueRentalHeight.constant = CGFloat((self.arrVenuDetails.count * 112) + 36)
            self.venueTable.reloadData()
            self.venueRentalView.isHidden = false
            
        }else{
            self.venueRentalHeight.constant = 0
            self.venueRentalView.isHidden = true
        }
        if self.arrProductDetails.count == 0 && self.arrVenuDetails.count == 0 &&
            self.arrServiceDetails.count == 0  {
            self.scrollView.isHidden = true
            btn_proceedToCkOut.isHidden = true
            self.NoItemsAvailableBtn.isHidden = false
            self.label.isHidden = false
            self.NoItemsAvailableBtn.addTarget(self, action: #selector(self.goToHome), for: UIControl.Event.touchUpInside)
            
        }
    }
    
    @objc func deleteServiceItem(sender : UIButton?) {
        let dictObj = self.arrServiceDetails[(sender?.tag)!]
        self.cartId = dictObj["cart_id"] as! String
        
        self.arrServiceDetails.remove(at: sender!.tag)
        deleteSelectedItemfromCart(cart_Id:  self.cartId)
        serviceTable.reloadData()
        
        if (self.arrServiceDetails.count > 0)
        {
            self.serviceRentalHeight.constant = CGFloat((self.arrServiceDetails.count * 112) + 36)
            self.serviceTable.reloadData()
            self.serviceRentalView.isHidden = false
            
        }
        else{
            self.serviceRentalHeight.constant = 0
            self.serviceRentalView.isHidden = true
        }
        
        if self.arrProductDetails.count == 0 && self.arrVenuDetails.count == 0 &&
            self.arrServiceDetails.count == 0  {
            self.scrollView.isHidden = true
            btn_proceedToCkOut.isHidden = true
            self.NoItemsAvailableBtn.isHidden = false
            self.label.isHidden = false
            self.NoItemsAvailableBtn.addTarget(self, action: #selector(self.goToHome), for: UIControl.Event.touchUpInside)
            
        }
    }
    
    
    func deleteSelectedItemfromCart(cart_Id : String) {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":self.userId!,"cart_id":cart_Id] as [String : Any]
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
                
                let cartCount = UserDefaults.standard.value(forKey: "cart_count") as! Int
                UserDefaults.standard.set(cartCount - 1, forKey: "cart_count")
                
                let response = result as! [String : Any]
                let message = response ["message"]
                self.showAlert(message: message as! String)
            }
        }
    }
    
    @IBAction func btn_backTapped(_ sender: Any) {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    func showAlertForDeletesuccess(message : String) {
        
        let confirmationAlert = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.venueTable.estimatedRowHeight = 120.0
            self.venueTable.rowHeight = UITableViewAutomaticDimension
            
            self.serviceTable.estimatedRowHeight = 120.0
            self.serviceTable.rowHeight = UITableViewAutomaticDimension
            
            self.productTable.estimatedRowHeight = 44.0
            self.productTable.rowHeight = UITableViewAutomaticDimension
            
        }))
        present(confirmationAlert, animated: true, completion: nil)
        
    }
}
