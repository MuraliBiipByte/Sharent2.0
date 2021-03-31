//
//  ProductDetailsViewController.swift
//  ProductDetailsSharent
//
//  Created by Biipbyte on 07/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import ImageSlideshow
import FirebaseDynamicLinks
import LGSideMenuController
import SendBirdSDK

class ProductDetailsViewController: UIViewController,UICollectionViewDelegateFlowLayout,FloatRatingViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate
{
   
    
    weak var delegate: CreateGroupChannelSelectOptionViewControllerDelegate?

    var strProductId = String()
    var strProductName : String = ""
    var userIDs : [String] = []

    var strUserId = String()
     var strUserName = String()
     var strMerchantId = String()
     var strMerchantName = String()
    
    var favourite = Bool()
    var intAttributesCount = Int()
    var strAttribute1 : String = ""
    var strAttribute2 : String = ""
    
    @IBOutlet weak var aboutMerchantViewHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutMerchantView: UIView!
    
    
    @IBOutlet weak var editListingBtn: UIButton!
    @IBOutlet weak var editListingHeight: NSLayoutConstraint!
    
    
    
    var arrAttribute1 = [AnyObject]()
    var arrAttribute2 = [AnyObject]()
    
    let attributeTag = String()
    var arrAttribute1Name = NSMutableArray()
    var arrAttribute1Id = NSMutableArray()
    var arrAttribute2Name = NSMutableArray()
    var arrAttribute2Id = NSMutableArray()
    
    var strAttribute1Id = String()
    var strAttribute1Name = String()
    var strAttribute2Id = String()
    var strAttribute2Name = String()
    
    var type = String()
    
    var ProductDetails = [String:Any]()
    var arrProductImages = [String]()

    var arrReviews = [AnyObject]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSeeReviews: UIButton!
    @IBOutlet weak var imgMarchant: UIImageView!
    @IBOutlet weak var lblMarchantName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblMerchantAddress: UILabel!
    @IBOutlet weak var btnFav: UIButton!
//    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDaysRent: UILabel!
    
    @IBOutlet weak var lblProductCare: UILabel!
    @IBOutlet weak var lblProductOtherDescription: UILabel!
    
    @IBOutlet weak var btnAddtoCart: UIButton!
    
    @IBOutlet weak var reviewsTable: UITableView!
    
//    @IBOutlet weak var btnAttribute1: UIButton!
//    @IBOutlet weak var btnAttribute2: UIButton!
//
//    @IBOutlet weak var imgAttribute1: UIImageView!
//    @IBOutlet weak var imgAttribute2: UIImageView!
//    @IBOutlet weak var btnAttribute1Hight: NSLayoutConstraint!
//    @IBOutlet weak var btnAttribute2Hight: NSLayoutConstraint!
    
    
    @IBOutlet weak var relatedProductsView: UIView!
    @IBOutlet weak var relatedProductsViewHight: NSLayoutConstraint!
    @IBOutlet weak var viewProductImages: NSLayoutConstraint!
    @IBOutlet var bannersSlideshow: ImageSlideshow!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var productsView: UIView!
    // venue or service
    @IBOutlet weak var venueOrServiceVIew: UIView!
    
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblBookingPeriod: UILabel!
    @IBOutlet weak var lblAdvanceBookinDays: UILabel!
    @IBOutlet weak var lblAboutService: UILabel!
    @IBOutlet weak var lblServiceDesc: UILabel!
    @IBOutlet weak var lblServiceAdditionalInfo: UILabel!
    
    @IBOutlet weak var lblVenueUsage: UILabel!
    
    var userLoginType = String()

    @IBOutlet weak var showServiceDescView: UIView!
    
    @IBOutlet weak var showVenueUsageView: UIView!
    
    
    @IBOutlet weak var chatIcon: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let id =  UserDefaults.standard.value(forKey: "user_id")
        if id != nil
        {
            strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        }
        else
        {
            strUserId = ""
        }
        
         userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
        
        if userLoginType == BUYER
        {
            chatIcon.isHidden = false
            btnFav.isHidden = false
            aboutMerchantViewHeight.constant = 60
            aboutMerchantView.isHidden = false
            editListingBtn.isHidden = true
            editListingHeight.constant = 0
        }else{
            chatIcon.isHidden = true
            btnFav.isHidden = true
            aboutMerchantViewHeight.constant = 0
            aboutMerchantView.isHidden = true
            editListingBtn.isHidden = false
            editListingHeight.constant = 45
        }
        
        reviewsTable.dataSource = self
        reviewsTable.delegate = self
        self.reviewsTable.estimatedRowHeight = 82.0
        self.reviewsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        
        viewProductImages.constant = screenWidth - 32
        viewProductImages.isActive = true
        
        scrollView.isHidden = true

        relatedProductsViewHight.constant = 0
        relatedProductsViewHight.isActive = true
        relatedProductsView.isHidden = true
        
        
        //=====Corner Radious=========
        
        imgMarchant.layer.cornerRadius = imgMarchant.frame.width/2
        imgMarchant.layer.masksToBounds = true
        imgMarchant.layer.borderWidth = 0.2
        imgMarchant.layer.borderColor = NAVIGATION_COLOR.cgColor
        
        self.arrProductImages.removeAll()
        self.arrAttribute1Name.removeAllObjects()
        self.arrAttribute2Name.removeAllObjects()
        getProductDetails()
    
    }
    

    func getProductDetails()
    {
        self.scrollView.isHidden = true
     
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"user_id":strUserId]

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
                
                self.scrollView.isHidden = false
                self.scrollView.setContentOffset(CGPoint.zero, animated: false)
               
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                
                self.ProductDetails = (dataDictionary!["products"]as? [String:Any])!
                
                self.arrReviews = dataDictionary!["reviews"] as! [AnyObject]
                
                if self.arrReviews.count>0
                {
                    self.relatedProductsViewHight.constant = CGFloat((self.arrReviews.count * 82) + 100)
                    self.relatedProductsView.isHidden = false
                    self.reviewsTable.reloadData()
                    self.reviewsTable.setContentOffset(CGPoint(x:0,y:0), animated: false)
                }
                else
                {
                    self.relatedProductsViewHight.constant = 0
                    self.relatedProductsView.isHidden = true
                }
              
                    let marchantImage = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["company_image"]!))")
                    self.imgMarchant.sd_setImage(with: URL(string: marchantImage), placeholderImage: #imageLiteral(resourceName: "userplaceholder"))
                    self.lblMarchantName.text = self.ProductDetails["merchant_name"]as? String
                
                self.strMerchantName = self.lblMarchantName.text!
                self.strMerchantId = self.ProductDetails["merchant_id"] as! String
              
                self.userIDs.removeAll()
                
                self.userIDs.append(self.strUserId)
                self.userIDs.append(self.strMerchantId)
                
                self.lblMerchantAddress.text = self.ProductDetails["merchant_address"]as? String
                
                    let ProductImage1 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android1"]!))")
                    let ProductImage2 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android2"]!))")
                    let ProductImage3 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android3"]!))")
                    let ProductImage4 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android4"]!))")
                    let ProductImage5 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android5"]!))")
                    
                    let categoryName = self.ProductDetails["category_name"]as? String ?? ""
                   self.title = "DISCOVER \(categoryName.uppercased())"
                    
                    if (ProductImage1 != "\(WebServices.BASE_URL)")
                    {
                        self.arrProductImages.append(ProductImage1)
                    }
                    
                    if (ProductImage2 != "\(WebServices.BASE_URL)")
                    {
                        self.arrProductImages.append(ProductImage2)
                    }
                    if (ProductImage3 != "\(WebServices.BASE_URL)")
                    {
                        self.arrProductImages.append(ProductImage3)
                    }
                    if (ProductImage4 != "\(WebServices.BASE_URL)")
                    {
                        self.arrProductImages.append(ProductImage4)
                    }
                    if (ProductImage5 != "\(WebServices.BASE_URL)")
                    {
                        self.arrProductImages.append(ProductImage5)
                    }
                    if self.arrProductImages.count > 0
                    {
                        self.configurePageControl()
                    }
              
                self.strUserName = UserDefaults.standard.value(forKey: "userName") as! String

                let cartadded =  self.ProductDetails["cart_added"]as? String
                if cartadded == "no" {
                    self.btnAddtoCart.setTitle("Add to Cart", for: UIControl.State.normal)
                    self.btnAddtoCart.isUserInteractionEnabled = true
                }else{
                    self.btnAddtoCart.setTitle("Added to Cart", for: UIControl.State.normal)
                    self.btnAddtoCart.backgroundColor = UIColor.lightGray
                     self.btnAddtoCart.isUserInteractionEnabled = false
                }
                
                self.lblProductName.text = self.ProductDetails["product_name"]as? String
                self.strProductName = self.lblProductName.text!
                
                self.ratingView.editable = false
                let rating = String(describing:self.ProductDetails["average_rating"]as AnyObject)
             
                self.ratingView.rating = Double(rating)!
                self.ratingView.type = .wholeRatings
                self.ratingView.delegate = self
                self.ratingView.backgroundColor = UIColor.clear
                
                let ratings = String(describing:self.ProductDetails["total_ratings"]as AnyObject)
                self.lblRating.text = "\(ratings) ratings"
        
                self.type = (self.ProductDetails["type"] as? String)!
                    
                    if self.type == PRODUCT {
                        
                        self.productsView.isHidden = false
                        self.venueOrServiceVIew.isHidden = true
                      
                        self.lblDescription.text = self.ProductDetails["product_details"]as? String
                        self.lblProductOtherDescription.text = self.ProductDetails["description"]as? String
                        self.lblProductCare.text = self.ProductDetails["product_care"] as? String
                        let strFavourite = self.ProductDetails["favourite"]as? String
                        if strFavourite == "0"
                        {
                            self.favourite = false
                            self.btnFav .setImage(#imageLiteral(resourceName: "unfav"), for: UIControlState.normal)
                        }
                        else
                        {
                            self.favourite = true
                            self.btnFav .setImage(#imageLiteral(resourceName: "favorite"), for: UIControlState.normal)
                        }
                        self.lblPrice.text = "$\(String(describing:  self.ProductDetails["product_price"]! )) per day"
                        self.lblDaysRent.text = "\(String(describing:  self.ProductDetails["minimum_days"]! )) days"
                        
                    }

                    else if self.type == VENUE || self.type == SERVICE {
                        //venue
                        self.venueOrServiceVIew.isHidden = false
                        self.productsView.isHidden = true
     
                        self.lblFees.text = String(format: "$%@ per day", self.ProductDetails["price"] as! String)
                        
                        
                        self.lblBookingPeriod.text = String(format: "%@ days", self.ProductDetails["booking_duration"] as! String)
                        
                        self.lblAdvanceBookinDays.text = String(format: "%@ Days", self.ProductDetails["advance_booking_date"] as! String)
                        
                        self.lblAboutService.text = String(format: "%@", self.ProductDetails["product_details"] as! String)
                        
                        self.lblServiceAdditionalInfo.text = String(format: "%@", self.ProductDetails["description"] as! String)
                        
                        if self.type == SERVICE {
                            self.showVenueUsageView.isHidden = true
                            self.showServiceDescView.isHidden = false
                          
                            self.lblServiceDesc.text = String(format: "%@", self.ProductDetails["product_care"] as? String ?? "")
                        }else{
                            self.showVenueUsageView.isHidden = false
                            self.showServiceDescView.isHidden = true
                            
                            self.lblVenueUsage.text = String(format: "%@", self.ProductDetails["product_care"] as! String)
                        }
                     
                    }
            }
           
        }
    }
    
    
    @IBAction func editListingDetails_Tapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProductImagesViewController") as! CreateProductImagesViewController
        vc.editItem = true
        vc.ProductId = strProductId
        vc.strTitle = "Edit Listing Details"
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
    
    
    
    @IBAction func btn_back_tapped(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btn_SeeReviews_Tapped(_ sender: Any)
    {
        
        let seeAllReviewsVC = storyboard?.instantiateViewController(withIdentifier: "SeeAllReviewsViewController")as! SeeAllReviewsViewController
        seeAllReviewsVC.strProductId = strProductId
        self.navigationController?.pushViewController(seeAllReviewsVC, animated: true)
        
    }
    
    @IBAction func btn_Fav_Tapped(_ sender: Any)
    {
        
        if strUserId == ""
        {
            let alert = UIAlertController.init(title:APP_NAME, message: "Please Login to make this product as favourite", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController")as! NewLoginViewController
                self.navigationController?.pushViewController(viewController, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
            
        else{
            if favourite == false
            {
                let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"user_id":strUserId]
                self.view.StartLoading()
                ApiManager().postRequest(service: WebServices.MAKE_PRODUCT_FAVOURITE, params: paramsDic)
                { (result, success) in
                    self.view.StopLoading()
                    
                    if success == false
                    {
                        return
                    }
                    else
                    {
                        self.btnFav.setImage(#imageLiteral(resourceName: "favorite"), for: UIControlState.normal)
                        self.favourite = true
                    }
                }
            }
            else{
                let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId,"user_id":strUserId]
                self.view.StartLoading()
                ApiManager().postRequest(service: WebServices.MAKE_PRODUCT_FAVOURITE, params: paramsDic)
                { (result, success) in
                    self.view.StopLoading()
                    
                    if success == false
                    {
                        return
                    }
                    else
                    {
                        self.btnFav.setImage(#imageLiteral(resourceName: "unfav"), for: UIControlState.normal)
                        self.favourite = false
                        
                    }
                }
            }
        }
    }
    
    @IBAction func btn_Comments_Tapped(_ sender: Any) {
        
        if strUserId == ""
        {
            let alert = UIAlertController.init(title: APP_NAME, message: "Please Login to make this product as favourite", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController")as! NewLoginViewController
                self.navigationController?.pushViewController(viewController, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
            
        else{
        }
    }
//
//    @IBAction func btn_Share_Tapped(_ sender: Any) {
//
//
//
////        strProductId = "1"
//        print(strProductId)
//            guard let link = NSURL(string: "https://apps.apple.com/sg/app/sharent-rent-earn-save/id1422672482?prodId=\(self.strProductId)") else { return }
//
//        print(link)
//
//            let dynamicLinksDomain = "sharent.page.link"
//            let linkBuilder = DynamicLinkComponents(link: link as URL, domain: dynamicLinksDomain)
//
//            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.biipbyte.Sharent")
//            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.product.sharent")
//
//
//        guard let longDynamicLink = linkBuilder.url else { return }
//        print("The long URL is: \(longDynamicLink)")
//
//        linkBuilder.shorten() { longDynamicLink, warnings, error in
//            let url = longDynamicLink
//            print("The short URL is: \(url!)")
//
//            let objectsToShare = [url]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
//            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//            self.present(activityVC, animated: true, completion: nil)
//        }

//        //Set the link to share.
////        if let link = NSURL(string: "http://54.151.221.7/sharent_new/index.php/welcome/android/\(strProductId)")
////        {
////            let objectsToShare = [link]
////            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
////            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
////            self.present(activityVC, animated: true, completion: nil)
////        }
////        else{
////            let link = NSURL(string: "https://apps.apple.com/sg/app/sharent-rent-earn-save/id1422672482")
////            let objectsToShare = [link]
////            let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
////            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
////            self.present(activityVC, animated: true, completion: nil)
////        }
//    }
    
    
    @IBAction func btn_AddToCart_Tapped(_ sender: Any)
    {
        
        if strUserId == ""
        {
            let alert = UIAlertController.init(title:APP_NAME, message: "Please Login to purchase this product", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
                self.navigationController?.pushViewController(viewController, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else
        {
            let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmAddtoCartVC")as! ConfirmAddtoCartVC
            
            orderVc.ProductData = self.ProductDetails
            self.navigationController?.pushViewController(orderVc, animated: true)
        }
    }
    
    func configurePageControl()
    {
     
        var sdWebImageSource = [SDWebImageSource]()
        for index in 0..<self.arrProductImages.count
        {
            let image =  self.arrProductImages[index]
            sdWebImageSource.append(SDWebImageSource.init(url: URL(string: image)!, placeholder:UIImage(named: "productPlaceholder")))
        }
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = NAVIGATION_COLOR
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.isEnabled = false
        self.bannersSlideshow.pageIndicator = pageControl
        self.bannersSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        self.bannersSlideshow.setImageInputs(sdWebImageSource)
    }
    
    
    @IBAction func btn_chatTapped(_ sender: Any) {
      
        if SBDMain.getConnectState() == .closed {
             print("closed")
             connect()
//            ConnectionManager.login { (user, error) in
//                guard error == nil else {
//                    return
//                }
//            }
        }
        else {
//            self.loadPreviousMessage(initial: true)
            print("opened")
               self.createchannelWithname()
        }

    }

    func connect() {
        
        let trimmedUserId: String = (self.strUserId.trimmingCharacters(in: NSCharacterSet.whitespaces))
        let trimmedNickname: String = (self.strUserName.trimmingCharacters(in: NSCharacterSet.whitespaces))
        
        guard trimmedUserId.count > 0 && trimmedNickname.count > 0 else {
            return
        }
      
        self.view.StartLoading()
      
        ConnectionManager.login(userId: trimmedUserId, nickname: trimmedNickname) { (user, error) in
            DispatchQueue.main.async {
                self.view.StopLoading()
            }
            
            guard error == nil else {
                let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                vc.addAction(closeAction)
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
                
                return
            }
            
            self.createchannelWithname()
//            DispatchQueue.main.async {
//                let vc: ChatMenuViewController = ChatMenuViewController()
//                self.present(vc, animated: false, completion: nil)
//            }
        }
    }
    
    
//    func createNewChannel() {
//    SBDGroupChannel.createChannel(withUserIds: USER_IDS, isDistinct: IS_DISTINCT) { (groupChannel, error) in
//    guard error == nil else {   // Error.
//    return
//    }
//    }
//    }
//
    
    
    func createchannelWithname() {
        
        SBDGroupChannel.createChannel(withName: strUserName, isDistinct: true, userIds: userIDs, coverUrl: nil, data: nil, customType: nil) { (groupChannel, error) in
            guard error == nil else {
                let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                
                let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: { (action) in
                    
                })
                vc.addAction(closeAction)
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
                
                return
            }
            
            print("channel created.")
            
            self.delegate?.didFinishCreating(channel: groupChannel!, vc: self)
            
            let vc = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
            print(groupChannel!)
            vc.groupChannel = groupChannel
            vc.channelTitle = self.strProductName
            
            self.present(vc, animated: false, completion: nil)
            
        }
    }
 
    
//    @IBAction func btnAttribute1_Tapped(_ sender: Any)
//    {
//
//
//        ActionSheetStringPicker.show(withTitle: "Choose ", rows: arrAttribute1Name as? [Any], initialSelection: 0, doneBlock:
//            {
//                picker, value, index in
//
//                print("value = \(value)")
//
//                self.strAttribute1Name = (String(describing: index!) )
//                self.strAttribute1Id = (String(describing: self.arrAttribute1Id[value]) )
////                self.btnAttribute1.setTitle("  \(self.strAttribute1Name)", for: UIControlState.normal)
//
//                print(self.strAttribute1Name)
//                print(self.strAttribute1Id)
//                print(self.strAttribute1 )
//                ProductInformation.attribute1Id = self.arrAttribute1Id[value] as? String
//                ProductInformation.attribute1Name = self.arrAttribute1Name[value] as? String
//
//                return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//
//    }
    
//    @IBAction func btnAttribute2_Tapped(_ sender: Any)
//    {
//        ActionSheetStringPicker.show(withTitle: "Choose ", rows: arrAttribute2Name as? [Any], initialSelection: 0, doneBlock:
//            {
//                picker, value, index in
//
//                print("value = \(value)")
//
//                self.strAttribute2Name = (String(describing: index!) )
//                self.strAttribute2Id = (String(describing: self.arrAttribute2Id[value]) )
////                self.btnAttribute2.setTitle("  \(self.strAttribute2Name)", for: UIControlState.normal)
//
//                ProductInformation.attribute2Id = self.arrAttribute2Id[value] as? String
//                ProductInformation.attribute2Name = self.arrAttribute2Name[value] as? String
//                return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReviews.count
        //        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "MyReviewTableViewCell", for: indexPath) as! MyReviewTableViewCell
        
        let image =  "\(WebServices.BASE_URL)\(self.arrReviews[indexPath.row]["user_image"] as! String)"
        cell.imgUser.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        
        
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2
//        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height / 2
        
        cell.lbl_UserName.text = self.arrReviews[indexPath.row]["user_name"] as? String
        
        cell.ratingView.editable = false
        let rating = String(describing:self.arrReviews[indexPath.row]["rating"]as AnyObject)
        cell.ratingView.rating = Double(rating)!
        cell.ratingView.type = .wholeRatings
        cell.ratingView.delegate = self
        cell.ratingView.backgroundColor = UIColor.clear
        //        cell.reviewRating.tintColor = UIColor.black
        
        cell.lbl_Comment.text = self.arrReviews[indexPath.row]["comment"] as? String
        
        cell.selectionStyle = .none
       
//         cell.lbl_date.text = self.arrReviews[indexPath.row]["comment"] as? String
        return cell
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
extension UIViewController
{
    func attributesloop(mainAttributeArray:[AnyObject],arrAttributeName:NSMutableArray)
    {
        if mainAttributeArray.count>0
        {
            for value  in mainAttributeArray
            {
                arrAttributeName.add(value["name"])
//                arrattributeId.add(value["id"])
            }
        }
    }
}

