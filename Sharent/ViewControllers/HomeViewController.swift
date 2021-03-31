//
//  HomeViewController.swift
//  Sharent
//
//  Created by Biipbyte on 04/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import LGSideMenuController
import SDWebImage
import ImageSlideshow


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, FloatRatingViewDelegate
{
    
    //Banners
    @IBOutlet var bannersSlideshow: ImageSlideshow!
    @IBOutlet weak var bannersHight: NSLayoutConstraint! //184
    
    
    //quick picks
    @IBOutlet weak var quickPicksViewHight: NSLayoutConstraint! //163
    @IBOutlet weak var quickPicksCollectionView: UICollectionView!
    @IBOutlet weak var quickPicksView: UIView!
    
    // featured brands
    @IBOutlet weak var featuredBrandsView: UIView!
    @IBOutlet weak var featuredBrandsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featuredBrandsCollectionView: UICollectionView!
    
    @IBOutlet weak var productsSeparator: UILabel!
    @IBOutlet weak var venuesSeparator: UILabel!
    @IBOutlet weak var serviceSeparator: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCategoryHight: NSLayoutConstraint!
    
    @IBOutlet weak var lblVenueCategory: UILabel!
    @IBOutlet weak var lblVenueCategoryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblServiceCategory: UILabel!
    @IBOutlet weak var lblServiceCategoryHeight: NSLayoutConstraint!
    //Category1 Collection View
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollctionViewHight1: NSLayoutConstraint!
    
    //Category2 Collection View
    @IBOutlet weak var categoryCollectionView2: UICollectionView!
    @IBOutlet weak var catagorycollectionViewHight2: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //     Venue Collection 1
    @IBOutlet weak var venueCollectionView1: UICollectionView!
    @IBOutlet weak var venueCollectionView1Height: NSLayoutConstraint!
    
    //     Venue Collection 2
    @IBOutlet weak var venueCollectionView2: UICollectionView!
    @IBOutlet weak var venueCollectionView2Height: NSLayoutConstraint!
    
    // Service Collection1
    @IBOutlet weak var serviceCollectionView1: UICollectionView!
    @IBOutlet weak var serviceCollectionview1Height: NSLayoutConstraint!
    
    // Service collection2
    @IBOutlet weak var serviceCollectionview2: UICollectionView!
    @IBOutlet weak var serviceCollectionView2Height: NSLayoutConstraint!
    
    
    // Hot Items
    @IBOutlet weak var hotItemsView: UIView!
    @IBOutlet weak var hotItemsCollectionView: UICollectionView!
    @IBOutlet weak var hotItemsViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var hotItemsCollectionViewHeight: NSLayoutConstraint!
    
    var userId :String? = "0"
    var paramsDic = [String:Any]()
    var arrBanners = [AnyObject]()
    var bannerId : Any = 0
    
    var arrQuickPicks = [AnyObject]()
    var arrFeaturedBrands = [AnyObject]()
    var arrTagids = [AnyObject]()
    var arrTagNames = [AnyObject]()
    var arrHotItems = [AnyObject]()
    
    var arrFeaturedProducts = [AnyObject]()
    var arrPopularPicks = [AnyObject]()
    var arrFeaturedDeals = [AnyObject]()
    var arrCategories = [AnyObject]()
    var arrCategories2 = [AnyObject]()
    
    
    var arrVenueCategories1 = [AnyObject]()
    var arrVenueCategories2 = [AnyObject]()
    
    var arrServiceCategories1 = [AnyObject]()
    var arrServiceCategories2 = [AnyObject]()
    
    
    var arrCategorieids = [AnyObject]()
    var arrCategorieNames = [AnyObject]()
    var arrCategorieids2 = [AnyObject]()
    var arrCategorieNames2 = [AnyObject]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "DISCOVER"
        scrollView.isHidden = true
        
        self.bannersSlideshow.isHidden = true
        self.bannersHight.constant = 0
        self.bannersHight.isActive = true
        
        self.quickPicksView.isHidden = true
        self.quickPicksViewHight.constant = 0
        self.quickPicksViewHight.isActive = true
        
        self.featuredBrandsView.isHidden = true
        self.featuredBrandsViewHeight.constant = 0
        self.featuredBrandsViewHeight.isActive = true
        
        // Products
        self.lblCategoryHight.constant = 0
        self.lblCategoryHight.isActive = true
        self.productsSeparator.isHidden = true
        
        self.categoryCollctionViewHight1.constant = 0
        self.categoryCollctionViewHight1.isActive = true
        
        self.catagorycollectionViewHight2.constant = 0
        self.catagorycollectionViewHight2.isActive = true
        
        
        // Venue
        self.lblVenueCategoryHeight.constant = 0
        self.lblVenueCategoryHeight.isActive = true
        self.venuesSeparator.isHidden = true
        
        self.venueCollectionView1Height.constant = 0
        self.venueCollectionView1Height.isActive = true
        
        self.venueCollectionView2Height.constant = 0
        self.venueCollectionView2Height.isActive = true
        
        // Service
        self.lblServiceCategoryHeight.constant = 0
        self.lblServiceCategoryHeight.isActive = true
        self.serviceSeparator.isHidden = true
        
        self.serviceCollectionview1Height.constant = 0
        self.serviceCollectionview1Height.isActive = true
        
        self.serviceCollectionView2Height.constant = 0
        self.serviceCollectionView2Height.isActive = true
        
        
        
        
        self.hotItemsView.isHidden = true
        self.hotItemsViewHeight.constant = 0
        self.hotItemsViewHeight.isActive = true
        
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        
        getAllCategories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //         getAllCategories()
    }
    
    
    func getAllCategories()
    {
        
        
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":BUYER,"merchant_id" : userId!]
        
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.GET_ALL_PRODUCTS_BUYER, params: paramsDic) { (result, success) in
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
                let data = response ["data"] as! [String:Any]
                
                let cartCount = data["cart_count"] as? String ?? "0"
                let  IntcartCount = Int(cartCount)
                UserDefaults.standard.set(IntcartCount, forKey: "cart_count")
                self.arrBanners = (data["banners"] as? [AnyObject]) != nil  ?  (data["banners"] as! [AnyObject]) : []
                
                self.arrQuickPicks = (data["tags"] as? [AnyObject]) != nil  ?  (data["tags"] as! [AnyObject]) : []
                
                self.arrFeaturedBrands = (data["brands"] as? [AnyObject]) != nil  ?  (data["brands"] as! [AnyObject]) : []
                
                self.arrFeaturedProducts = (data["featured_products"] as? [AnyObject]) != nil  ?  (data["featured_products"] as! [AnyObject]) : []
                self.arrFeaturedDeals = (data["featured_deals"] as? [AnyObject]) != nil  ?  (data["featured_deals"] as! [AnyObject]) : []
                self.arrPopularPicks = (data["popular"] as? [AnyObject]) != nil  ?  (data["popular"] as! [AnyObject]) : []
                
                self.arrCategories = (data["product_category1"] as? [AnyObject]) != nil  ?  (data["product_category1"] as! [AnyObject]) : []
                self.arrCategories2 = (data["product_category2"] as? [AnyObject]) != nil  ?  (data["product_category2"] as! [AnyObject]) : []
                
                
                self.arrVenueCategories1 = (data["venue_category1"] as? [AnyObject]) != nil  ?  (data["venue_category1"] as! [AnyObject]) : []
                self.arrVenueCategories2 = (data["venue_category2"] as? [AnyObject]) != nil  ?  (data["venue_category2"] as! [AnyObject]) : []
                
                self.arrServiceCategories1 = (data["service_category1"] as? [AnyObject]) != nil  ?  (data["service_category1"] as! [AnyObject]) : []
                self.arrServiceCategories2 = (data["service_category2"] as? [AnyObject]) != nil  ?  (data["service_category2"] as! [AnyObject]) : []
                
                self.arrHotItems = (data["hot_products"] as? [AnyObject]) != nil  ?  (data["hot_products"] as! [AnyObject]) : []
                
                if (self.arrBanners.count > 0)
                {
                    self.bannersSlideshow.isHidden = false
                    self.configurePageControl1()
                    self.bannersHight.constant = 199
                }
                if (self.arrQuickPicks.count > 0)
                {
                    self.quickPicksView.isHidden = false
                    self.quickPicksViewHight.constant = 224
                    self.quickPicksCollectionView.reloadData()
                }
                if (self.arrFeaturedBrands.count > 0)
                {
                    self.featuredBrandsView.isHidden = false
                    self.featuredBrandsViewHeight.constant = 233
                    self.featuredBrandsCollectionView.reloadData()
                }
                
                // Products
                if (self.arrCategories.count > 0)
                {
                    self.lblCategoryHight.constant = 40
                    self.productsSeparator.isHidden = false
                    self.categoryCollctionViewHight1.constant = 166.5
                    self.categoryCollectionView.reloadData()
                }
                if (self.arrCategories2.count > 0)
                {
                    self.lblCategoryHight.constant = 40
                    self.productsSeparator.isHidden = false
                    self.catagorycollectionViewHight2.constant = 166.5
                    self.categoryCollectionView2.reloadData()
                }
                
                // Venue
                if (self.arrVenueCategories1.count > 0)
                {
                    self.lblVenueCategoryHeight.constant = 40
                    self.venuesSeparator.isHidden = false
                    self.venueCollectionView1Height.constant = 166.5
                    self.venueCollectionView1.reloadData()
                }
                if (self.arrVenueCategories2.count > 0)
                {
                    self.lblVenueCategoryHeight.constant = 40
                    self.venuesSeparator.isHidden = false
                    self.venueCollectionView2Height.constant = 166.5
                    self.venueCollectionView2.reloadData()
                }
                
                // Service
                if (self.arrServiceCategories1.count > 0)
                {
                    self.lblServiceCategoryHeight.constant = 40
                    self.serviceSeparator.isHidden = false
                    self.serviceCollectionview1Height.constant = 166.5
                    self.serviceCollectionView1.reloadData()
                }
                if (self.arrServiceCategories2.count > 0)
                {
                    self.lblServiceCategoryHeight.constant = 40
                    self.serviceSeparator.isHidden = false
                    self.serviceCollectionView2Height.constant = 166.5
                    self.serviceCollectionview2.reloadData()
                }
                
                if (self.arrHotItems.count > 0)
                {
                    self.hotItemsView.isHidden = false
                    if self.arrHotItems.count%2  == 0 {
                        self.hotItemsViewHeight.constant = CGFloat((self.arrHotItems.count/2 * 260) + 60)
                    }else{
                         self.hotItemsViewHeight.constant = CGFloat((((self.arrHotItems.count + 1)/2) * 260) + 60)
                    }
                   
                    
                    self.hotItemsCollectionView.reloadData()
                }
                
            }
        }
        
    }
    
    func configurePageControl1()
    {
        self.bannersSlideshow.layer.cornerRadius = 8
        self.bannersSlideshow.layer.masksToBounds = true
        
        var sdWebImageSource = [SDWebImageSource]()
        for index in 0..<self.arrBanners.count
        {
            let image =  "\(WebServices.BASE_URL)\(self.arrBanners[index]["image"] as! String)"
            sdWebImageSource.append(SDWebImageSource.init(url: URL(string: image)!, placeholder:UIImage(named: "productPlaceholder")))
            
        }
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = NAVIGATION_COLOR
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        pageControl.isEnabled = false
        self.bannersSlideshow.pageIndicator = pageControl
        self.bannersSlideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        self.bannersSlideshow.slideshowInterval = 4.0
        self.bannersSlideshow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.showBannerDetails(_:)))
        
        self.bannersSlideshow.addGestureRecognizer(recognizer)
        
    }
    
    
    @objc func showBannerDetails(_ sender: UIButton?) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "BannerDetailsViewController") as! BannerDetailsViewController
        
        bannerId = self.arrBanners[bannersSlideshow.currentPage]["id"]!!
        
        controller.bannerID = bannerId
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    //    func configurePageControl2()
    //    {
    //        self.featuredDealsSlideshow.layer.cornerRadius = 8
    //        self.featuredDealsSlideshow.layer.masksToBounds = true
    //        var sdWebImageSource = [SDWebImageSource]()
    //        for index in 0..<self.arrFeaturedDeals.count
    //        {
    //            let image =  "\(WebServices.BASE_URL)\(self.arrFeaturedDeals[index]["image"] as! String)"
    //            sdWebImageSource.append(SDWebImageSource.init(url: URL(string: image)!, placeholder:UIImage(named: "productPlaceholder")))
    //        }
    //        let pageControl = UIPageControl()
    //        pageControl.currentPageIndicatorTintColor = APPEARENCE_COLOR
    //        pageControl.pageIndicatorTintColor = UIColor.lightGray
    //        pageControl.isEnabled = false
    //        self.featuredDealsSlideshow.pageIndicator = pageControl
    //        self.featuredDealsSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
    //        self.featuredDealsSlideshow.slideshowInterval = 4.0
    //        self.featuredDealsSlideshow.setImageInputs(sdWebImageSource)
    //    }
    
    @IBAction func btnMenu_Tapped(_ sender: Any)
    {
     
        UIView.animate(withDuration: 0.4, animations:
            {
                self.sideMenuController?.leftViewWidth = self.view.frame.width - 100
                
                self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if collectionView == quickPicksCollectionView
        {
            return arrQuickPicks.count
        }
        else if collectionView == featuredBrandsCollectionView
        {
            return arrFeaturedBrands.count
        }
            
            // Products
        else if collectionView == categoryCollectionView
        {
            return arrCategories.count
        }
        else if collectionView == categoryCollectionView2
        {
            return arrCategories2.count
        }
            
            // Venues
        else if collectionView == venueCollectionView1
        {
            return arrVenueCategories1.count
        }
        else if collectionView == venueCollectionView2
        {
            return arrVenueCategories2.count
        }
            
            // Service
        else if collectionView == serviceCollectionView1
        {
            return arrServiceCategories1.count
        }
        else if collectionView == serviceCollectionview2
        {
            return arrServiceCategories2.count
        }
            
        else if collectionView == hotItemsCollectionView
        {
            return arrHotItems.count
        }
        else
        {
            return arrFeaturedDeals.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        // corner radius
//        cell.layer.cornerRadius = 10
//        // border
//        cell.layer.borderWidth = 0.2
//        cell.layer.borderColor = APPEARENCE_COLOR.cgColor
        // shadow
//        cell.layer.shadowColor = UIColor.blue.cgColor
//        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
//        cell.layer.shadowOpacity = 1.7
//        cell.layer.shadowRadius = 4.0
//
//
        
        if collectionView == quickPicksCollectionView
        {
            
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrQuickPicks[indexPath.row]["image"] as! String)"
            cell.imgQuickPick.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            cell.quickPickTagName.text = self.arrQuickPicks[indexPath.row]["name"] as? String
            
        }
        if collectionView == featuredBrandsCollectionView
        {
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrFeaturedBrands[indexPath.row]["image"] as! String)"
            cell.imgFeaturedProducts.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            
        }
        
        // Products
        if collectionView == categoryCollectionView
        {
            
//            cell.lblCategory1OverLay.layer.cornerRadius = 8
//            cell.lblCategory1OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrCategories[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.ImgCategory1.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory1.text = self.arrCategories[indexPath.row]["name"] as? String
            }
            
            
        }
        if collectionView == categoryCollectionView2
        {
//            cell.lblCategory2OverLay.layer.cornerRadius = 8
//            cell.lblCategory2OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrCategories2[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.imgCategory2.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory2.text = self.arrCategories2[indexPath.row]["name"] as? String
            }
        }
        
        // Venues
        if collectionView == venueCollectionView1
        {
            
//            cell.lblCategory1OverLay.layer.cornerRadius = 8
//            cell.lblCategory1OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrVenueCategories1[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.ImgCategory1.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory1.text = self.arrVenueCategories1[indexPath.row]["name"] as? String
            }
            
        }
        if collectionView == venueCollectionView2
        {
//            cell.lblCategory2OverLay.layer.cornerRadius = 8
//            cell.lblCategory2OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrVenueCategories2[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.imgCategory2.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory2.text = self.arrVenueCategories2[indexPath.row]["name"] as? String
            }
        }
      
        // Service
        if collectionView == serviceCollectionView1
        {
            
//            cell.lblCategory1OverLay.layer.cornerRadius = 8
//            cell.lblCategory1OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrServiceCategories1[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.ImgCategory1.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory1.text = self.arrServiceCategories1[indexPath.row]["name"] as? String
            }
            
            
        }
        if collectionView == serviceCollectionview2
        {
//            cell.lblCategory2OverLay.layer.cornerRadius = 8
//            cell.lblCategory2OverLay.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrServiceCategories2[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.imgCategory2.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                    
                    cell.lblCategory2.text = self.arrServiceCategories2[indexPath.row]["name"] as? String
            }
        }
        
        if collectionView == hotItemsCollectionView
        {
          
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOpacity = 1
            cell.layer.shadowOffset = CGSize.zero
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = false
            
            let image =  "\(WebServices.BASE_URL)\(self.arrHotItems[indexPath.row]["photo_android1"] as! String)"
            cell.itemImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
            cell.itemName.text = self.arrHotItems[indexPath.row]["product_name"] as? String
            cell.itemRate.text = String(format: "$%@ Per Day", self.arrHotItems[indexPath.row]["price"] as! String)
            
            cell.rateView.editable = false
            cell.rateView.rating = Double(self.arrHotItems[indexPath.row]["average_rating"] as! Int)
            cell.rateView.type = .wholeRatings
            cell.rateView.delegate = self
            cell.rateView.backgroundColor = UIColor.clear
            
            cell.rateLbl.text = "\(self.arrHotItems[indexPath.row]["total_ratings"]! ?? 0) ratings"
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        // quick picks
        if collectionView == quickPicksCollectionView {
            
            self.arrTagids.removeAll()
            self.arrTagNames.removeAll()
            
            for tagsData in self.arrQuickPicks
            {
                
                self.arrTagids.append(tagsData["id"] as AnyObject)
                self.arrTagNames.append(tagsData["name"] as AnyObject)
                
            }
            
            let tagId =  self.arrTagids[indexPath.row] as! String
            let catagoryName = self.arrTagNames[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.tagId = tagId
            products.catagoryName = catagoryName
            
            products.arrCatagoryids = self.arrTagids
            products.arrCatagoryNames = self.arrTagNames
            
            self.navigationController?.pushViewController(products, animated: true)
            
        }
        
        // Products
        if collectionView == categoryCollectionView
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrCategories
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
        
        if collectionView == categoryCollectionView2
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrCategories
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids2[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames2[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
        
        // Venues
        if collectionView == venueCollectionView1
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrVenueCategories1
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrVenueCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
        
        
        if collectionView == venueCollectionView2
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrVenueCategories1
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrVenueCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids2[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames2[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
        
        // Service
        if collectionView == serviceCollectionView1
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrServiceCategories1
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrServiceCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
        
        
        if collectionView == serviceCollectionview2
        {
            self.arrCategorieids.removeAll()
            self.arrCategorieNames.removeAll()
            self.arrCategorieids2.removeAll()
            self.arrCategorieNames2.removeAll()
            for catagoryData in self.arrServiceCategories1
            {
                self.arrCategorieids.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames.append(catagoryData["name"] as AnyObject)
                
            }
            for catagoryData in self.arrServiceCategories2
            {
                self.arrCategorieids2.append(catagoryData["id"] as AnyObject)
                self.arrCategorieNames2.append(catagoryData["name"] as AnyObject)
            }
            
            let catagoryId =  self.arrCategorieids2[indexPath.row] as! String
            let catagoryName = self.arrCategorieNames2[indexPath.row] as! String
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            products.catagoryId = catagoryId
            products.catagoryName = catagoryName
            products.arrCatagoryids = self.arrCategorieids + self.arrCategorieids2
            products.arrCatagoryNames = self.arrCategorieNames + self.arrCategorieNames2
            
            self.navigationController?.pushViewController(products, animated: true)
        }
      
        // featured brands
        if collectionView == featuredBrandsCollectionView {
            
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductsViewController" )as! ProductsViewController
            
            products.merchantID =  self.arrFeaturedBrands[indexPath.row]["merchant_id"] as! String
            products.catagoryName =  self.arrFeaturedBrands[indexPath.row]["name"] as! String
            self.navigationController?.pushViewController(products, animated: true)
            
            
        }
        if collectionView == hotItemsCollectionView {
            
            let productdetailVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")as! ProductDetailsViewController
            
            productdetailVc.strProductId = (self.arrHotItems[indexPath.row]["product_id"] as? String)!
            self.navigationController?.pushViewController(productdetailVc, animated: true)
        }
        
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    
}

