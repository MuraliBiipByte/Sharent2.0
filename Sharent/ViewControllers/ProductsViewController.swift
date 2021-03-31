//
//  ProductsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FloatRatingViewDelegate, UISearchBarDelegate
{
    
    var imageView:UIImageView!
    var label:UILabel!
    var label1:UILabel!
    var limit:Int = 0
    var refreshControlView = UIRefreshControl()
    
    var catagoryId = String()
    var catagoryName = String()

    var tagId = String()
    var arrproductsData = [AnyObject]()
    
    var arrCatagoryids = [AnyObject]()
    var arrCatagoryNames = [AnyObject]()
    var loadmore = String()
    var merchantID : String = ""
    var userLoginType : String? = ""
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var isSearch  : Bool = false
    var textSearch = String()
    var userId :String? = ""
    
      lazy var searchBar:UISearchBar = UISearchBar()
    
    @IBOutlet weak var searchView: UIView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.backgroundColor = UIColor.white
        
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
    
        
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        searchBar.backgroundColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        searchBar.heightAnchor.constraint(equalToConstant: 50)
        
        searchBar.widthAnchor.constraint(equalToConstant: (self.searchView.frame.size.width)).isActive = true

       
        
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.imageView.center = self.view.center
        self.imageView.image = UIImage(named: "IconNoProducts")
        self.imageView.contentMode = .scaleAspectFit
        self.label = UILabel(frame: CGRect(x: 0, y: self.imageView.frame.origin.y+self.imageView.frame.height, width: self.view.frame.width, height: 21))
        self.label.textAlignment = NSTextAlignment.center
        self.label.textColor = UIColor.lightGray
        self.label.font = NAVIGATION_FONT
        self.label.text = "Coming Soon!"
        self.label1 = UILabel(frame: CGRect(x: 8, y: self.imageView.frame.origin.y+self.imageView.frame.height+self.label.frame.height, width: self.view.frame.width-8, height: 50))
        self.label1.textAlignment = NSTextAlignment.center
        self.label1.textColor = UIColor.lightGray
        self.label1.font = APP_FONT
        self.label1.numberOfLines = 0
        self.label1.text = "Help others find out what they need by being a Rentlord and listing items up for rental!"
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.label)
        self.view.addSubview(self.label1)
        self.imageView.isHidden = true
        self.label.isHidden = true
        self.label1.isHidden = true
        self.searchView.isHidden = true
        productsCollectionView.isHidden = true
        
        
        if userLoginType == BUYER {
            self.title = catagoryName.uppercased()
            searchBar.placeholder = "Search \(catagoryName)"
            if merchantID != "" {
                getAllCategories(limit: limit, loadmore: loadmore)
                
            }else{
                getAllProductsByCatagories(catagoryId: catagoryId, tagid : tagId,limit:limit, searchData: textSearch, loadmore: loadmore)
            }
        }else{
            self.title = "MY LISTINGS"
            searchBar.placeholder = "Search Inventory"
            
            merchantID = (UserDefaults.standard.value(forKey: "user_id") as? String)!
            getAllCategories(limit: limit, loadmore: loadmore)
        }
        
         self.searchView.addSubview(searchBar)
      
    }
    
    func getAllCategories(limit:Int,loadmore:String)
    {
        
        let Dict = ["api_key_data":WebServices.API_KEY,"merchant_id":merchantID,"limit":limit,"search":textSearch ,"load_more": loadmore] as [String : Any]
        
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.GET_ALL_PRODUCTS_MERCHANT, params: Dict) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.imageView.isHidden = false
                self.label.isHidden = false
                self.label1.isHidden = false
                self.productsCollectionView.isHidden = true
                self.searchView.isHidden = true
                self.productsCollectionView.isHidden = true
                return
            }
            else
            {
                self.imageView.isHidden = true
                self.label.isHidden = true
                self.label1.isHidden = true
               
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let products = dataDictionary?["Products"] as! [AnyObject]
                if products.count != 0 {
                    self.arrproductsData.append(contentsOf: products)
                    
                    self.productsCollectionView.isHidden = false
                    self.productsCollectionView.reloadData()
                    self.searchView.isHidden = false
                    self.productsCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
                }else{
                    
                    self.refreshControlView.endRefreshing()
                }
            }
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        isSearch = false;
        self.searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        isSearch = true;
        textSearch = searchBar.text!
        self.arrproductsData.removeAll()
        if userLoginType == BUYER {
            
            if merchantID != "" {
                getAllCategories(limit: limit, loadmore: loadmore)
                
            }else{
                getAllProductsByCatagories(catagoryId: catagoryId, tagid : tagId,limit:limit, searchData: textSearch, loadmore: loadmore)
            }
        }else{
            merchantID = (UserDefaults.standard.value(forKey: "user_id") as? String)!
            getAllCategories(limit: limit, loadmore: loadmore)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        refreshControlView.tintColor = UIColor.darkGray
        refreshControlView.addTarget(self, action: #selector(loadMore), for: .valueChanged)
        productsCollectionView.bottomRefreshControl = refreshControlView
    }
    
    func getAllProductsByCatagories(catagoryId:String, tagid : String, limit:Int,searchData: String,loadmore : String)
    {
        let paramsDict = ["api_key_data":WebServices.API_KEY,"category_id":catagoryId, "tag_id":tagid, "search":searchData, "limit": limit,"load_more": loadmore] as [String : Any]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_SEARCH_BY_TAGS, params: paramsDict)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.imageView.isHidden = false
                self.label.isHidden = false
                self.label1.isHidden = false
                self.productsCollectionView.isHidden = true
                self.searchView.isHidden = true
                 self.productsCollectionView.isHidden = true
                 return
            }
            else
            {
                self.imageView.isHidden = true
                self.label.isHidden = true
                self.label1.isHidden = true
                
              
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let products = dataDictionary?["Products"] as! [AnyObject]
                if products.count != 0 {
                    self.arrproductsData.append(contentsOf: products)
                    
                    self.productsCollectionView.isHidden = false
                    self.productsCollectionView.reloadData()
                    self.searchView.isHidden = false
                self.productsCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
                }else{
                   
                    self.refreshControlView.endRefreshing()
                }
               
            }
        }
  
    }
    
    @objc func loadMore()
    {
        limit = self.arrproductsData.count
        loadmore = "1"
        
        if userLoginType == BUYER {
            
            if merchantID != "" {
                getAllCategories(limit: limit, loadmore: loadmore)
                
            }else{
                getAllProductsByCatagories(catagoryId: catagoryId, tagid : tagId,limit:limit, searchData: textSearch, loadmore: loadmore)
            }
        }else{
            merchantID = (UserDefaults.standard.value(forKey: "user_id") as? String)!
            getAllCategories(limit: limit, loadmore: loadmore)
        }
//        getAllProductsByCatagories(catagoryId: catagoryId, tagid : tagId,limit:limit, searchData: textSearch, loadmore: loadmore)
        self.refreshControlView.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return arrproductsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell

            let rating = String(describing:self.arrproductsData[indexPath.row]["average_rating"]as AnyObject)
            
            cell.ratingView.rating = Double(rating)!
            cell.ratingView.type = .wholeRatings
            cell.ratingView.delegate = self
            cell.ratingView.backgroundColor = UIColor.clear
            
            let ratings = String(describing:self.arrproductsData[indexPath.row]["total_ratings"]as AnyObject)
            
            cell.lblRating.text = "\(ratings) ratings"
   
        
            let image =  "\(WebServices.BASE_URL)\(self.arrproductsData[indexPath.row]["photo_android1"] as! String)"
            cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            cell.lblProductName.text = self.arrproductsData[indexPath.row]["product_name"] as? String
            cell.lblProductRate.text = String(format: "$%@ Per Day", self.arrproductsData[indexPath.row]["price"] as! String)
   
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

            let productdetailVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")as! ProductDetailsViewController
            
            productdetailVc.strProductId = (self.arrproductsData[indexPath.row]["product_id"] as? String)!
            self.navigationController?.pushViewController(productdetailVc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

            return CGSize(width: productsCollectionView.frame.size.width/2-4, height: 276)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    @IBAction func btn_backTapped(_ sender: Any)
    {
        self.arrCatagoryids.removeAll()
        self.arrCatagoryNames.removeAll()
        
        if userLoginType == BUYER{
        self.navigationController?.popViewController(animated: true)
        }
        else{
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
//            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ViewController: FloatRatingViewDelegate
{
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
    
}
