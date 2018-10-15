//
//  MerchantProductDetailsViewController.swift
//  Sharent
//
//  Created by Biipbyte on 02/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MerchantProductDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate
{
   
    var strProductId = String()
    var strUserId = String()
    var userName = String()
    var userImage :String? = ""
   
    var ProductDetails = [String:Any]()
    var bookingHistoryDetails = [AnyObject]()
    
    var arrProductImages = [String]()
    
    var arrReferenceIds = [AnyObject]()
    
    @IBOutlet weak var lblBookingCalender: UILabel!
    @IBOutlet weak var tableviewBookingDetailsHeight:NSLayoutConstraint!
    
    @IBOutlet weak var tableviewBookingDetails:UITableView!
    
    @IBOutlet weak var collectionViewProductImages:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    @IBOutlet weak var imgProfileMerchant:UIImageView!
    @IBOutlet weak var lblMerchantName:UILabel!
    
    @IBOutlet weak var lblProductName:UILabel!
    @IBOutlet weak var lblProductRate:UILabel!
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Product Summary"
        
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        
        userName = UserDefaults.standard.value(forKey: "userName") as! String
        userImage = UserDefaults.standard.value(forKey: "userImage")as? String
        lblMerchantName.text = userName
        let image =  String("\(WebServices.BASE_URL)\(userImage ?? "")")
        imgProfileMerchant?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
        imgProfileMerchant.layer.cornerRadius = imgProfileMerchant.frame.size.height/2
        imgProfileMerchant.layer.masksToBounds = true
        
        tableviewBookingDetails.delegate = self
        tableviewBookingDetails.dataSource = self
        
        collectionViewProductImages.delegate = self
        collectionViewProductImages.dataSource = self
        
        tableviewBookingDetailsHeight.constant = 0.0
        tableviewBookingDetailsHeight.isActive = true
        tableviewBookingDetails.isHidden = true
        
        lblBookingCalender.isHidden = true
        getProductDetails()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    func getProductDetails()
    {
        self.scrollView.isHidden = true
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"merchant_id":strUserId]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.MERCHANT_PRODUCT_DETAILS, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.scrollView.isHidden = true
                self.showAlert(message: result as! String)
                return
            }
            else
            {
               self.scrollView.isHidden = false
                
                let response = result as! [String : Any]
                let dataDictionary = response ["data"]as! [String:Any]
                self.ProductDetails = dataDictionary["products"] as! [String : Any]
                self.bookingHistoryDetails = dataDictionary["booked_history"] as! [AnyObject]
        
                if self.bookingHistoryDetails.count > 0
                {
                    self.lblBookingCalender.isHidden = false
                    self.tableviewBookingDetails.isHidden = false
                    self.tableviewBookingDetails.reloadData()
                    self.tableviewBookingDetailsHeight.constant = self.tableviewBookingDetails.contentSize.height
                    
                    for historyData in self.bookingHistoryDetails
                    {
                        self.arrReferenceIds.append(historyData["reference_id"] as AnyObject)
                    }
                }
                
                _ = ProductInformation.init(productDetailsDictionay: self.ProductDetails)
                
                self.lblProductName.text = ProductInformation.productName
                self.lblProductRate.text = String(format: "$%@ Per Day", ProductInformation.productPrice!)
                
                if ProductInformation.productImage1 != ""
                {
                    let ProductImage1 = "\(WebServices.BASE_URL)\(ProductInformation.productImage1!)"
                    self.arrProductImages.append(ProductImage1 )
                }
                if ProductInformation.productImage2 != ""
                {
                    let ProductImage2 = "\(WebServices.BASE_URL)\(ProductInformation.productImage2!)"
                    self.arrProductImages.append(ProductImage2)
                }
                if ProductInformation.productImage3 != ""
                {
                    let ProductImage3 = "\(WebServices.BASE_URL)\(ProductInformation.productImage3!)"
                    self.arrProductImages.append(ProductImage3)
                }
                if ProductInformation.productImage4 != ""
                {
                    let ProductImage4 = "\(WebServices.BASE_URL)\(ProductInformation.productImage4!)"
                    self.arrProductImages.append(ProductImage4)
                }
                if ProductInformation.productImage5 != ""
                {
                    let ProductImage5 = "\(WebServices.BASE_URL)\(ProductInformation.productImage5!)"
                    self.arrProductImages.append(ProductImage5 )
                }
                if self.arrProductImages.count > 0
                {
                    self.collectionViewProductImages.reloadData()
                    self.configurePageControl()
                }
                    
            }
        }
    }
    func configurePageControl()
    {
        
        self.pageControl.numberOfPages = self.arrProductImages.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = Constants.NAVIGATION_COLOR
        self.pageControl.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bookingHistoryDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDatesTableViewCell") as! BookingDatesTableViewCell
        let bookedUsername = self.bookingHistoryDetails[indexPath.row]["user_name"] as! String
        let bookedFromDate = self.bookingHistoryDetails[indexPath.row]["rental_period_startdate"] as! String
        let bookedToDate = self.bookingHistoryDetails[indexPath.row]["rental_period_enddate"] as! String
        let userdetailswithdates = String(format: " %@ : %@ to %@",bookedUsername,bookedFromDate,bookedToDate)
        
        cell.lblUserdetailswithDates.text = userdetailswithdates
      
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let bookingDetails = self.storyboard?.instantiateViewController(withIdentifier: "BookedProductDetailsViewController") as! BookedProductDetailsViewController
        bookingDetails.referenceProductId = self.arrReferenceIds[indexPath.row] as! String
        self.navigationController?.pushViewController(bookingDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrProductImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        let image =  "\(self.arrProductImages[indexPath.row] )"
        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func btn_SeeReviews_Tapped(_ sender: Any)
    {
        
        let seeAllReviewsVC = storyboard?.instantiateViewController(withIdentifier: "SeeAllReviewsViewController")as! SeeAllReviewsViewController
        seeAllReviewsVC.strProductId = strProductId
        self.navigationController?.pushViewController(seeAllReviewsVC, animated: true)
        
    }
    
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
