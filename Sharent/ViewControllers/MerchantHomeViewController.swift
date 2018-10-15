//
//  MerchantHomeViewController.swift
//  ProductDetailsSharent
//
//  Created by Biipbyte on 07/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MerchantHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FloatRatingViewDelegate
{
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var collectionviewMyInventoryProducts:UICollectionView!
    @IBOutlet weak var imgProfileMerchant:UIImageView!
    @IBOutlet weak var btnAddProduct:UIButton!
    @IBOutlet weak var merchantView:UIView!
    
    @IBOutlet weak var lblMerchantName:UILabel!
    @IBOutlet weak var lblMerchantCompany:UILabel!
    var arrProducts = [AnyObject]()
    
    var arrCategorieids = [AnyObject]()
    var arrCategorieNames = [AnyObject]()
    
    var userId = String()
    var userName = String()
    var usercompany = String()
    var userImage :String? = ""
    
    @IBOutlet weak var collectionviewMyInventoryProductsHeight:NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.title = "Home"
        
        scrollView.isHidden = true
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        userName = UserDefaults.standard.value(forKey: "userName") as! String
        usercompany = UserDefaults.standard.value(forKey: "company")as! String
        userImage = UserDefaults.standard.value(forKey: "userImage")as? String
        
        
        getAllCategories()
        
        
        lblMerchantName.text = userName
        lblMerchantCompany.text = usercompany
        
        merchantView.layer.shadowColor = UIColor.black.cgColor
        merchantView.layer.shadowOpacity = 0.5
        merchantView.layer.shadowOffset = CGSize.zero
        merchantView.layer.shadowRadius = 3
        
        let image =  String("\(WebServices.BASE_URL)\(userImage ?? "")")
        imgProfileMerchant?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
        imgProfileMerchant.layer.cornerRadius = imgProfileMerchant.frame.size.height/2
        imgProfileMerchant.layer.masksToBounds = true
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionviewMyInventoryProducts!.collectionViewLayout = layout
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.ratingView.editable = false
        cell.ratingView.rating = Double(self.arrProducts[indexPath.row]["average_rating"] as! String)!
        cell.ratingView.type = .wholeRatings
        cell.ratingView.delegate = self
        cell.ratingView.backgroundColor = UIColor.clear
        
        
        cell.lblRating.text = String(format: "%d ratings", self.arrProducts[indexPath.row]["total_ratings"] as! Int)
        
        
        cell.mainBackgroundView.layer.borderWidth = 0.3
        cell.mainBackgroundView.layer.cornerRadius = 5
        cell.mainBackgroundView.layer.borderColor = UIColor.gray.cgColor
        cell.mainBackgroundView.layer.masksToBounds = true
        
        let image =  "\(WebServices.BASE_URL)\(self.arrProducts[indexPath.row]["photo_android1"] as! String)"
        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        cell.lblProductName.text = self.arrProducts[indexPath.row]["product_name"] as? String
        cell.lblProductRate.text = String(format: "$%@ Per Day", self.arrProducts[indexPath.row]["price"] as! String)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let merchantvc = self.storyboard?.instantiateViewController(withIdentifier: "MerchantProductDetailsViewController") as! MerchantProductDetailsViewController
        merchantvc.strProductId = self.arrProducts[indexPath.row]["product_id"] as! String
        self.navigationController?.pushViewController(merchantvc, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: self.view.frame.size.width/2-16, height: 261)
    }
    
    @IBAction func btnAddClicked(_ sender: Any)
    {
        let createProductVc = storyboard?.instantiateViewController(withIdentifier: "CreateProductImagesViewController")
        self.navigationController?.pushViewController(createProductVc!, animated: true)
    }
    
    func getAllCategories()
    {
        
        let Dict = ["api_key_data":WebServices.API_KEY,"user_type":UserType.MERCHANT,"merchant_id":userId]
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.GET_ALLHOME_CATAGORIES, params: Dict) { (result, success) in
            self.view.StopLoading()
            
            
            if success == false
            {
                self.scrollView.isHidden = true
                self.collectionviewMyInventoryProductsHeight.constant = 0.0
                self.collectionviewMyInventoryProductsHeight.isActive = true
            }
            else
            {
                self.scrollView.isHidden = false
                
                let response = result as! [String : Any]
                let data = response ["data"]as! [String:Any]
                self.arrProducts = data["Products"] as! [AnyObject]
                
                if self.arrProducts.count > 0
                {
                    self.collectionviewMyInventoryProducts.reloadData()
                    self.collectionviewMyInventoryProductsHeight.constant = self.collectionviewMyInventoryProducts.collectionViewLayout.collectionViewContentSize.height
                }
            }
        }
        
    }
    
    
    @IBAction func btnMenu_Tapped(_ sender: Any)
    {
        
        UIView.animate(withDuration: 0.4, animations:
            {
                self.sideMenuController?.leftViewWidth = 280
                self.sideMenuController?.showLeftView(animated:true, completionHandler :nil)
        })
    }
    
}
