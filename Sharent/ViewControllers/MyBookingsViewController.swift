//
//  MyBookingsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MyBookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableViewHistory:UITableView!
    @IBOutlet weak var btnActive:UIButton!
    @IBOutlet weak var btnCompleted:UIButton!
    @IBOutlet weak var lblUnderBtnActive:UILabel!
    @IBOutlet weak var lblUnderBtnCompleted:UILabel!
    
    var userId = String()
    var userName = String()
    var userLoginType = String()
    var usercompany = String()
    
    var paramsDic = [String:Any]()
    var historyData = [AnyObject]()
    
    var arrReferenceIds = [AnyObject]()
    
    var userCheckingForProducts = String()
    var urlHistoryService = String()

    var imageViewNoProducts = UIImageView()
    var labelNoProducts = UILabel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Booking"
        
        tableViewHistory.isHidden = true
        
        self.imageViewNoProducts = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.imageViewNoProducts.center = self.view.center
        self.imageViewNoProducts.contentMode = .scaleAspectFit
        self.imageViewNoProducts.image = UIImage(named: "IconNoBookings")
        self.labelNoProducts = UILabel(frame: CGRect(x: 0, y: self.imageViewNoProducts.frame.origin.y+self.imageViewNoProducts.frame.height, width: self.view.frame.width, height: 21))
        self.labelNoProducts.textAlignment = NSTextAlignment.center
        self.labelNoProducts.font = Constants.APP_FONT
        self.labelNoProducts.text = "No Bookings found"
        self.view.addSubview(self.imageViewNoProducts)
        self.view.addSubview(self.labelNoProducts)
        
        self.imageViewNoProducts.isHidden = true
        self.labelNoProducts.isHidden = true
        
        userCheckingForProducts = "active"
        urlHistoryService = WebServices.GET_MYBOOKINGS
        lblUnderBtnActive.backgroundColor = UIColor.white
        lblUnderBtnCompleted.backgroundColor = UIColor.darkGray
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        userName = UserDefaults.standard.value(forKey: "userName") as! String
        userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
        
        
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":userLoginType,"user_id":userId]
        
        self.getAllMyBookingProducts(serviceUrl: urlHistoryService)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func getAllMyBookingProducts(serviceUrl:String)
    {
        self.view.StartLoading()
        ApiManager().postRequest(service: serviceUrl, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.tableViewHistory.isHidden = true
                self.imageViewNoProducts.isHidden = false
                self.labelNoProducts.isHidden = false
                return
            }
            else
            {
                self.tableViewHistory.isHidden = false
                self.imageViewNoProducts.isHidden = true
                self.labelNoProducts.isHidden = true
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.historyData = dataDictionary!["history"] as! [AnyObject]
                
                if self.historyData.count > 0
                {
                    self.arrReferenceIds.removeAll()
                    self.tableViewHistory.reloadData()
                    for historyData in self.historyData
                    {
                        self.arrReferenceIds.append(historyData["reference_id"] as AnyObject)
                    }
                    
                }
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        
        cell.lbl_Product_Name.text = self.historyData[indexPath.row]["product_name"] as? String
        cell.lbl_Order_Number.text = String(format:"Order#: %@", self.historyData[indexPath.row]["reference_id"] as! String)
        cell.lblProductRate.text = String(format:"$%@", self.historyData[indexPath.row]["price"] as! String)
        cell.lblProductAttribute.text = String(format:"%@", self.historyData[indexPath.row]["attribute1"] as! String)
        cell.lbl_Product_Status.text = String(format:"%@", self.historyData[indexPath.row]["status_name"] as! String)
        cell.lblQuantity.text = String(format:"QUANTITY - %@", self.historyData[indexPath.row]["quantity"] as! String)
        let image =  "\(WebServices.BASE_URL)\(self.historyData[indexPath.row]["photo_android1"] as! String)"
        cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        let orderStatus = self.historyData[indexPath.row]["order_status"] as! String
        if userCheckingForProducts == "active"
        {
            cell.lblDateTitle.isHidden = false
            cell.lblDateTitle.text = "Estimated Delivery"
            cell.lblDeliveryDate.text = self.historyData[indexPath.row]["rental_period_startdate"] as? String
            cell.lblDeliveryDate.isHidden = false
            
        }
        else
        {
            if orderStatus == "14"
            {
                cell.lblDateTitle.isHidden = false
                cell.lblDateTitle.text = "Delevered On"
                cell.lblDeliveryDate.text = self.historyData[indexPath.row]["rental_period_startdate"] as? String
                cell.lblDeliveryDate.isHidden = false
            }
            else
            {
                cell.lblDateTitle.isHidden = true
                cell.lblDeliveryDate.isHidden = true
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let referenceProductId =  self.arrReferenceIds[indexPath.row] as! String
        referenceProductDetails(referenceId: referenceProductId)
    }
    
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        UIView.animate(withDuration: 0.4, animations:
            {
            self.sideMenuController?.leftViewWidth = 280
            self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
            })
    }
    
        func referenceProductDetails(referenceId:String)
        {
            if userCheckingForProducts == "active"
            {
                if userLoginType == UserType.BUYER
                {
                    let bookedproductvc = self.storyboard?.instantiateViewController(withIdentifier:"MyBookingProductDetailsViewController" )as! MyBookingProductDetailsViewController
                    bookedproductvc.referenceProductId = referenceId
                    self.navigationController?.pushViewController(bookedproductvc, animated: true)
                }
                else
                {
                    let bookingDetails = self.storyboard?.instantiateViewController(withIdentifier: "BookedProductDetailsViewController") as! BookedProductDetailsViewController
                    bookingDetails.referenceProductId = referenceId
                    self.navigationController?.pushViewController(bookingDetails, animated: true)
                }
                
            }
            else
            {
                if userLoginType == UserType.BUYER
                {
                    let details = storyboard?.instantiateViewController(withIdentifier: "ProfileHistoryDetailsViewController")as! ProfileHistoryDetailsViewController
                    details.referenceId = referenceId
                    self.navigationController?.pushViewController(details, animated: true)
                }
                else
                {
                    let bookingDetails = self.storyboard?.instantiateViewController(withIdentifier: "BookedProductDetailsViewController") as! BookedProductDetailsViewController
                    bookingDetails.referenceProductId = referenceId
                    self.navigationController?.pushViewController(bookingDetails, animated: true)
                }
                
            }
        }
    @IBAction func btnActiveTapped()
    {
        tableViewHistory.isHidden = true
        urlHistoryService = WebServices.GET_MYBOOKINGS
        lblUnderBtnActive.backgroundColor = UIColor.white
        lblUnderBtnCompleted.backgroundColor = UIColor.darkGray
        userCheckingForProducts = "active"
        self.getAllMyBookingProducts(serviceUrl: urlHistoryService)
    }
    @IBAction func btnCompletedTapped()
    {
        tableViewHistory.isHidden = true
        urlHistoryService = WebServices.BUYER_HISTOREY
        lblUnderBtnActive.backgroundColor = UIColor.darkGray
        lblUnderBtnCompleted.backgroundColor = UIColor.white
        userCheckingForProducts = "completed"
        self.getAllMyBookingProducts(serviceUrl: urlHistoryService)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }

}
