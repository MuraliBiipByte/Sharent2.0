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
    
   //let weak var navItem: UIBarButtonItem!
    
    
    var userId = String()
    var userName = String()
    var userLoginType = String()
    var usercompany = String()
     var type = String()
    
    var paramsDic = [String:Any]()
    var historyData = [AnyObject]()
    
    var arrOrderIds = [AnyObject]()
    
    var userCheckingForProducts = String()
    var urlHistoryService = String()
    
    var imageViewNoProducts = UIImageView()
    var labelNoProducts = UILabel()
    
  
    
    
    override func viewDidLoad()
    {
      
        super.viewDidLoad()
        
        self.title = "RENTAL HISTORY"
        
        tableViewHistory.isHidden = true
        
        self.imageViewNoProducts = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.imageViewNoProducts.center = self.view.center
        self.imageViewNoProducts.contentMode = .scaleAspectFit
        self.imageViewNoProducts.image = UIImage(named: "IconNoBookings")
        self.labelNoProducts = UILabel(frame: CGRect(x: 0, y: self.imageViewNoProducts.frame.origin.y+self.imageViewNoProducts.frame.height, width: self.view.frame.width, height: 21))
        self.labelNoProducts.textAlignment = NSTextAlignment.center
        self.labelNoProducts.font = APP_FONT
        self.labelNoProducts.text = "No Bookings found"
        self.view.addSubview(self.imageViewNoProducts)
        self.view.addSubview(self.labelNoProducts)
        
        self.imageViewNoProducts.isHidden = true
        self.labelNoProducts.isHidden = true
        
        userCheckingForProducts = "active"
        urlHistoryService = WebServices.GET_MYBOOKINGS
        lblUnderBtnActive.backgroundColor = APP_COLOR
        lblUnderBtnCompleted.backgroundColor = UIColor.white
        
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
        var buttonIcon = UIImage()
        
//        if userLoginType == BUYER
//        {
//            buttonIcon = UIImage(named: "menu")!
//
//        }else{
            buttonIcon = UIImage(named: "back")!
            
//        }
        let leftBarButton = UIBarButtonItem(title: "Item", style: UIBarButtonItem.Style.done, target: self, action: #selector(back_Tapped))
        leftBarButton.image = buttonIcon
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
        
   
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
                    self.arrOrderIds.removeAll()
                    self.tableViewHistory.reloadData()
                    for historyData in self.historyData
                    {
                        self.arrOrderIds.append(historyData["order_id"] as AnyObject)
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
        
        cell.viewUnderimgProduct.layer.cornerRadius = 8
        cell.viewUnderimgProduct.layer.masksToBounds = true
     
        
        cell.lbl_Product_Name.text = self.historyData[indexPath.row]["product_name"] as? String
        
        self.type = String(format:"%@", self.historyData[indexPath.row]["listing_type"] as! String)

        if self.type == PRODUCT {
            cell.lblDate.text = String(format:"%@ - %@", self.historyData[indexPath.row]["rental_period_startdate"] as? String ?? "",self.historyData[indexPath.row]["rental_period_enddate"] as? String ?? "")

            cell.lblQuantity.text = String(format:"Quantity - %@", self.historyData[indexPath.row]["quantity"] as! String)
        }else{
            cell.lblDate.text = String(format:"%@", self.historyData[indexPath.row]["rental_period_startdate"] as? String ?? "")
           cell.lblQuantity.text  = ""
            }
        
        cell.deliveryType.text = String(format:"%@", self.historyData[indexPath.row]["delivery_type"] as? String ?? "")
        let productRate = self.historyData[indexPath.row]["price"] as! String
        cell.lblProductRate.text = String(format:"$%@",productRate)
        cell.lbl_Product_Status.text = String(format:"%@", self.historyData[indexPath.row]["status_name"] as? String ?? "")

        let image =  "\(WebServices.BASE_URL)\(self.historyData[indexPath.row]["photo_android1"] as! String)"
        cell.img_Product.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let productOrderId =  self.arrOrderIds[indexPath.row] as! String
        referenceProductDetails(orderId: productOrderId)
    }
    
    @objc func back_Tapped() {
        if userLoginType == BUYER {
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }
        else{
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
            
        }
    }

    func referenceProductDetails(orderId:String)
    {
        
//        if userLoginType == BUYER
//        {
//            let bookedproductvc = self.storyboard?.instantiateViewController(withIdentifier:"ProfileHistoryDetailsViewController" ) as! ProfileHistoryDetailsViewController
//            bookedproductvc.ProductOrderId = orderId
//            bookedproductvc.historyType = userCheckingForProducts
//
//               print(bookedproductvc.historyType)
//
//            self.navigationController?.pushViewController(bookedproductvc, animated: true)
//        }
//        else
//        {
            let bookingDetails = self.storyboard?.instantiateViewController(withIdentifier: "BookedProductDetailsViewController") as! BookedProductDetailsViewController
            
            bookingDetails.OrderId = orderId
  
//            bookedproductvc.historyType = userCheckingForProducts
            self.navigationController?.pushViewController(bookingDetails, animated: true)
//        }
    }
    @IBAction func btnActiveTapped()
    {
        tableViewHistory.isHidden = true
        urlHistoryService = WebServices.GET_MYBOOKINGS
        lblUnderBtnActive.backgroundColor = APP_COLOR
        lblUnderBtnCompleted.backgroundColor = UIColor.white
        userCheckingForProducts = "active"
        self.getAllMyBookingProducts(serviceUrl: urlHistoryService)
    }
    @IBAction func btnCompletedTapped()
    {
        tableViewHistory.isHidden = true
        urlHistoryService = WebServices.BUYER_HISTOREY
        lblUnderBtnActive.backgroundColor = UIColor.white
        lblUnderBtnCompleted.backgroundColor = APP_COLOR
        userCheckingForProducts = "completed"
        self.getAllMyBookingProducts(serviceUrl: urlHistoryService)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
