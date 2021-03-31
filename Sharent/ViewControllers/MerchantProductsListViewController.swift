//
//  MerchantProductsListViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit

class MerchantProductsListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,FloatRatingViewDelegate {

    @IBOutlet weak var myInventoryProductsCollectionView: UICollectionView!
    
    var arrProducts = [AnyObject]()
    var totalProducts = Int()
    var limit:Int = 0
      var userId :String? = ""
    var refreshControlView = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MY LISTINGS"
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        getAllCategories(limit: limit)
        refreshControlView.tintColor = UIColor.darkGray
        refreshControlView.addTarget(self, action: #selector(loadMore), for: .valueChanged)
        myInventoryProductsCollectionView.bottomRefreshControl = refreshControlView
        
    }
    
    func getAllCategories(limit:Int)
    {
        let Dict = ["api_key_data":WebServices.API_KEY,"merchant_id":userId!,"limit":limit,"search": ""] as [String : Any]
        
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.GET_ALL_PRODUCTS_MERCHANT, params: Dict) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
//                self.showAlert(message: "No Products found.")
//                return
            }
            else
            {
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                let products = data["Products"] as! [AnyObject]
                self.arrProducts.append(contentsOf: products)
                self.totalProducts = self.arrProducts.count
                print("No of products\(self.totalProducts)")
                if self.arrProducts.count > 0
                {
                    self.myInventoryProductsCollectionView.isHidden = false
                    self.myInventoryProductsCollectionView.reloadData()
                }
            }
        }
    }
    @objc func loadMore()
    {
        limit = self.totalProducts
        self.getAllCategories(limit: limit)
        self.refreshControlView.endRefreshing()
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
        
        cell.mainBackgroundView.layer.borderWidth = 0.4
        cell.mainBackgroundView.layer.cornerRadius = 8
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
        let merchantvc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        merchantvc.strProductId = self.arrProducts[indexPath.row]["product_id"] as! String
        self.navigationController?.pushViewController(merchantvc, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width/2-12, height: 276)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8.0
    }
    
    
    @IBAction func backToHome(_ sender: Any) {
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
        self.navigationController?.pushViewController(navigateToHome!, animated: false)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
