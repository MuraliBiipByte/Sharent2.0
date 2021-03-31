//
//  EditImagesViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit
import Alamofire

class EditImagesViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgProduct1: UIImageView!
    @IBOutlet weak var imgProduct2: UIImageView!
    @IBOutlet weak var imgProduct3: UIImageView!
    @IBOutlet weak var imgProduct4: UIImageView!
    @IBOutlet weak var imgProduct5: UIImageView!
    @IBOutlet weak var imgProductViewHeight: NSLayoutConstraint!
    
    var  imagesEditDataDic = [String:Any] ()
//    var  productEditDataDic = [String:Any] ()
    var image1,image2,image3,image4,image5:UIImage!
    var arr_changedImages = [UIImage]()
    var arrchangedbase64Images = [AnyObject]()
    var arr_changedfilePaths = [AnyObject]()
    var imagePlaceholder = UIImage()
    var product_id : String? = ""
    var merchantId = String()
    var ProductDetails = [String:Any]()
     var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "EDIT LISTING IMAGE"

        if product_id != "" {
            self.updateImages(productId: product_id!)
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        imgProductViewHeight.constant = screenWidth - 40
        

        merchantId = UserDefaults.standard.value(forKey: "user_id") as! String
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(checkWithImagesChecking))
        imgProduct1.addGestureRecognizer(tap1)
        imgProduct1.isUserInteractionEnabled = true
        imgProduct1.tag = 1
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(checkWithImagesChecking))
        imgProduct2.addGestureRecognizer(tap2)
        imgProduct2.isUserInteractionEnabled = true
        imgProduct2.tag = 2
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(checkWithImagesChecking))
        imgProduct3.addGestureRecognizer(tap3)
        imgProduct3.isUserInteractionEnabled = true
        imgProduct3.tag = 3
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(checkWithImagesChecking))
        imgProduct4.addGestureRecognizer(tap4)
        imgProduct4.isUserInteractionEnabled = true
        imgProduct4.tag = 4
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(checkWithImagesChecking))
        imgProduct5.addGestureRecognizer(tap5)
        imgProduct5.isUserInteractionEnabled = true
        imgProduct5.tag = 5
    }
    @IBAction func backBtn_Tapped(_ sender: Any) {
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "CreateProductImagesViewController")
        self.navigationController?.pushViewController(navigateToHome!, animated: false)
    }
    
    @objc func checkWithImagesChecking(sender:UITapGestureRecognizer)
    {
        let imageview:UIImageView = (sender.view as? UIImageView)!;
        
        imagePlaceholder = UIImage(named: "productPlaceholder")!
        
        if (imageview.image == imagePlaceholder)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            
            
            
            let otherAlert = UIAlertController(title:APP_NAME, message: "Are you sure you want Delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:
            {(alert: UIAlertAction!) in
                
                self.arr_changedImages.remove(at: imageview.tag - 1)
                self.arr_changedfilePaths.remove(at: imageview.tag - 1)
              
                self.checkWithImages()
            })
            otherAlert.addAction(okAction)
            otherAlert.addAction(deleteAction)
            present(otherAlert, animated: true, completion: nil)
            
        }
    }
    
    func checkWithImages()
    {
        
        arrchangedbase64Images.removeAll()
        for i in (0..<arr_changedImages.count)
        {
            let image = arr_changedImages[i]
            let imageData = UIImageJPEGRepresentation(image , 1.0)! as NSData
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            arrchangedbase64Images.insert(strBase64 as AnyObject, at: i)
        }
      print(arrchangedbase64Images.count)
        switch arr_changedImages.count
        {
        case 1:
            imgProduct1.image = arr_changedImages[0]
            imgProduct2.image = imagePlaceholder
            imgProduct3.image = imagePlaceholder
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            if product_id != "" {
                imagesEditDataDic["image1"] = arrchangedbase64Images[0]
            }else{
                imagesEditDataDic["files1"] = arrchangedbase64Images[0]
               
            }
             imagesEditDataDic["files1_name"] = arr_changedfilePaths[0]
        case 2:
            imgProduct1.image = arr_changedImages[0]
            imgProduct2.image = arr_changedImages[1]
            imgProduct3.image = imagePlaceholder
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            if product_id != "" {
                imagesEditDataDic["image1"] = arrchangedbase64Images[0]
                imagesEditDataDic["image2"] = arrchangedbase64Images[1]
            }else{
                imagesEditDataDic["files1"] = arrchangedbase64Images[0]
                imagesEditDataDic["files2"] = arrchangedbase64Images[1]
            }
            imagesEditDataDic["files1_name"] = arr_changedfilePaths[0]
            imagesEditDataDic["files2_name"] = arr_changedfilePaths[1]
        case 3:
            imgProduct1.image = arr_changedImages[0]
            imgProduct2.image = arr_changedImages[1]
            imgProduct3.image = arr_changedImages[2]
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            
            if product_id != "" {
                imagesEditDataDic["image1"] = arrchangedbase64Images[0]
                imagesEditDataDic["image2"] = arrchangedbase64Images[1]
                imagesEditDataDic["image3"] = arrchangedbase64Images[2]
            }else{
                imagesEditDataDic["files1"] = arrchangedbase64Images[0]
                imagesEditDataDic["files2"] = arrchangedbase64Images[1]
                imagesEditDataDic["files3"] = arrchangedbase64Images[2]
            }
            
           
            
            imagesEditDataDic["files1_name"] = arr_changedfilePaths[0]
            imagesEditDataDic["files2_name"] = arr_changedfilePaths[1]
            imagesEditDataDic["files3_name"] = arr_changedfilePaths[2]
        case 4:
            imgProduct1.image = arr_changedImages[0]
            imgProduct2.image = arr_changedImages[1]
            imgProduct3.image = arr_changedImages[2]
            imgProduct4.image = arr_changedImages[3]
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            imgProduct4.contentMode = .scaleAspectFit
            
            if product_id != "" {
                imagesEditDataDic["image1"] = arrchangedbase64Images[0]
                imagesEditDataDic["image2"] = arrchangedbase64Images[1]
                imagesEditDataDic["image3"] = arrchangedbase64Images[2]
                imagesEditDataDic["image4"] = arrchangedbase64Images[3]
            }else{
                imagesEditDataDic["files1"] = arrchangedbase64Images[0]
                imagesEditDataDic["files2"] = arrchangedbase64Images[1]
                imagesEditDataDic["files3"] = arrchangedbase64Images[2]
                imagesEditDataDic["files4"] = arrchangedbase64Images[3]
            }
            
            
           
            
            imagesEditDataDic["files1_name"] = arr_changedfilePaths[0]
            imagesEditDataDic["files2_name"] = arr_changedfilePaths[1]
            imagesEditDataDic["files3_name"] = arr_changedfilePaths[2]
            imagesEditDataDic["files4_name"] = arr_changedfilePaths[3]
        case 5:
            imgProduct1.image = arr_changedImages[0]
            imgProduct2.image = arr_changedImages[1]
            imgProduct3.image = arr_changedImages[2]
            imgProduct4.image = arr_changedImages[3]
            imgProduct5.image = arr_changedImages[4]
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            imgProduct4.contentMode = .scaleAspectFit
            imgProduct5.contentMode = .scaleAspectFit
            
            
            if product_id != "" {
                imagesEditDataDic["image1"] = arrchangedbase64Images[0]
                imagesEditDataDic["image2"] = arrchangedbase64Images[1]
                imagesEditDataDic["image3"] = arrchangedbase64Images[2]
                imagesEditDataDic["image4"] = arrchangedbase64Images[3]
                imagesEditDataDic["image5"] = arrchangedbase64Images[4]
            }else{
                imagesEditDataDic["files1"] = arrchangedbase64Images[0]
                imagesEditDataDic["files2"] = arrchangedbase64Images[1]
                imagesEditDataDic["files3"] = arrchangedbase64Images[2]
                imagesEditDataDic["files4"] = arrchangedbase64Images[3]
                imagesEditDataDic["files5"] = arrchangedbase64Images[4]
            }
            
            imagesEditDataDic["files1_name"] = arr_changedfilePaths[0]
            imagesEditDataDic["files2_name"] = arr_changedfilePaths[1]
            imagesEditDataDic["files3_name"] = arr_changedfilePaths[2]
            imagesEditDataDic["files4_name"] = arr_changedfilePaths[3]
            imagesEditDataDic["files5_name"] = arr_changedfilePaths[4]
        default:
            imgProduct1.image = imagePlaceholder
            imgProduct2.image = imagePlaceholder
            imgProduct3.image = imagePlaceholder
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        let fileUrl = info[UIImagePickerControllerImageURL] as? URL
        arr_changedfilePaths.append(fileUrl?.lastPathComponent as AnyObject)
        
        arr_changedImages.append(image!)
        print(arr_changedImages.count)
        print( arr_changedfilePaths.count)
        self.checkWithImages()
        
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateImages(productId: String) {
        
         let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":product_id,"user_id":merchantId] as [String : AnyObject]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_PRODUCT_DETAILS, params: paramsDic)  { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.ProductDetails = (dataDictionary!["products"]as? [String:Any])!
                
                print(dataDictionary!)
                _ = ProductInformation.init(productDetailsDictionay: self.ProductDetails)
                
                self.type = ProductInformation.type!
                if ProductInformation.productImage1 != ""  {
                 
                    let imgProduct1 = String("\(WebServices.BASE_URL)\(ProductInformation.productImage1!)")
                    self.imgProduct1.sd_setImage(with: URL(string: imgProduct1), placeholderImage: UIImage(named: "productPlaceholder"))
                    self.arr_changedfilePaths.append(ProductInformation.productImage1!.suffix(41) as AnyObject)

                    self.arr_changedImages.append(self.imgProduct1.image!)
                    
                }
                if ProductInformation.productImage2 != ""  {
                    let imgProduct2 = String("\(WebServices.BASE_URL)\(ProductInformation.productImage2!)")
                    self.imgProduct2.sd_setImage(with: URL(string: imgProduct2), placeholderImage: UIImage(named: "productPlaceholder"))
                    self.arr_changedfilePaths.append(ProductInformation.productImage2!.suffix(41) as AnyObject)
                    
                    self.arr_changedImages.append(self.imgProduct2.image!)
                }
                if ProductInformation.productImage3 != ""  {
                   
                    let imgProduct3 = String("\(WebServices.BASE_URL)\(ProductInformation.productImage3!)")
                    self.imgProduct3.sd_setImage(with: URL(string: imgProduct3), placeholderImage: UIImage(named: "productPlaceholder"))
                    self.arr_changedfilePaths.append(ProductInformation.productImage1!.suffix(41) as AnyObject)
                    self.arr_changedImages.append(self.imgProduct3.image!)

                }
                if ProductInformation.productImage4 != ""  {
                    
                    let imgProduct4 = String("\(WebServices.BASE_URL)\(ProductInformation.productImage4!)")
                    self.imgProduct4.sd_setImage(with: URL(string: imgProduct4), placeholderImage: UIImage(named: "productPlaceholder"))
                    self.arr_changedfilePaths.append(ProductInformation.productImage4!.suffix(41) as AnyObject)
                    self.arr_changedImages.append(self.imgProduct4.image!)

                    
                }
                if ProductInformation.productImage5 != ""  {
                    let imgProduct5 = String("\(WebServices.BASE_URL)\(ProductInformation.productImage5!)")
                    self.imgProduct5.sd_setImage(with: URL(string: imgProduct5), placeholderImage: UIImage(named: "productPlaceholder"))
                    self.arr_changedfilePaths.append(ProductInformation.productImage5!.suffix(41) as AnyObject)
                    self.arr_changedImages.append(self.imgProduct5.image!)

                }
                
            }
        }
    }
    
    @IBAction func saveListingImages(_ sender: Any) {
 
        if arr_changedImages.count == 0
        {
            showAlert(message: "Please upload images")
            return
        }
        
        if product_id != "" {
           
            self.view.StartLoading()
            
            print(imagesEditDataDic)
            ApiManager().postRequest(service: WebServices.MERCHANT_EDIT_ITEM, params:  imagesEditDataDic) { (result, success) in
                self.view.StopLoading()
                if success == false
                {
                    
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                   
                     let resultDictionary = result as! [String : Any]
                    print(resultDictionary)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProductImagesViewController") as! CreateProductImagesViewController
                    
                    vc.ProductId = self.product_id
                    vc.editItem = true
                    vc.banners = true
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
            
        }
        else{
            
            imagesEditDataDic["api_key_data"] = WebServices.API_KEY
            imagesEditDataDic["user_id"] = merchantId
            
            self.view.StartLoading()
            
            ApiManager().postRequest(service: WebServices.MERCHANT_CREATE_IMAGES, params: imagesEditDataDic) { (result, success) in
                self.view.StopLoading()
                if success == false
                {
                    
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProductImagesViewController") as! CreateProductImagesViewController
                    
                        let resultDictionary = result as! [String : Any]
                        let data = resultDictionary ["data"] as! [String:Any]
                        print(data)
                        let arrProductDetails : [String :Any] = (data["product"] as? [String :Any]) != nil  ?  (data["product"] as! [String :Any]) : [:]
                        
                        vc.ProductId = "\(arrProductDetails["product_id"]!)"
                        
                  
                    vc.editItem = false
                    vc.banners = true
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
