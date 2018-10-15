//
//  ProductsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FloatRatingViewDelegate
{
   
    var imageView:UIImageView!
    var label:UILabel!
    
    var catagoryId = String()
    var catagoryName = String()
    var buttonTag = Int()
    
    var arrproductsData = [AnyObject]()
    var arrCatagoriesData = [AnyObject]()
    
    var arrCatagoryids = [AnyObject]()
    var arrCatagoryNames = [AnyObject]()
    
    @IBOutlet weak var btn_category: UIButton!
    @IBOutlet weak var lblCatagoryName: UILabel!
    @IBOutlet weak var imgCatagoryarrow: UIImageView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        categoryCollection.isHidden = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        productsCollectionView.collectionViewLayout = layout
        
        lblCatagoryName.text = "  \(catagoryName)"
        print( self.arrCatagoryids)
        print( self.arrCatagoryNames )
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.imageView.center = self.view.center
        self.imageView.image = UIImage(named: "IconNoProducts")
        self.imageView.contentMode = .scaleAspectFit
        self.label = UILabel(frame: CGRect(x: 0, y: self.imageView.frame.origin.y+self.imageView.frame.height, width: self.view.frame.width, height: 21))
        self.label.textAlignment = NSTextAlignment.center
        self.label.textColor = UIColor.lightGray
        self.label.font = Constants.APP_FONT
        self.label.text = "No Products found"
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.label)
        self.imageView.isHidden = true
        self.label.isHidden = true
        
        getAllProductsByCatagories(catagoryId: catagoryId)

    }
    
    @IBAction func btn_category_Tapped(_ sender: UIButton)
    {
        self.imageView.isHidden = true
        self.label.isHidden = true
        
        if buttonTag == 0
        {
            imgCatagoryarrow.image = UIImage(named: "uparrow")
            categoryCollection.isHidden = false
            productsCollectionView.isHidden = true
            self.view.bringSubview(toFront: categoryCollection)
            buttonTag = 1
        }
        else
        {
            imgCatagoryarrow.image = UIImage(named: "downarrow")
            categoryCollection.isHidden = true
            getAllProductsByCatagories(catagoryId: catagoryId)
            buttonTag = 0
        }
        
    }
    
    func getAllProductsByCatagories(catagoryId:String)
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"category":catagoryId]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_ALL_PRODUCTS_BYCATAGORY, params: paramsDic)
        { (result, success) in
            self.view.StopLoading()

            if success == false
            {
                self.imageView.isHidden = false
                self.label.isHidden = false
                return
                
            }
            else
            {
                self.imageView.isHidden = true
                self.label.isHidden = true
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.arrproductsData = dataDictionary?["Products"] as! [AnyObject]
                self.productsCollectionView.isHidden = false
                self.productsCollectionView.reloadData()
            }
        }
        
        
    }
    @IBAction func btn_Search_Tapped(_ sender: Any)
    {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollection
        {
            return arrCatagoryNames.count

        }
        else
        {
          return arrproductsData.count
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
          if collectionView == categoryCollection
          {
            
            cell.lblCategoryName.text = "  \(self.arrCatagoryNames[indexPath.row] as! String)"
            
          }
         else
          {
         
            let rating = String(describing:self.arrproductsData[indexPath.row]["average_rating"]as AnyObject)
            
            print(rating)
            cell.ratingView.rating = Double(rating)!
            cell.ratingView.type = .wholeRatings
            cell.ratingView.delegate = self
             cell.ratingView.backgroundColor = UIColor.clear

            let ratings = String(describing:self.arrproductsData[indexPath.row]["total_ratings"]as AnyObject)

            cell.lblRating.text = "\(ratings) ratings"
            cell.mainBackgroundView.layer.borderWidth = 0.1
            cell.mainBackgroundView.layer.cornerRadius = 6
            cell.mainBackgroundView.layer.borderColor = UIColor.gray.cgColor
            cell.mainBackgroundView.layer.masksToBounds = true
            
            let image =  "\(WebServices.BASE_URL)\(self.arrproductsData[indexPath.row]["photo_android1"] as! String)"
            cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            cell.lblProductName.text = self.arrproductsData[indexPath.row]["product_name"] as? String
            cell.lblProductRate.text = String(format: "$%@ Per Day", self.arrproductsData[indexPath.row]["price"] as! String)
            
          }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == categoryCollection
        {
            
            catagoryId = self.arrCatagoryids[indexPath.row] as! String
            let catagoryName = self.arrCatagoryNames[indexPath.row] as! String
            lblCatagoryName.text = " \(catagoryName)"
            categoryCollection.isHidden = true
            self.imgCatagoryarrow.image = #imageLiteral(resourceName: "downArrow")

            buttonTag = 0
            self.getAllProductsByCatagories(catagoryId: catagoryId)

        }
        else
        {
            let productdetailVc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")as! ProductDetailsViewController
            
            productdetailVc.strProductId = (self.arrproductsData[indexPath.row]["product_id"] as? String)!
            
            self.navigationController?.pushViewController(productdetailVc, animated: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == categoryCollection
        {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/8)
        }
        else
        {
        
        return CGSize(width: productsCollectionView.frame.size.width/2-8, height: 261)
            
        }
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    @IBAction func btn_backTapped(_ sender: Any) {
        
         self.arrCatagoryids.removeAll()
         self.arrCatagoryNames.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ViewController: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
    
}
