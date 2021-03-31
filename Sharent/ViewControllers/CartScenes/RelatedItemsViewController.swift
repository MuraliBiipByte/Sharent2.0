//
//  RelatedItemsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import LGSideMenuController

class RelatedItemsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, FloatRatingViewDelegate {
 
    var userId = String()
  
    var category_id = String()
    
    var arrRelatedItems = [AnyObject]()
    @IBOutlet weak var relatedItemsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "RELATED SERVICES & ITEMS"
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        getRelatedProducts()
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
    }
    func getRelatedProducts() {
        
        let paramsDict = ["api_key_data":WebServices.API_KEY,"user_id":userId,"cat_id":category_id] as [String : Any]
        
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.RELATED_PRODUCTS, params: paramsDict) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                 self.relatedItemsCollection.isHidden = true
                
                let cartVc = self.storyboard?.instantiateViewController(withIdentifier: "CartListViewController")as! CartListViewController
                
                self.navigationController?.pushViewController(cartVc, animated: true)
               
            }
            else
            {
         
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
           
                let products = data["related_products"] as! [AnyObject]
                self.arrRelatedItems.append(contentsOf: products)
               
              
                if self.arrRelatedItems.count > 0
                {
                    self.relatedItemsCollection.isHidden = false
                    self.relatedItemsCollection.reloadData()

                }else{
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.navigationController?.pushViewController(navigateToHome!, animated: false)
                }
            }
        }
    }
    
//    63. get related_products:
//    (link:products/related_products)
//
//    params:  api_key_data,cat_id,user_id
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrRelatedItems.count
    }
    
    
    @IBAction func btn_backToHome(_ sender: Any) {

        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
        self.present(mainViewController, animated: true, completion: nil)

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        let image =  "\(WebServices.BASE_URL)\(self.arrRelatedItems[indexPath.row]["photo_android1"] as! String)"
        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        
        
         cell.lblProductName.text = self.arrRelatedItems[indexPath.row]["product_name"] as? String
        cell.lblProductRate.text = String(format: "$%@ Per Day", self.arrRelatedItems[indexPath.row]["price"] as! String)
        
        cell.ratingView.editable = false
        cell.ratingView.rating = Double(self.arrRelatedItems[indexPath.row]["average_rating"] as! Int)
        cell.ratingView.type = .wholeRatings
        cell.ratingView.delegate = self
        cell.ratingView.backgroundColor = UIColor.clear
        
//        cell.lblRating.text = String(format: "%d ratings", self.arrRelatedItems[indexPath.row]["total_ratings"] as! Int)
        
        cell.mainBackgroundView.layer.borderWidth = 0.4
        cell.mainBackgroundView.layer.cornerRadius = 8
        cell.mainBackgroundView.layer.borderColor = UIColor.gray.cgColor
        cell.mainBackgroundView.layer.masksToBounds = true
        
       
       
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let productdetailVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")as! ProductDetailsViewController
        productdetailVc.strProductId = (self.arrRelatedItems[indexPath.row]["product_id"] as? String)!
        self.navigationController?.pushViewController(productdetailVc, animated: true)
        
    }
    @IBAction func btn_ContinueToCheckout_Tapped(_ sender: Any) {
        
        let cartVc = self.storyboard?.instantiateViewController(withIdentifier: "CartListViewController")as! CartListViewController
        
        self.navigationController?.pushViewController(cartVc, animated: true)
    }
    
    
  
    @IBAction func btn_back_tapped(_ sender: Any) {
        
               let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
                self.present(mainViewController, animated: true, completion: nil)

    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
