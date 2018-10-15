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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate
{
    
    //Banners
    @IBOutlet weak var bannersCollectionView: UICollectionView!
    @IBOutlet weak var bannersHight: NSLayoutConstraint! //184
    
    //FeaturedBrands
    @IBOutlet weak var featuredBrandsViewHight: NSLayoutConstraint! //163
    @IBOutlet weak var featurebrandsCollectionView: UICollectionView!
    @IBOutlet weak var featuredBrandsView: UIView!

    //featured Products
    @IBOutlet weak var featuredProductsView: UIView!
    @IBOutlet weak var featuredProductsCollectionView: UICollectionView!
    @IBOutlet weak var feturedProductsHight: NSLayoutConstraint! //163
    
    //Popular Picks
    @IBOutlet weak var popularPicks: UIView!
    @IBOutlet weak var popularPicksCollectionView: UICollectionView!
    @IBOutlet weak var popularPicksViewHight: NSLayoutConstraint!
    
    //Featured deals
    @IBOutlet weak var featuredDealsView: UIView!
     @IBOutlet weak var featureDealsCollectionView: UICollectionView!
    @IBOutlet weak var featuredDealsHight: NSLayoutConstraint!
    @IBOutlet weak var lblfeaturedDeals: UILabel!
    @IBOutlet weak var lblFaturedDealsHight: NSLayoutConstraint!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCategoryHight: NSLayoutConstraint!
    
    
    //Category1 Collection View
 
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollctionViewHight1: NSLayoutConstraint!
    
    //Category2 Collection View
    @IBOutlet weak var categoryCollectionView2: UICollectionView!
    @IBOutlet weak var catagorycollectionViewHight2: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var pageControl2:UIPageControl!
   
    
    var userLoginType : String? = ""
    var userId :String? = ""
    var paramsDic = [String:Any]()
   


    var arrBanners = [AnyObject]()
    var arrFeaturedBrands = [AnyObject]()
    var arrFeaturedProducts = [AnyObject]()
    var arrPopularPicks = [AnyObject]()
    var arrFeaturedDeals = [AnyObject]()
    var arrCategories = [AnyObject]()
    var arrCategories2 = [AnyObject]()
    
    var arrCategorieids = [AnyObject]()
    var arrCategorieNames = [AnyObject]()
    var arrCategorieids2 = [AnyObject]()
    var arrCategorieNames2 = [AnyObject]()
    
    var arrFeaturedBrandids = [AnyObject]()
    var arrFeaturedBrandNames = [AnyObject]()
    var arrPopularPickids = [AnyObject]()
    var arrPopularPickidNames = [AnyObject]()
    var arrBannerids = [AnyObject]()
    var arrBannernames = [AnyObject]()
    
    var arrIds = [String]()
    var arrNames = [String]()
    var arrImages = [String]()
    
    var image = UIImage()
    var pixelHeight = CGFloat()
    
    var loginemail :String? = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // No need for semicolon
        
        
        self.navigationController?.navigationBar.isHidden = false
    
        self.title = "Home"
        
        scrollView.isHidden = true
        self.pageControl1.isHidden = true
        self.pageControl2.isHidden = true
        
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        
        ///Check installed app Version to show popup to user
        if userId != nil
        {
            loginemail = UserDefaults.standard.value(forKey: "email") as? String
            existingEmailChecking()
        }  
        getAllCategories()
        
    }
    
    func existingEmailChecking()
    {
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY, "email":loginemail!, "user_type":userLoginType!]
        ApiManager().postRequest(service: WebServices.EXISTING_EMAIL_CHECKING, params: paramsDict) { (result, success) in
            
            if success == false
            {
    
                 //   self.showAlert(message: "Please Contact admit to register your mail as marchant")
             
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                let userDataDictionary:[String:Any]? = dataDictionary?["userdata"] as? [String : Any]
                
                _ = User(userDictionay: userDataDictionary!)
                UserDefaults.standard.set(User.userID, forKey: "user_id")
                UserDefaults.standard.set(User.username, forKey: "userName")
                UserDefaults.standard.set(User.photouser, forKey: "userImage")
                UserDefaults.standard.set(User.usertype, forKey: "user_type")
                UserDefaults.standard.set(User.phone, forKey: "user-phone")
                UserDefaults.standard.set(User.usercompany, forKey: "company")
                UserDefaults.standard.set(User.useraddress, forKey: "address")
                UserDefaults.standard.set(User.userCity, forKey: "city")
                UserDefaults.standard.set(User.gender, forKey: "gender")
                UserDefaults.standard.set(User.latitude, forKey: "lat")
                UserDefaults.standard.set(User.longtitude, forKey: "lng")
                UserDefaults.standard.set(User.email, forKey: "email")
                
                let appVersion = userDataDictionary!["app_version"]as? String
               
              //  print(appVersion!)
                
                //Change value 1 if you want to update new app
                if (appVersion != nil)
                {
                
                if Int(appVersion!) != 1
                {
                    self.showAlertWithAction(message: "Please Update your application")
                  
                }
                }
                
                
            }
        }
    }
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToAppStore), Controller: self)], Controller: self)
    }
    @objc func goToAppStore()  {
        
        if let url = URL(string: "itms-apps://itunes.apple.com/us/app/dedaabox/id1272004421?mt=8"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }
        
       

    }
    
    func getAllCategories()
    {
        
        if userLoginType == UserType.MERCHANT
        {
            paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":UserType.MERCHANT,"merchant_id":userId!]
        }
            
        else
        {
            
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":UserType.BUYER]
        }
        self.view.StartLoading()

        ApiManager().postRequest(service: WebServices.GET_ALLHOME_CATAGORIES, params: paramsDic) { (result, success) in
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
                let data = response ["data"]as! [String:Any]
                self.arrBanners = (data["banners"] as? [AnyObject]) != nil  ?  (data["banners"] as! [AnyObject]) : []
                self.arrFeaturedBrands = (data["brands"] as? [AnyObject]) != nil  ?  (data["brands"] as! [AnyObject]) : []
                self.arrFeaturedProducts = (data["featured_products"] as? [AnyObject]) != nil  ?  (data["featured_products"] as! [AnyObject]) : []
                self.arrFeaturedDeals = (data["featured_deals"] as? [AnyObject]) != nil  ?  (data["featured_deals"] as! [AnyObject]) : []
                self.arrPopularPicks = (data["popular"] as? [AnyObject]) != nil  ?  (data["popular"] as! [AnyObject]) : []
                self.arrCategories = (data["category1"] as? [AnyObject]) != nil  ?  (data["category1"] as! [AnyObject]) : []
                self.arrCategories2 = (data["category2"] as? [AnyObject]) != nil  ?  (data["category2"] as! [AnyObject]) : []
                
                print("Banners \(self.arrBanners)")
                print("Featured Brands \(self.arrFeaturedBrands)")
                print("Featured Products \(self.arrFeaturedProducts)")
                print("Featured Deals \(self.arrFeaturedDeals)")
                print("arrPopularPicks \(self.arrPopularPicks)")
                print("arrCategories \(self.arrCategories)")
                print("arrCategories2 \(self.arrCategories2)")
                
                self.bannersHight.constant = (self.arrBanners.count > 0) ? 184 : 0
                self.featuredBrandsViewHight.constant = (self.arrFeaturedBrands.count > 0) ? 190 : 0
                self.feturedProductsHight.constant = (self.arrFeaturedProducts.count > 0) ? 190 : 0
                self.popularPicksViewHight.constant = (self.arrPopularPicks.count > 0) ? 190 : 0
                self.featuredDealsHight.constant = (self.arrFeaturedDeals.count > 0) ? 184 : 0
                
                self.lblCategoryHight.constant = (self.arrCategories.count > 0) ? 40 : 0
                self.categoryCollctionViewHight1.constant = (self.arrCategories.count > 0) ? 191 : 0
                self.catagorycollectionViewHight2.constant = (self.arrCategories2.count > 0) ? 191 : 0

                
                if (self.arrFeaturedDeals.count == 0)
                {
                    self.lblFaturedDealsHight.constant = 0
                
                }
                else
                {
                    self.lblFaturedDealsHight.constant = 40

                }
                if (self.arrBanners.count > 0)
                {
                    self.configurePageControl1()
                    
                }
                if (self.arrFeaturedDeals.count > 0)
                {
                    self.configurePageControl2()
                    
                }

                self.bannersCollectionView.reloadData()
                self.featurebrandsCollectionView.reloadData()
                self.featuredProductsCollectionView.reloadData()
                self.featureDealsCollectionView.reloadData()
                self.popularPicksCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
                self.categoryCollectionView2.reloadData()

            }
        }
        
    }
    func configurePageControl1()
    {
        self.pageControl1.hidesForSinglePage = true
        self.pageControl1.isHidden = false
        self.pageControl1.numberOfPages = self.arrBanners.count
        self.pageControl1.currentPage = 0
        self.pageControl1.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl1.currentPageIndicatorTintColor = Constants.NAVIGATION_COLOR
        self.pageControl1.isEnabled = false
    }
    func configurePageControl2()
    {
        self.pageControl2.hidesForSinglePage = true
        self.pageControl2.isHidden = false
        self.pageControl2.numberOfPages = self.arrFeaturedBrands.count
        self.pageControl2.currentPage = 0
        self.pageControl2.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl2.currentPageIndicatorTintColor = Constants.NAVIGATION_COLOR
        self.pageControl2.isEnabled = false
    }
    
    @IBAction func btnMenu_Tapped(_ sender: Any)
    {
        
        UIView.animate(withDuration: 0.4, animations:{
            self.sideMenuController?.leftViewWidth = 280
            self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
        })
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == bannersCollectionView
        {
            return arrBanners.count
        }
        else if collectionView == featurebrandsCollectionView
        {
            return arrFeaturedBrands.count
        }
        else if collectionView == featuredProductsCollectionView
        {
            return arrFeaturedProducts.count
        }
        else if collectionView == popularPicksCollectionView
        {
            return arrPopularPicks.count
        }
        else if collectionView == categoryCollectionView
        {
            return arrCategories.count
           
        }
        else if collectionView == categoryCollectionView2{
            return arrCategories2.count
        }
        else{
            return arrFeaturedDeals.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
       let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        
        
        if collectionView == bannersCollectionView
        {
          
            let image =  "\(WebServices.BASE_URL)\(self.arrBanners[indexPath.row]["image"] as! String)"
            cell.imgBanner.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            return cell
            
        }
        if collectionView == featurebrandsCollectionView
        {


            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true

            let image =  "\(WebServices.BASE_URL)\(self.arrFeaturedBrands[indexPath.row]["image"] as! String)"
            cell.imgFeaturedBrands.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))

            return cell
        }

        if collectionView == featuredProductsCollectionView
        {

            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true

            let image =  "\(WebServices.BASE_URL)\(self.arrFeaturedProducts[indexPath.row]["photo_android1"] as! String)"
            cell.imgFeaturedProducts.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))

            return cell
        }
        if collectionView == popularPicksCollectionView
        {

            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true

            let image =  "\(WebServices.BASE_URL)\(self.arrPopularPicks[indexPath.row]["photo_android1"] as! String)"
            cell.imgPopularPicks.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            return cell

        }
         if collectionView == featureDealsCollectionView
        {

            let image =  "\(WebServices.BASE_URL)\(self.arrFeaturedDeals[indexPath.row]["image"] as! String)"
            cell.imgFeaturedDeals.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            return cell

        }

        if collectionView == categoryCollectionView
        {


            cell.lblCategory1OverLay.layer.cornerRadius = 10
            cell.lblCategory1OverLay.layer.masksToBounds = true

            let image =  "\(WebServices.BASE_URL)\(self.arrCategories[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                  cell.ImgCategory1.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))

                    cell.lblCategory1.text = self.arrCategories[indexPath.row]["name"] as? String
                }

            return cell
        }
      if collectionView == categoryCollectionView2
        {
         
            cell.lblCategory2OverLay.layer.cornerRadius = 10
            cell.lblCategory2OverLay.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrCategories2[indexPath.row]["image"] as! String)"
            DispatchQueue.main.async
                {
                    cell.imgCategory2.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
                    
                    cell.lblCategory2.text = self.arrCategories2[indexPath.row]["name"] as? String
                }
            
            return cell
        }
      else{
        return cell
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        if collectionView == featuredProductsCollectionView
        {
            
            

            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductDetailsViewController" )as! ProductDetailsViewController

            products.strProductId = self.arrFeaturedProducts[indexPath.row]["product_id"] as! String
            self.navigationController?.pushViewController(products, animated: true)

        }
        if collectionView == popularPicksCollectionView
        {
            let products = self.storyboard?.instantiateViewController(withIdentifier:"ProductDetailsViewController" )as! ProductDetailsViewController
            
            products.strProductId = self.arrPopularPicks[indexPath.row]["product_id"] as! String
            self.navigationController?.pushViewController(products, animated: true)
        }
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
            print( self.arrCategorieids + self.arrCategorieids2)
              print( self.arrCategorieNames + self.arrCategorieNames2)
            
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
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView == bannersCollectionView
        {
            self.pageControl1.currentPage = indexPath.row
        }
        else if collectionView == featureDealsCollectionView
        {
            self.pageControl2.currentPage = indexPath.row
        }
    
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        if collectionView == bannersCollectionView {
//            return CGSize(width: bannersCollectionView.frame.width, height: bannersCollectionView.frame.height)
//
//        }
//       else if collectionView == featurebrandsCollectionView
//        {
//            return CGSize(width: featurebrandsCollectionView.frame.width, height: featurebrandsCollectionView.frame.height)
//        }
//
//    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}

