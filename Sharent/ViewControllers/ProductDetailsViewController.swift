//
//  ProductDetailsViewController.swift
//  ProductDetailsSharent
//
//  Created by Biipbyte on 07/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker

class ProductDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FloatRatingViewDelegate,UIScrollViewDelegate
{

    var strProductId = String()
    var strUserId = String()
    var favourite = Bool()
    
    var intAttributesCount = Int()
    var strAttribute1 = String()
    var strAttribute2 = String()
    
    
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
    
    var ProductDetails = [String:Any]()

    var arrRelatedProducts = [AnyObject]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSeeReviews: UIButton!
    @IBOutlet weak var imgMarchant: UIImageView!
    @IBOutlet weak var lblMarchantName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDaysRent: UILabel!
   
    @IBOutlet weak var lblProductCare: UILabel!
    @IBOutlet weak var lblProductOtherDescription: UILabel!
   
    @IBOutlet weak var btnAddtoCart: UIButton!
    @IBOutlet weak var collectionViewRelatedProducts:UICollectionView!
    
    @IBOutlet weak var btnAttribute1: UIButton!
    @IBOutlet weak var btnAttribute2: UIButton!
    
    @IBOutlet weak var imgAttribute1: UIImageView!
    @IBOutlet weak var imgAttribute2: UIImageView!
    @IBOutlet weak var btnAttribute1Hight: NSLayoutConstraint!
    @IBOutlet weak var btnAttribute2Hight: NSLayoutConstraint!
    
    @IBOutlet weak var relatedProductsView: UIView!
    @IBOutlet weak var relatedProductsViewHight: NSLayoutConstraint!
    
    
    var arrProductImages = [String]()
    @IBOutlet weak var collectionViewProductImages:UICollectionView!
    
    @IBOutlet weak var pageControl:UIPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        scrollView.isHidden = true
        btnAttribute1.isHidden = true
        btnAttribute2.isHidden = true
        imgAttribute1.isHidden = true
        imgAttribute2.isHidden = true
        btnAttribute1Hight.constant = 0
        btnAttribute1Hight.isActive = true
        btnAttribute2Hight.constant = 0
        btnAttribute2Hight.isActive = true
        
        
        relatedProductsViewHight.constant = 0
        relatedProductsViewHight.isActive = true
        relatedProductsView.isHidden = true
        
        
        //=====Corner Radious=========
        
        imgMarchant.layer.cornerRadius = imgMarchant.frame.width/2
        imgMarchant.layer.masksToBounds = true
        
        collectionViewProductImages.delegate = self
        collectionViewProductImages.dataSource = self
        
        let id =  UserDefaults.standard.value(forKey: "user_id")
        if id != nil
        {
            strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        }
        else
        {
            strUserId = ""
        }
         print("Product is is \(strProductId)")
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
                return
            }
            else
            {
                self.scrollView.isHidden = false

                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.ProductDetails = (dataDictionary!["products"]as? [String:Any])!
    
                _ = ProductInformation.init(productDetailsDictionay: self.ProductDetails)
                print(self.ProductDetails)
                print(ProductInformation.productName!)
                print(ProductInformation.productFeePercentage!)

                
                self.arrRelatedProducts = dataDictionary!["related_products"] as! [AnyObject]
                
                if self.arrRelatedProducts.count>0
                {
                    self.relatedProductsViewHight.constant = 312
                    self.relatedProductsView.isHidden = false
                    self.collectionViewRelatedProducts.reloadData()
                }
                else
                {
                    self.relatedProductsViewHight.constant = 0
                    self.relatedProductsView.isHidden = true
                }
                
                let marchantImage = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["company_image"]!))")
                self.imgMarchant.sd_setImage(with: URL(string: marchantImage), placeholderImage: #imageLiteral(resourceName: "userplaceholder"))
                self.lblMarchantName.text = self.self.ProductDetails["company"]as? String
                let ProductImage1 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android1"]!))")
                let ProductImage2 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android2"]!))")
                let ProductImage3 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android3"]!))")
                let ProductImage4 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android4"]!))")
                let ProductImage5 = String("\(WebServices.BASE_URL)\(String(describing: self.ProductDetails["photo_android5"]!))")
              
                self.title = self.ProductDetails["category_name"]as? String
             
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
                    self.collectionViewProductImages.reloadData()
                    self.configurePageControl()
                }
                self.lblProductName.text = self.ProductDetails["product_name"]as? String
                self.lblDescription.text = self.ProductDetails["product_details"]as? String
                self.lblProductOtherDescription.text = self.ProductDetails["description"]as? String
                self.lblProductCare.text = self.ProductDetails["product_care"]as? String
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
                guard let attributes = self.ProductDetails["attribute"] as? [String:AnyObject] else
                {
                    return
                }
                 let attributesData = self.ProductDetails["available_attribute"]as? [String:AnyObject]
                let keys = Array(attributes.keys)
                print(keys)
                self.intAttributesCount = keys.count
                switch self.intAttributesCount
                {
                case 1:
                    
                    self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
                    self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
                    self.attributesloop(mainAttributeArray: self.arrAttribute1, arrattributeId: self.arrAttribute1Id, arrAttributeName: self.arrAttribute1Name)
                    self.btnAttribute1.isHidden = false
                    self.imgAttribute1.isHidden = false
                    self.btnAttribute1Hight.constant = 40
                    
                   
                    ProductInformation.attribute1Id = self.arrAttribute1Id[0] as? String
                    ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String
                    self.btnAttribute1.setTitle("  Select \(self.strAttribute1)", for: UIControlState.normal)
                    break
                
                case 2:
                    self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
                    self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
                    self.attributesloop(mainAttributeArray: self.arrAttribute1, arrattributeId: self.arrAttribute1Id, arrAttributeName: self.arrAttribute1Name)
                    ProductInformation.attribute1Id = self.arrAttribute1Id[0] as? String
                    ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String
                    self.btnAttribute1.setTitle("  Select \(self.strAttribute1)", for: UIControlState.normal)
                    self.strAttribute2 = ProductInformation.attribute!["attribute_2"] as! String
                    self.arrAttribute2 = (attributesData!["available_attribute_2"] as? [AnyObject])!

                    self.attributesloop(mainAttributeArray: self.arrAttribute2, arrattributeId: self.arrAttribute2Id, arrAttributeName: self.arrAttribute2Name)
                    
                    self.btnAttribute1.isHidden = false
                    self.btnAttribute2.isHidden = false
                    self.imgAttribute1.isHidden = false
                    self.imgAttribute2.isHidden = false
                    self.btnAttribute1Hight.constant = 40
                    self.btnAttribute2Hight.constant = 40
                    
                    
                    ProductInformation.attribute2Id = self.arrAttribute2Id[0] as? String
                    ProductInformation.attribute2Name = self.arrAttribute2Name[0] as? String
                    self.btnAttribute2.setTitle("  Select \(self.strAttribute2)", for: UIControlState.normal)
                    break
                default:
                    self.btnAttribute1.isHidden = true
                    self.btnAttribute2.isHidden = true
                    self.imgAttribute1.isHidden = true
                    self.imgAttribute2.isHidden = true
                    return
                }
            }
        }
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
            let alert = UIAlertController.init(title: Constants.APP_NAME, message: "Please Login to make this product as favourite", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
             
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController
                self.present(viewController, animated: true, completion: nil)
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
        
        if strUserId == ""{
            let alert = UIAlertController.init(title: Constants.APP_NAME, message: "Please Login to make this product as favourite", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController
                self.present(viewController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
            
        else{
        }
    }
    
    @IBAction func btn_Share_Tapped(_ sender: Any) {
        
        //Set the link to share.
        if let link = NSURL(string: "http://54.151.221.7/sharent_new/index.php/welcome/android/\(strProductId)")
        {
            let objectsToShare = [link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btn_AddToCart_Tapped(_ sender: Any)
    {
        
        if strUserId == ""
        {
            let alert = UIAlertController.init(title: Constants.APP_NAME, message: "Please Login to purchase this product", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController
                self.present(viewController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
         
        }
            
        else
        {
            switch intAttributesCount
            {
             case 1: if strAttribute1Name.isEmpty
             {
                self.showAlert(message: " Please choose \(strAttribute1)")
                break
             }
            case 2: if strAttribute1Name.isEmpty || strAttribute2Name.isEmpty
            {
                self.showAlert(message: " Please choose \(strAttribute1) and \(strAttribute2)")
                break
            }
             
            default:
               print("Need to do something")
            }
            
            let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "OrderViewController")as! OrderViewController
            orderVc.strProductId = strProductId
            self.navigationController?.pushViewController(orderVc, animated: true)
            
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
    

    
    @IBAction func btnAttribute1_Tapped(_ sender: Any)
    {
   
    
        ActionSheetStringPicker.show(withTitle: "Choose ", rows: arrAttribute1Name as! [Any], initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            
            self.strAttribute1Name = (String(describing: index!) )
            self.strAttribute1Id = (String(describing: self.arrAttribute1Id[value]) )
            self.btnAttribute1.setTitle("  \(self.strAttribute1Name)", for: UIControlState.normal)
           
            print(self.strAttribute1Name)
            print(self.strAttribute1Id)
            print(self.strAttribute1 )
            ProductInformation.attribute1Id = self.arrAttribute1Id[value] as? String
            ProductInformation.attribute1Name = self.arrAttribute1Name[value] as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
        
    }
    @IBAction func btnAttribute2_Tapped(_ sender: Any)
    {
        ActionSheetStringPicker.show(withTitle: "Choose ", rows: arrAttribute2Name as! [Any], initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            
            self.strAttribute2Name = (String(describing: index!) )
            self.strAttribute2Id = (String(describing: self.arrAttribute2Id[value]) )
            self.btnAttribute2.setTitle("  \(self.strAttribute2Name)", for: UIControlState.normal)

            ProductInformation.attribute2Id = self.arrAttribute2Id[value] as? String
            ProductInformation.attribute2Name = self.arrAttribute2Name[value] as? String
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
       if collectionView == collectionViewProductImages
       {
        return arrProductImages.count
       }
       else
       {
         return arrRelatedProducts.count
       }
  
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        if collectionView == collectionViewProductImages
        {
            let image =  "\(self.arrProductImages[indexPath.row] )"
            cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        }
        else
        {
            cell.viewRelatedRating.editable = false
            let rating = String(describing:self.arrRelatedProducts[indexPath.row]["average_rating"]as AnyObject)
            
            cell.viewRelatedRating.rating = Double(rating)!
            
            cell.viewRelatedRating.type = .wholeRatings
            cell.viewRelatedRating.delegate = self
            cell.viewRelatedRating.backgroundColor = UIColor.clear
            
            
            cell.mainBackgroundView.layer.borderWidth = 0.1
            cell.mainBackgroundView.layer.cornerRadius = 6
            cell.mainBackgroundView.layer.borderColor = UIColor.gray.cgColor
            cell.mainBackgroundView.layer.masksToBounds = true
            
            let ratings = String(describing:self.arrRelatedProducts[indexPath.row]["total_ratings"]as AnyObject)
            cell.lblRelatedProductRatings.text = "(\(ratings) ratings)"
            
            
            let image =  "\(WebServices.BASE_URL)\(self.arrRelatedProducts[indexPath.row]["photo_android1"] as! String)"
            cell.imgRelatedProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
            cell.lblRelatedProductName.text = self.arrRelatedProducts[indexPath.row]["product_name"] as? String
            
            cell.lblRelatedProductRate.text = String(format: "$%@ Per Day", self.arrRelatedProducts[indexPath.row]["price"] as! String)
        }
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionViewRelatedProducts
        {
            strProductId = self.arrRelatedProducts[indexPath.row]["product_id"] as! String
            viewWillAppear(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
extension UIViewController
{
    func attributesloop(mainAttributeArray:[AnyObject], arrattributeId:NSMutableArray,arrAttributeName:NSMutableArray)
    {
        if mainAttributeArray.count>0
        {
            for value  in mainAttributeArray
            {
                arrAttributeName.add(value["name"])
                arrattributeId.add(value["id"])
                
            }
        }
    }
}

