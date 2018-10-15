//
//  MyFavouriteViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MyFavouriteViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, FloatRatingViewDelegate
{
  
    

    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    var strUserId = String()
    var arrproductsData = [AnyObject]()


    override func viewDidLoad()
    {
        super.viewDidLoad()

        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        favouritesCollectionView.collectionViewLayout = layout
        favouritesCollectionView.isHidden = true
        getFavProducts()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    func getFavProducts()
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":strUserId]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.FAV_PRODUCTS, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.favouritesCollectionView.isHidden = true
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                imageView.center = self.view.center
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "IconNoFavourites")
                let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.origin.y+imageView.frame.height, width: self.view.frame.width, height: 21))
                label.textAlignment = NSTextAlignment.center
                label.font = Constants.APP_FONT
                label.text = "No Favourite Products found"
                self.view.addSubview(imageView)
                self.view.addSubview(label)
                return

            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.arrproductsData = dataDictionary?["Products"] as! [AnyObject]
                self.favouritesCollectionView.isHidden = false
                self.favouritesCollectionView.reloadData()
            }
        }
        
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        
        
    }
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(backtoMyProfile), Controller: self)], Controller: self)
    }
    @objc func backtoMyProfile()
    {
         self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrproductsData.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.FavratingView.editable = false
        
        let rating = String(describing:self.arrproductsData[indexPath.row]["average_rating"]as AnyObject)
        cell.FavratingView.rating = Double(rating)!
      
        
        cell.FavratingView.type = .wholeRatings
        cell.FavratingView.delegate = self
        cell.FavratingView.backgroundColor = UIColor.clear
        
        let ratings = String(describing:self.arrproductsData[indexPath.row]["total_ratings"]as AnyObject)
        cell.lblFavRating.text = "\(ratings) ratings"
        let image =  "\(WebServices.BASE_URL)\(self.arrproductsData[indexPath.row]["photo_android1"] as! String)"
        cell.imgFavProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        cell.lblFavProductName.text = self.arrproductsData[indexPath.row]["product_name"] as? String
        cell.lblFavProductRate.text = String(format: "$%@ Per Day", self.arrproductsData[indexPath.row]["price"] as! String)
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
        
       return CGSize(width: favouritesCollectionView.frame.size.width/2-8, height: 261)
        
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
  
    
}

