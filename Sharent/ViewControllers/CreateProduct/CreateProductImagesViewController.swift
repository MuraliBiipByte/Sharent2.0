import UIKit
import ActionSheetPicker
import Photos

class CreateProductImagesViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate
{
    
    var  productDataDic = [String:Any] ()
    
    var arr_selectedImages = [UIImage]()
    var arrbase64Images = [AnyObject]()
    var imagePlaceholder = UIImage()
    var arr_selectedfilePaths = [AnyObject]()
    
    
    var arrCatagorydata = [AnyObject]()
    var arrCatagoryNames = [AnyObject]()
    var arrCatagoryids = [AnyObject]()
    var arrLalamoveVeichles = [String]()
    
    var catagoryId = String()
    var thumbnail = UIImage()
    
    var merchantId = String()
    var merchantPhoneNumber = String()
    
    var image1,image2,image3,image4,image5:UIImage!
    
    // Need to send lalamoveVehicle in capital letters
    var strLalamoveVehicle = String()
    
    @IBOutlet weak var txtProductName:UITextField!
    @IBOutlet weak var txtProductRate:UITextField!
    @IBOutlet weak var txtMinimumDays:UITextField!
    @IBOutlet weak var txtMaxQuantity:UITextField!
    @IBOutlet weak var txtLalamoveVehicle:UITextField!
    @IBOutlet weak var txtItemCatagory:UITextField!
    @IBOutlet weak var txtviewProductDetails:UITextView!
    @IBOutlet weak var txtviewProductCare:UITextView!
    @IBOutlet weak var txtviewProductDescription:UITextView!
    
    
    @IBOutlet weak var imgProduct1:UIImageView!
    @IBOutlet weak var imgProduct2:UIImageView!
    @IBOutlet weak var imgProduct3:UIImageView!
    @IBOutlet weak var imgProduct4:UIImageView!
    @IBOutlet weak var imgProduct5:UIImageView!
    
    //OptionsRelated
    @IBOutlet weak var viewTxtOpt1:UIView!
    @IBOutlet weak var viewTxtOpt1Height:NSLayoutConstraint!
    @IBOutlet weak var txtOpt1:UITextField!
    @IBOutlet weak var txtOpt2:UITextField!
    
    var strOptionsCount = Int()
    var strChoicesCount1 = Int()
    var strChoicesCount2 = Int()
    var viewOptionHeight:Int = 44
    var arrOptionsChoice1 = NSMutableArray()
    var arrOptionsChoice2 = NSMutableArray()
    
    //We are  using these 6 textfields for expanding entering data related to product.
    
    @IBOutlet weak var txtChc1:UITextField!
    @IBOutlet weak var txtChc2:UITextField!
    @IBOutlet weak var txtChc3:UITextField!
    @IBOutlet weak var txtChc4:UITextField!
    @IBOutlet weak var txtChc5:UITextField!
    @IBOutlet weak var txtChc6:UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        merchantId = UserDefaults.standard.value(forKey: "user_id") as! String
        merchantPhoneNumber = UserDefaults.standard.value(forKey: "user-phone")as! String
        
        self.title = "List Item" 
        
        arrLalamoveVeichles = ["Motorcycle", "Car","Minivan", "Van"]
        
        txtviewProductDetails.text = " What is it? "
        txtviewProductDetails.textColor = UIColor.lightGray
        
        txtviewProductCare.text = " What should users take note of? "
        txtviewProductCare.textColor = UIColor.lightGray
        
        txtviewProductDescription.text = " Any additional information? "
        txtviewProductDescription.textColor = UIColor.lightGray
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action:#selector(backvc), for: .touchUpInside)
        let btnBack = UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = btnBack
        
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
        
        getAllCategories()
        
        txtOpt1.isHidden = false
        txtOpt2.isHidden = false
        
        txtChc1.isHidden = true
        txtChc2.isHidden = true
        txtChc3.isHidden = true
        txtChc3.isHidden = true
        txtChc4.isHidden = true
        txtChc5.isHidden = true
        txtChc6.isHidden = true
        
        strChoicesCount1 = 1
        strChoicesCount2 = 1
        
        viewTxtOpt1Height.constant = CGFloat(viewOptionHeight * strChoicesCount1)
        viewTxtOpt1Height.isActive = true
        viewTxtOpt1.isHidden = false
     
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @objc func checkWithImagesChecking(sender:UITapGestureRecognizer)
    {
        let imageview:UIImageView = (sender.view as? UIImageView)!;
        print(imageview.tag)
        
        imagePlaceholder = UIImage(named: "addImgSmall")!
        
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
            let otherAlert = UIAlertController(title:Constants.APP_NAME, message: "Are you sure you want delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:
            {(alert: UIAlertAction!) in
                
                self.arr_selectedImages.remove(at: imageview.tag-1)
                self.arr_selectedfilePaths.remove(at: imageview.tag-1)
                self.checkWithImages()
                
            })
            otherAlert.addAction(okAction)
            otherAlert.addAction(deleteAction)
            present(otherAlert, animated: true, completion: nil)
            
            
        }
    }
    func checkWithImages()
    {
        for i in (0..<arr_selectedImages.count)
        {
            let image = arr_selectedImages[i]
            let imageData = UIImageJPEGRepresentation(image , 1.0)! as NSData
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            arrbase64Images.insert(strBase64 as AnyObject, at: i)
        }
        switch arr_selectedImages.count
        {
        case 1:
            imgProduct1.image = arr_selectedImages[0]
            imgProduct2.image = imagePlaceholder
            imgProduct3.image = imagePlaceholder
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            productDataDic["files1"] = arrbase64Images[0]
            productDataDic["files1_name"] = arr_selectedfilePaths[0]
        case 2:
            imgProduct1.image = arr_selectedImages[0]
            imgProduct2.image = arr_selectedImages[1]
            imgProduct3.image = imagePlaceholder
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            productDataDic["files1"] = arrbase64Images[0]
            productDataDic["files2"] = arrbase64Images[1]
            productDataDic["files1_name"] = arr_selectedfilePaths[0]
            productDataDic["files2_name"] = arr_selectedfilePaths[1]
        case 3:
            imgProduct1.image = arr_selectedImages[0]
            imgProduct2.image = arr_selectedImages[1]
            imgProduct3.image = arr_selectedImages[2]
            imgProduct4.image = imagePlaceholder
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            productDataDic["files1"] = arrbase64Images[0]
            productDataDic["files2"] = arrbase64Images[1]
            productDataDic["files3"] = arrbase64Images[2]
            productDataDic["files1_name"] = arr_selectedfilePaths[0]
            productDataDic["files2_name"] = arr_selectedfilePaths[1]
            productDataDic["files3_name"] = arr_selectedfilePaths[2]
        case 4:
            imgProduct1.image = arr_selectedImages[0]
            imgProduct2.image = arr_selectedImages[1]
            imgProduct3.image = arr_selectedImages[2]
            imgProduct4.image = arr_selectedImages[3]
            imgProduct5.image = imagePlaceholder
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            imgProduct4.contentMode = .scaleAspectFit
            productDataDic["files1"] = arrbase64Images[0]
            productDataDic["files2"] = arrbase64Images[1]
            productDataDic["files3"] = arrbase64Images[2]
            productDataDic["files4"] = arrbase64Images[3]
            productDataDic["files1_name"] = arr_selectedfilePaths[0]
            productDataDic["files2_name"] = arr_selectedfilePaths[1]
            productDataDic["files3_name"] = arr_selectedfilePaths[2]
            productDataDic["files4_name"] = arr_selectedfilePaths[3]
        case 5:
            imgProduct1.image = arr_selectedImages[0]
            imgProduct2.image = arr_selectedImages[1]
            imgProduct3.image = arr_selectedImages[2]
            imgProduct4.image = arr_selectedImages[3]
            imgProduct5.image = arr_selectedImages[4]
            imgProduct1.contentMode = .scaleAspectFit
            imgProduct2.contentMode = .scaleAspectFit
            imgProduct3.contentMode = .scaleAspectFit
            imgProduct4.contentMode = .scaleAspectFit
            imgProduct5.contentMode = .scaleAspectFit
            productDataDic["files1"] = arrbase64Images[0]
            productDataDic["files2"] = arrbase64Images[1]
            productDataDic["files3"] = arrbase64Images[2]
            productDataDic["files4"] = arrbase64Images[3]
            productDataDic["files5"] = arrbase64Images[4]
            productDataDic["files1_name"] = arr_selectedfilePaths[0]
            productDataDic["files2_name"] = arr_selectedfilePaths[1]
            productDataDic["files3_name"] = arr_selectedfilePaths[2]
            productDataDic["files4_name"] = arr_selectedfilePaths[3]
            productDataDic["files5_name"] = arr_selectedfilePaths[4]
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
        arr_selectedfilePaths.append(fileUrl?.lastPathComponent as AnyObject)
        arr_selectedImages.append(image!)
        self.checkWithImages()
        print(image?.size as Any)
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func getAllCategories()
    {
        
        let Dict = ["api_key_data":WebServices.API_KEY]
        
        ApiManager().postRequest(service: WebServices.GET_ALL_CATAGORIES, params: Dict) { (result, success) in
            if success == false
            {
                
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                self.arrCatagorydata = dataDictionary!["category"] as! [AnyObject]
                
                for catagorydata in self.arrCatagorydata
                {
                    self.arrCatagoryids.append(catagorydata["id"] as AnyObject)
                    self.arrCatagoryNames.append(catagorydata["name"] as AnyObject)
                }
                
            }
        }
    }
    @IBAction func btnCatagoriesTapped(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Choose Catagory", rows: self.arrCatagoryNames as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                self.txtItemCatagory.text = index as? String
                
                self.catagoryId = self.arrCatagoryids[value] as! String
                
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    @IBAction func btnLalaMoveVeichleTapped(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Choose Vehicle", rows: self.arrLalamoveVeichles as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                let lalamoveVehicleType = index as! String
                
                self.strLalamoveVehicle = lalamoveVehicleType.uppercased()
                
                self.txtLalamoveVehicle.text = index as? String
                
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }

    @IBAction func listMyItemTapped()
    {
        self.view.endEditing(true)
        
        if arr_selectedImages.count == 0
        {
            showAlert(message: "Please upload images")
            return
        }
        if (txtProductName.text?.isEmpty)! || txtProductName.text == ""
        {
            showAlert(message: "Please enter Productname")
            txtProductName.becomeFirstResponder()
            return
        }
        if (txtProductRate.text?.isEmpty)! || txtProductRate.text == ""
        {
            showAlert(message: "Please enter Product Rate")
            txtProductRate.becomeFirstResponder()
            return
        }
        if (txtMinimumDays.text?.isEmpty)! || txtMinimumDays.text == ""
        {
            showAlert(message: "Please choose Product Minimum Days")
            return
        }
        if (txtMaxQuantity.text?.isEmpty)! || txtMaxQuantity.text == ""
        {
            showAlert(message: "Please Enter maximum quantity ")
            txtMaxQuantity.becomeFirstResponder()
            return
        }
        
        if (txtviewProductDetails.text?.isEmpty)! || txtviewProductDetails.textColor == UIColor.lightGray
        {
            showAlert(message: "Please enter Product Description")
            txtviewProductDetails.becomeFirstResponder()
            return
        }
        if (txtviewProductCare.text?.isEmpty)! || txtviewProductCare.textColor == UIColor.lightGray
        {
            showAlert(message: "Please enter Product Care")
            txtviewProductCare.becomeFirstResponder()
            return
        }
        if (txtviewProductDescription.text?.isEmpty)! || txtviewProductDescription.textColor == UIColor.lightGray
        {
            showAlert(message: "Please enter Other Description")
            txtviewProductDescription.becomeFirstResponder()
            return
        }
        if (txtLalamoveVehicle.text?.isEmpty)! || txtLalamoveVehicle.text == ""
        {
            showAlert(message: "Please Select Veichle Type")
            return
        }
        if (txtItemCatagory.text?.isEmpty)! || txtItemCatagory.text == ""
        {
            showAlert(message: "Please Select item Catagory")
            return
        }
        if txtOpt1.text != "" 
        {
            if (txtChc1.text?.isEmpty)! &&  (txtChc2.text?.isEmpty)! && (txtChc3.text?.isEmpty)!
            {
                showAlert(message: "Please enter Choices")
                return
            }
            else
            {
                if  txtChc1.text != ""
                {
                    arrOptionsChoice1.add(txtChc1.text as Any)
                }
                if  txtChc2.text != ""
                {
                    arrOptionsChoice1.add(txtChc2.text as Any)
                }
                if  txtChc3.text != ""
                {
                    arrOptionsChoice1.add(txtChc3.text as Any)
                }
            }
        }
        if  txtOpt2.text != ""
        {
            if (txtChc4.text?.isEmpty)! &&  (txtChc5.text?.isEmpty)! && (txtChc6.text?.isEmpty)!
            {
                showAlert(message: "Please enter Choices")
                return
            }
            else
            {
                if txtChc4.text != ""
                {
                    arrOptionsChoice2.add(txtChc4.text as Any)
                }
                if  txtChc5.text != ""
                {
                    arrOptionsChoice2.add(txtChc5.text as Any)
                }
                if  txtChc6.text != ""
                {
                    arrOptionsChoice2.add(txtChc6.text as Any)
                }
            }
        }
    
        let para = NSMutableDictionary()
        let prodArray1 = NSMutableArray()
        let prodArray2 = NSMutableArray()
        
        
        switch strOptionsCount
        {
        case 1:
            for i in 0..<arrOptionsChoice1.count
            {
                let prod: NSMutableDictionary = NSMutableDictionary()
                prod.setValue(arrOptionsChoice1[i], forKey: "name")
                prod.setValue(i, forKey: "id")
                prodArray1.add(prod)
            }
            para.setObject(prodArray1, forKey: txtOpt1.text! as NSCopying)
        case 2:
            for i in 0..<arrOptionsChoice1.count
            {
                let prod: NSMutableDictionary = NSMutableDictionary()
                prod.setValue(arrOptionsChoice1[i], forKey: "name")
                prod.setValue(i, forKey: "id")
                prodArray1.add(prod)
            }
            for i in 0..<arrOptionsChoice2.count
            {
                let prod: NSMutableDictionary = NSMutableDictionary()
                prod.setValue(arrOptionsChoice2[i], forKey: "name")
                prod.setValue(i, forKey: "id")
                prodArray2.add(prod)
            }
            para.setObject(prodArray1, forKey: txtOpt1.text! as NSCopying)
            para.setObject(prodArray2, forKey: txtOpt2.text! as NSCopying)
            
        default:
            print("Check with count")
        }
        
        let data = try? JSONSerialization.data(withJSONObject: para, options: [])
        let strSpecifications = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        productDataDic["api_key_data"] = WebServices.API_KEY
        productDataDic["environment"] = "ios"
        productDataDic["phone_number"] = merchantPhoneNumber
        productDataDic["user_id"] = merchantId
        productDataDic["product_name"] = txtProductName.text!
        productDataDic["product_fee"] = txtProductRate.text!
        productDataDic["rates"] = txtProductRate.text!
        productDataDic["product_details"] = txtviewProductDetails.text!
        productDataDic["product_care"] = txtviewProductCare.text!
        productDataDic["description"] = txtviewProductDescription.text!
        productDataDic["category"] = self.catagoryId
        productDataDic["specifications"] = strSpecifications!
        productDataDic["minimum_days"] = txtMinimumDays.text!
        productDataDic["quantity"] = txtMaxQuantity.text!
        productDataDic["vehicletype"] = self.strLalamoveVehicle
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.CREATE_PRODUCT, params: productDataDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.arrOptionsChoice1.removeAllObjects()
                self.arrOptionsChoice2.removeAllObjects()
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let title = resultDictionary["message"] as? String
                let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                successClass.strTitle = title!
                successClass.strMessage = ""
                self.navigationController?.pushViewController(successClass, animated: false)
            }
        }
        
    }
    @IBAction func btn_choose_rentalDays_tapped(sender:UIButton)
    {
        
        var arrbaseMinimumRentalDays = [Int]()
        for index in 1...10
        {
            arrbaseMinimumRentalDays.append(index)
        }
        ActionSheetStringPicker.show(withTitle: "Minimum Rental Days", rows: arrbaseMinimumRentalDays as [Any], initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            self.txtMinimumDays.text = String(describing: index!)
            
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    @IBAction func btnChoiceName1Tapped()
    {
        switch strChoicesCount1
        {
        case 1:
            if (txtOpt1.text?.isEmpty)! || txtOpt1.text == ""
            {
                
            }
            else
            {
                if strChoicesCount2 > strChoicesCount1
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount2)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount1+1))
                }
                strChoicesCount1 += 1
                strOptionsCount = 1
                txtChc1.isHidden = false
            }
        case 2:
            if (txtChc1.text?.isEmpty)! || txtChc1.text == ""
            {
                
            }
            else
            {
                if strChoicesCount2 > strChoicesCount1
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount2)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount1+1))
                }
                strChoicesCount1 += 1
                txtChc2.isHidden = false
                
            }
        case 3:
            if (txtChc2.text?.isEmpty)! || txtChc2.text == ""
            {
                
            }
            else
            {
                if strChoicesCount2 > strChoicesCount1
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount2)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount1+1))
                }
                strChoicesCount1 += 1
                txtChc3.isHidden = false
            }
            
        default:
            
            print("Something Wrong")
        }
        
        
        
    }
    @IBAction func btnChoiceName2Tapped()
    {
        
        switch strChoicesCount2
        {
        case 1:
            if  (txtOpt2.text?.isEmpty)! || txtOpt2.text == ""
            {
                
            }
            else
            {
                if strChoicesCount1 > strChoicesCount2
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount1)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount2+1))
                }
                txtChc4.isHidden = false
                strChoicesCount2 += 1
                strOptionsCount += 1
                
               
            }
        case 2:
            if  (txtChc4.text?.isEmpty)! || txtChc4.text == ""
            {
                
            }
            else
            {
                if strChoicesCount1 > strChoicesCount2
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount1)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount2+1))
                }
                txtChc5.isHidden = false
                strChoicesCount2 += 1
                
                
            }
        case 3:
            if  (txtChc5.text?.isEmpty)! || txtChc5.text == ""
            {
                
            }
            else
            {
                if strChoicesCount1 > strChoicesCount2
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*strChoicesCount1)
                }
                else
                {
                    viewTxtOpt1Height.constant = CGFloat(viewOptionHeight*(strChoicesCount2+1))
                }
                txtChc6.isHidden = false
                strChoicesCount2 += 1
                
                
            }
            
        default:
            print("Something Wrong")
        }
        
        
        
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    @objc func backvc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        if  textView == txtviewProductDetails
        {
            if txtviewProductDetails.textColor == UIColor.lightGray
            {
                txtviewProductDetails.text = nil
                txtviewProductDetails.textColor = Constants.NAVIGATION_COLOR
            }
        }
        if  textView == txtviewProductCare
        {
            if txtviewProductCare.textColor == UIColor.lightGray
            {
                txtviewProductCare.text = nil
                txtviewProductCare.textColor = Constants.NAVIGATION_COLOR
            }
        }
        if  textView == txtviewProductDescription
        {
            if txtviewProductDescription.textColor == UIColor.lightGray
            {
                txtviewProductDescription.text = nil
                txtviewProductDescription.textColor = Constants.NAVIGATION_COLOR
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        if  textView == txtviewProductDetails
        {
            let currentText:String = txtviewProductDetails.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty
            {
                
                txtviewProductDetails.text = " What is it? "
                txtviewProductDetails.textColor = UIColor.lightGray
                txtviewProductDetails.selectedTextRange = textView.textRange(from: txtviewProductDetails.beginningOfDocument, to: txtviewProductDetails.beginningOfDocument)
            }
                
            else if txtviewProductDetails.textColor == UIColor.lightGray && !text.isEmpty
            {
                txtviewProductDetails.textColor = Constants.NAVIGATION_COLOR
                txtviewProductDetails.text = text
            }
            else
            {
                let newText = (txtviewProductDetails.text as NSString).replacingCharacters(in: range, with: text)
                if newText.count >= 251
                {
                    txtviewProductDetails.resignFirstResponder()
                    showAlert(message: " You can able enter max 250 characters of Product Description")
                    return false
                }
                return true
            }
        }
        if textView == txtviewProductCare
        {
            let currentText:String = txtviewProductCare.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty
            {
                
                txtviewProductCare.text = " What should users take note of? "
                txtviewProductCare.textColor = UIColor.lightGray
                txtviewProductCare.selectedTextRange = textView.textRange(from: txtviewProductCare.beginningOfDocument, to: txtviewProductCare.beginningOfDocument)
            }
                
            else if txtviewProductCare.textColor == UIColor.lightGray && !text.isEmpty
            {
                txtviewProductCare.textColor = Constants.NAVIGATION_COLOR
                txtviewProductCare.text = text
            }
            else
            {
                let newText = (txtviewProductCare.text as NSString).replacingCharacters(in: range, with: text)
                if newText.count >= 251
                {
                    txtviewProductDetails.resignFirstResponder()
                    showAlert(message: " You can able enter max 250 characters of Product Care")
                    return false
                }
                return true
            }
        }
       if textView == txtviewProductDescription
        {
            let currentText:String = txtviewProductDescription.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            if updatedText.isEmpty
            {
                
                txtviewProductDescription.text = " Any additional information? "
                txtviewProductDescription.textColor = UIColor.lightGray
                txtviewProductDescription.selectedTextRange = textView.textRange(from: txtviewProductDescription.beginningOfDocument, to: txtviewProductDescription.beginningOfDocument)
            }
                
            else if txtviewProductDescription.textColor == UIColor.lightGray && !text.isEmpty
            {
                txtviewProductDescription.textColor = Constants.NAVIGATION_COLOR
                txtviewProductDescription.text = text
            }
            else
            {
               
                let newText = (txtviewProductDescription.text as NSString).replacingCharacters(in: range, with: text)
                    if newText.count >= 151
                    {
                        txtviewProductDescription.resignFirstResponder()
                        showAlert(message: " You can able enter max 150 characters of Other Description")
                        return false
                    }
                
                return true
            }
        }

        return false
    }

    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtMaxQuantity
        {
            let text = txtMaxQuantity.text! as NSString
            let str = text.replacingCharacters(in: range,with: string)
            if (str.count) >= 3
            {
                txtMaxQuantity.resignFirstResponder()
                showAlert(message: "You can able enter max 99 Quantity")
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
        textField.leftViewMode = .always
        
    }
    
}
