import UIKit
import ActionSheetPicker
import Photos
import UITextView_Placeholder
import SDWebImage
import ImageSlideshow
import MaterialComponents.MaterialChips



class CreateProductImagesViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate
{
    
    var  productDataDic = [String:Any] ()
    var arr_selectedImages = [UIImage]()
    var arrbase64Images = [AnyObject]()
    var imagePlaceholder = UIImage()
    var arr_selectedfilePaths = [AnyObject]()
    var ProductDetails = [String:Any]()
    var arrCatagorydata = [AnyObject]()
    var arrCatagoryNames = [AnyObject]()
    var arrCatagoryids = [AnyObject]()
    var arrLalamoveVeichles = [String]()
    var strSpecifications = String()
    var catagoryId = String()
    var thumbnail = UIImage()
   
    var merchantId = String()
    var merchantPhoneNumber = String()
    
    @IBOutlet weak var btnListingType: UIButton!
    var image1,image2,image3,image4,image5:UIImage!
    
    // Need to send lalamoveVehicle in capital letters
    var strLalamoveVehicle = String()
    //    var deliveryTpe = String()
   
    
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var txtProductName:UITextField!
    @IBOutlet weak var txtProductRate:UITextField!
    @IBOutlet weak var txtMinimumDays:UITextField!
    @IBOutlet weak var txtMaxQuantity:UITextField!
    
    
    @IBOutlet weak var productImagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsImagesView: UIView!
    @IBOutlet weak var bannersSlideShow: ImageSlideshow!
    
    @IBOutlet weak var txtProductFee: UITextField!
    //    @IBOutlet weak var txtDeliveryType: UITextField!
    @IBOutlet weak var txtItemCatagory:UITextField!
    @IBOutlet weak var txtviewProductDetails:UITextView!
    @IBOutlet weak var txtviewProductCare:UITextView!
    @IBOutlet weak var txtviewProductDescription:UITextView!
    @IBOutlet weak var txtTagsSelected: UITextView!
    
    @IBOutlet weak var imgProduct1:UIImageView!
    @IBOutlet weak var imgProduct2:UIImageView!
    @IBOutlet weak var imgProduct3:UIImageView!
    @IBOutlet weak var imgProduct4:UIImageView!
    @IBOutlet weak var imgProduct5:UIImageView!
    
    @IBOutlet weak var imgProduct1Height: NSLayoutConstraint!
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
//    var yPos = 10
//    var xPos = 5
//    var wid = 5
//    var chipView = MDCChipView()
//    let chipField = MDCChipField()
//
    
    //We are  using these 10 textfields for expanding entering data related to product.
    
    // Option 1
    @IBOutlet weak var option1txtChc1:UITextField!
    @IBOutlet weak var option1txtChc2:UITextField!
    @IBOutlet weak var option1txtChc3:UITextField!
    @IBOutlet weak var option1txtChc4: UITextField!
    @IBOutlet weak var option1txtChc5: UITextField!
    @IBOutlet weak var option1txtChc6: UITextField!
    @IBOutlet weak var option1txtChc7: UITextField!
    @IBOutlet weak var option1txtChc8: UITextField!
    @IBOutlet weak var option1txtChc9: UITextField!
    
    // Option 2
    @IBOutlet weak var option2txtChc1: UITextField!
    @IBOutlet weak var option2txtChc2: UITextField!
    @IBOutlet weak var option2txtChc3: UITextField!
    @IBOutlet weak var option2txtChc4: UITextField!
    @IBOutlet weak var option2txtChc5: UITextField!
    @IBOutlet weak var option2txtChc6: UITextField!
    @IBOutlet weak var option2txtChc7: UITextField!
    @IBOutlet weak var option2txtChc8: UITextField!
    @IBOutlet weak var option2txtChc9: UITextField!
    
    
    var SelectionTypes = [String]()
    @IBOutlet weak var txtSelectedType: UITextField!
    //    Tags
    private var tagsTV: UITableView!
    let CellIdentifier = "TagCell"
    var arrTagsdata = [AnyObject]()
    var arrTagids = [AnyObject]()
    var arrTagName = [AnyObject]()
    var selectedArr = [String]()
    var tagsArr = [String]()
    var tagsPositionsArr = [String]()
    
    var durationStr : String = ""
    var type = String()
    var editItem: Bool = false
    var banners: Bool = false
    var ProductId:String? = ""
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var productCreateView: UIView!
    @IBOutlet weak var venueCreateView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    // venue or service fields
    @IBOutlet weak var txtVenueOrServiceCategory: UITextField!
    @IBOutlet weak var txtVenueTags: UITextView!
    @IBOutlet weak var txtVenueRate: UITextField!
    @IBOutlet weak var txtVenueUsage: UITextView!
    @IBOutlet weak var venueAdditionalInfo: UITextView!
    @IBOutlet weak var txtVenuneName: UITextField!
    @IBOutlet weak var txtBookingDate: UITextField!
    @IBOutlet weak var txtVenueBookingDuation: UITextField!
    @IBOutlet weak var txtAboutVenue: UITextView!
    var  venueDataDic = [String:Any] ()
    @IBOutlet weak var usageLbl: UILabel!
    
    var strCategoryPosition : String = ""
    var strTagsPosition : String = ""
    var strTagsNames : String = ""
    var arrProductImages = [String]()
    
    
    
    var intAttributesCount = Int()
    var arrAttribute1Name = NSMutableArray()
    var arrAttribute2Name = NSMutableArray()
    var arrAttribute1 = [AnyObject]()
    var arrAttribute2 = [AnyObject]()
    var strAttribute1 = String()
    var strAttribute2 = String()
    var strTitle = String()
    
    @IBOutlet weak var categoryDropdown: UIImageView!
    
    
    @IBOutlet weak var productTagsView: UIView!
    
    @IBOutlet weak var venueTagsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        chipField.showChipsDeleteButton = true

        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        imgProduct1Height.constant = screenWidth - 40
        imgProduct1Height.isActive = true
        
        imgProduct2.layer.cornerRadius = 8
        imgProduct2.layer.masksToBounds = true
        imgProduct3.layer.cornerRadius = 8
        imgProduct3.layer.masksToBounds = true
        imgProduct4.layer.cornerRadius = 8
        imgProduct4.layer.masksToBounds = true
        imgProduct5.layer.cornerRadius = 8
        imgProduct5.layer.masksToBounds = true
        
        productImagesViewHeight.constant = 0
        productsImagesView.isHidden = true
        bannersSlideShow.isHidden = true
        
        
        merchantId = UserDefaults.standard.value(forKey: "user_id") as! String
        merchantPhoneNumber = UserDefaults.standard.value(forKey: "user-phone")as! String
        
        arrLalamoveVeichles = ["Lalamove","Merchant Delivery"]
        SelectionTypes = ["Product","Venue","Service"]
        
        txtVenueTags.placeholder = " Select Tags"
        txtviewProductDetails.placeholder = " What is it? "
        txtviewProductCare.placeholder = " What should users take note of? "
        txtviewProductDescription.placeholder = " Any additional information? "
        txtTagsSelected.textContainer.lineBreakMode = .byCharWrapping
        txtTagsSelected.placeholder = " Select Tags"
        txtAboutVenue.placeholder = " What is it? "
        txtVenueUsage.placeholder = " What should users take note of?"
        venueAdditionalInfo.placeholder = " Any additional information? "
        
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
        
        txtOpt1.isHidden = false
        txtOpt2.isHidden = false
        
        option1txtChc1.isHidden = true
        option1txtChc2.isHidden = true
        option1txtChc3.isHidden = true
        option1txtChc4.isHidden = true
        option1txtChc5.isHidden = true
        option1txtChc6.isHidden = true
        option1txtChc7.isHidden = true
        option1txtChc8.isHidden = true
        option1txtChc9.isHidden = true
        
        option2txtChc1.isHidden = true
        option2txtChc2.isHidden = true
        option2txtChc3.isHidden = true
        option2txtChc4.isHidden = true
        option2txtChc5.isHidden = true
        option2txtChc6.isHidden = true
        option2txtChc7.isHidden = true
        option2txtChc8.isHidden = true
        option2txtChc9.isHidden = true
        
        strChoicesCount1 = 1
        strChoicesCount2 = 1
        
        viewTxtOpt1Height.constant = CGFloat(viewOptionHeight * strChoicesCount1)
        viewTxtOpt1Height.isActive = true
        viewTxtOpt1.isHidden = false
        
        self.txtSelectedType.text = SelectionTypes[0]
        self.productCreateView.isHidden = false
        self.venueCreateView.isHidden = true
        self.txtItemCatagory.text = ""
        self.categoryDropdown.isHidden = false
        self.durationStr = "Minimum Rental Days"
        self.type = PRODUCT
        getAllCategories(ListType: self.type)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tagsTV = UITableView()
        tagsTV.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        tagsTV.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tagsTV.dataSource = self
        tagsTV.delegate = self
        tagsTV.allowsMultipleSelection = true
        
       
        if editItem {
            self.title = self.strTitle
           btnListingType.isUserInteractionEnabled = false
            btnList.setTitle("Save Listing Details", for: .normal)
            getProductData(product_id: ProductId!)
            bannersSlideShow.isHidden = false
          
            
        }
        else{
            // creating product
            self.title = "CREATE LISTING"
            btnListingType.isUserInteractionEnabled = true
            btnList.setTitle("List Item", for: .normal)
            if banners {
                 bannersSlideShow.isHidden = false
                getProductData(product_id: ProductId!)

            }else{
                 bannersSlideShow.isHidden = true
            }
           
        }
        
    }
    
    var tagsString : String? = ""
    
    
    func getProductData(product_id: String)
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":product_id,"user_id":merchantId] as [String : AnyObject]
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_PRODUCT_DETAILS, params: paramsDic)
        { (result, success) in
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
                
                _ = ProductInformation.init(productDetailsDictionay: self.ProductDetails)
                
                self.type = ProductInformation.type!
                
                if self.type == PRODUCT {
                    
                    self.txtSelectedType.text = self.SelectionTypes[0]
                    self.productCreateView.isHidden = false
                    self.venueCreateView.isHidden = true
                    
                    self.txtProductName.text = "\(ProductInformation.productName!)"
                    self.txtProductFee.text = "\(ProductInformation.productFee!)"
                    self.txtMaxQuantity.text = " \(ProductInformation.productMaximumQunantity!)"
                    
                    self.txtProductRate.text =   " \(ProductInformation.productPrice!)"
                    self.txtMinimumDays.text =  "\(ProductInformation.minimumdays!)"
                    
                    
                    self.txtItemCatagory.text =   ProductInformation.productCategoryName
                    self.catagoryId = ProductInformation.productCategoryId!
                    self.strCategoryPosition =  ProductInformation.productCategory_position!
                    
                    self.txtviewProductDetails.text =  ProductInformation.productDetails
                    self.txtviewProductCare.text =  ProductInformation.productCare
                    self.txtviewProductDescription.text =  ProductInformation.productDescription
                    
//                    self.txtTagsSelected.text =  ProductInformation.tagNames
                    self.str =  ProductInformation.tagNames
                    self.tagId = ProductInformation.tagIds
                    self.tagPositions = ProductInformation.tagPositions
                    
                    if ProductInformation.tagNames != "" {
                        
                        let fullTagsArr : [String] = ProductInformation.tagNames!.components(separatedBy: ",")
                        
                        for item in  0..<fullTagsArr.count {
                            
                            let firstName : String = fullTagsArr[item]
                            self.selectedArr.append(firstName)
                        }
                        
                        self.createTagCloud(OnView: self.productTagsView, withArray: self.selectedArr as [AnyObject])
                        
                    }
                    
                    
                    
                    
                    
                    
                }else if self.type == VENUE {
                    self.txtSelectedType.text = self.SelectionTypes[1]
                    self.productCreateView.isHidden = true
                    self.venueCreateView.isHidden = false
                    
                    self.txtVenuneName.text = "\(ProductInformation.productName!)"
                    self.txtVenueRate.text =   " \(ProductInformation.productPrice!)"
                    
                    self.txtVenueBookingDuation.text =   ProductInformation.bookingDuration
                    self.txtBookingDate.text =
                    " \(ProductInformation.advanceBookingDays!)"
                    
                    self.txtVenueOrServiceCategory.text =   ProductInformation.productCategoryName
                    self.catagoryId = ProductInformation.productCategoryId!
                    self.strCategoryPosition =  ProductInformation.productCategory_position!
                    
                    
                    
//                    self.txtVenueTags.text =  ProductInformation.tagNames
                    self.str =  ProductInformation.tagNames
                    self.tagId = ProductInformation.tagIds
                    self.tagPositions = ProductInformation.tagPositions
                    
                    
                    if ProductInformation.tagNames != "" {
                        
                        let fullTagsArr : [String] = ProductInformation.tagNames!.components(separatedBy: ",")
                        
                        for item in  0..<fullTagsArr.count {
                            
                            let firstName : String = fullTagsArr[item]
                            self.selectedArr.append(firstName)
                        }
                        
                        self.createTagCloud(OnView: self.venueTagsView, withArray: self.selectedArr as [AnyObject])

                    }
                    
                   
                   
                    
                    
                    
                    
                    self.txtAboutVenue.text =  ProductInformation.productDetails
                    self.txtVenueUsage.text =  ProductInformation.productCare
                    self.venueAdditionalInfo.text =  ProductInformation.productDescription
                    
                    
                }else{
                    self.txtSelectedType.text = self.SelectionTypes[2]
                    self.productCreateView.isHidden = true
                    self.venueCreateView.isHidden = false
                    self.txtVenuneName.text = " \(ProductInformation.productName!)"
                    self.txtVenueRate.text =   " \(ProductInformation.productPrice!)"
                    
                    self.txtVenueBookingDuation.text =   ProductInformation.bookingDuration
                    self.txtBookingDate.text = ProductInformation.advanceBookingDays
                    
                    self.txtVenueOrServiceCategory.text =   ProductInformation.productCategoryName
                    self.catagoryId = ProductInformation.productCategoryId!
                    self.strCategoryPosition =  ProductInformation.productCategory_position!
                    
                    
                    
//                    self.txtVenueTags.text =  ProductInformation.tagNames
                    self.str =  ProductInformation.tagNames
                    self.tagId = ProductInformation.tagIds
                    self.tagPositions = ProductInformation.tagPositions
                    
                    if ProductInformation.tagNames != "" {
                        
                        let fullTagsArr : [String] = ProductInformation.tagNames!.components(separatedBy: ",")
                        
                        for item in  0..<fullTagsArr.count {
                            
                            let firstName : String = fullTagsArr[item]
                            self.selectedArr.append(firstName)
                        }
                        
                        self.createTagCloud(OnView: self.venueTagsView, withArray: self.selectedArr as [AnyObject])
                    }
                    
                    
                    self.txtAboutVenue.text =  ProductInformation.productDetails
                    self.txtVenueUsage.text =  ProductInformation.productCare
                    self.venueAdditionalInfo.text =  ProductInformation.productDescription
                    
                    
                }

                    if ProductInformation.productImage1 != ""  { self.arrProductImages.append(String("\(WebServices.BASE_URL)\(ProductInformation.productImage1!)"))
                    
                }
           
                
                if ProductInformation.productImage2 != ""  {
                    self.arrProductImages.append(String("\(WebServices.BASE_URL)\(ProductInformation.productImage2!)"))
                    
                }
                
               
                    if ProductInformation.productImage3 != ""  { self.arrProductImages.append(String("\(WebServices.BASE_URL)\(ProductInformation.productImage3!)"))
                }
                
                    if ProductInformation.productImage4 != ""  { self.arrProductImages.append(String("\(WebServices.BASE_URL)\(ProductInformation.productImage4!)"))
                }
                
                    if ProductInformation.productImage5 != ""  { self.arrProductImages.append(String("\(WebServices.BASE_URL)\(ProductInformation.productImage5!)"))
                }
                
             
                if self.arrProductImages.count > 0
                {
                    self.configurePageControl()
                }

                // for attributes
                
                guard let attributes = self.ProductDetails["attribute"] as? [String:AnyObject] else
                {
                    return
                }
                let attributesData = self.ProductDetails["available_attribute"]as? [String:AnyObject]
                let keys = Array(attributes.keys)
                self.intAttributesCount = keys.count
                switch self.intAttributesCount
                {
                case 1:
                    
                    self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
                    self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
                    self.attributesloop(mainAttributeArray: self.arrAttribute1, arrAttributeName: self.arrAttribute1Name)
                    
                    ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String
                    
                    break
                    
                case 2:
                    self.strAttribute1 = ProductInformation.attribute!["attribute_1"] as! String
                    self.arrAttribute1 = (attributesData!["available_attribute_1"] as? [AnyObject])!
                    self.attributesloop(mainAttributeArray: self.arrAttribute1, arrAttributeName: self.arrAttribute1Name)
                    
                    ProductInformation.attribute1Name = self.arrAttribute1Name[0] as? String
                    
                    self.strAttribute2 = ProductInformation.attribute!["attribute_2"] as! String
                    self.arrAttribute2 = (attributesData!["available_attribute_2"] as? [AnyObject])!
                    
                    self.attributesloop(mainAttributeArray: self.arrAttribute2, arrAttributeName: self.arrAttribute2Name)
                    
                    ProductInformation.attribute2Name = self.arrAttribute2Name[0] as? String
                    
                    break
                default:
                    
                    return
                }
                
                self.arrOptionsChoice1 = self.arrAttribute1Name
                self.arrOptionsChoice2 = self.arrAttribute2Name
                
                
                if self.arrOptionsChoice1.count > 0 {
                     self.strOptionsCount = 1
                     self.txtOpt1.text = self.strAttribute1
                    
                    // option 1 attributes
                    for i in (0..<self.arrOptionsChoice1.count)
                    {
                        
                        switch i
                        {
                        case 0 :
                            self.option1txtChc1.isHidden = false
                            self.option1txtChc1.text = self.arrOptionsChoice1[i] as? String
                            
                        case 1 :
                            self.option1txtChc2.isHidden = false
                            self.option1txtChc2.text = self.arrOptionsChoice1[i] as? String
                        case 2 :
                            self.option1txtChc3.isHidden = false
                            self.option1txtChc3.text = self.arrOptionsChoice1[i] as? String
                        case 3 :
                            self.option1txtChc4.isHidden = false
                            self.option1txtChc4.text = self.arrOptionsChoice1[i] as? String
                        case 4 :
                            self.option1txtChc5.isHidden = false
                            self.option1txtChc5.text = self.arrOptionsChoice1[i] as? String
                        case 5 :
                            self.option1txtChc6.isHidden = false
                            self.option1txtChc6.text = self.arrOptionsChoice1[i] as? String
                        case 6 :
                            self.option1txtChc7.isHidden = false
                            self.option1txtChc7.text = self.arrOptionsChoice1[i] as? String
                        case 7 :
                            self.option1txtChc8.isHidden = false
                            self.option1txtChc8.text = self.arrOptionsChoice1[i] as? String
                        case 8 :
                            self.option1txtChc9.isHidden = false
                            self.option1txtChc9.text = self.arrOptionsChoice1[i] as? String
                            
                        default:
                            print("Something Wrong")
                        }
                        
                        
                    }
                    
                }
                if self.arrOptionsChoice2.count > 0 {
                    self.strOptionsCount += 1
                     self.txtOpt2.text = self.strAttribute2
                    // Option2 attributes
                    
                    for i in (0..<self.arrOptionsChoice2.count)
                    {
                        switch i
                        {
                        case 0 :
                            self.option2txtChc1.isHidden = false
                            self.option2txtChc1.text = self.arrOptionsChoice2[i] as? String
                        case 1 :
                            self.option2txtChc2.isHidden = false
                            self.option2txtChc2.text = self.arrOptionsChoice2[i] as? String
                        case 2 :
                            self.option2txtChc3.isHidden = false
                            self.option2txtChc3.text = self.arrOptionsChoice2[i] as? String
                        case 3 :
                            self.option2txtChc4.isHidden = false
                            self.option2txtChc4.text = self.arrOptionsChoice2[i] as? String
                        case 4 :
                            self.option2txtChc5.isHidden = false
                            self.option2txtChc5.text = self.arrOptionsChoice2[i] as? String
                        case 5 :
                            self.option2txtChc6.isHidden = false
                            self.option2txtChc6.text = self.arrOptionsChoice2[i] as? String
                        case 6 :
                            self.option2txtChc7.isHidden = false
                            self.option2txtChc7.text = self.arrOptionsChoice2[i] as? String
                        case 7 :
                            self.option2txtChc8.isHidden = false
                            self.option2txtChc8.text = self.arrOptionsChoice2[i] as? String
                        case 8 :
                            self.option2txtChc9.isHidden = false
                            self.option2txtChc9.text = self.arrOptionsChoice2[i] as? String
                            
                        default:
                            print("Something Wrong")
                        }
                    }
                }
                
                    if self.arrOptionsChoice1.count > self.arrOptionsChoice2.count {
                        
                        self.viewTxtOpt1Height.constant = CGFloat(self.viewOptionHeight*(self.arrOptionsChoice1.count+1))
                    }else{
                        self.viewTxtOpt1Height.constant = CGFloat(self.viewOptionHeight*(self.arrOptionsChoice2.count+1))
                    }
    
                let para = NSMutableDictionary()
                let prodArray1 = NSMutableArray()
                let prodArray2 = NSMutableArray()
                
                switch self.strOptionsCount
                {
                case 1:
                    for i in 0..<self.arrOptionsChoice1.count
                    {
                        let prod: NSMutableDictionary = NSMutableDictionary()
                        prod.setValue(self.arrOptionsChoice1[i], forKey: "name")
                        prod.setValue(i, forKey: "id")
                        prodArray1.add(prod)
                    }
                    para.setObject(prodArray1, forKey: self.txtOpt1.text! as NSCopying)
                case 2:
                    for i in 0..<self.arrOptionsChoice1.count
                    {
                        let prod: NSMutableDictionary = NSMutableDictionary()
                        prod.setValue(self.arrOptionsChoice1[i], forKey: "name")
                        prod.setValue(i, forKey: "id")
                        prodArray1.add(prod)
                    }
                    for i in 0..<self.arrOptionsChoice2.count
                    {
                        let prod: NSMutableDictionary = NSMutableDictionary()
                        prod.setValue(self.arrOptionsChoice2[i], forKey: "name")
                        prod.setValue(i, forKey: "id")
                        prodArray2.add(prod)
                    }
                    para.setObject(prodArray1, forKey: self.txtOpt1.text! as NSCopying)
                    para.setObject(prodArray2, forKey: self.txtOpt2.text! as NSCopying)
                    
                default:
                    print("Check with count")
                }
                
                let data = try? JSONSerialization.data(withJSONObject: para, options: [])
            
                self.strSpecifications = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
               
            }
            
        }
    }
    
    
    
    func configurePageControl()
    {
      
        var sdWebImageSource = [SDWebImageSource]()
        for index in 0..<self.arrProductImages.count
        {
            let image =  self.arrProductImages[index]
            sdWebImageSource.append(SDWebImageSource.init(url: URL(string: image)!, placeholder:UIImage(named: "productPlaceholder")))
        }
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = NAVIGATION_COLOR
        pageControl.pageIndicatorTintColor = APP_COLOR
        pageControl.isEnabled = false
        self.bannersSlideShow.pageIndicator = pageControl
        self.bannersSlideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        self.bannersSlideShow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToEditImages(_:)))
        
        self.bannersSlideShow.addGestureRecognizer(recognizer)
        
        
    }
    
    
    @objc func goToEditImages(_ sender: UIButton?) {
        
        // move to image edit page
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditImagesViewController") as! EditImagesViewController

        productDataDic["api_key_data"] = WebServices.API_KEY
        productDataDic["type"] = self.type
        productDataDic["user_id"] = merchantId
        productDataDic["product_id"] = ProductId
        productDataDic["phone_number"] = merchantPhoneNumber
        productDataDic["specifications"] = strSpecifications
        productDataDic["category"] = self.catagoryId
        productDataDic["tags_name"] = self.str
        productDataDic["tags"] =  self.tagId
        productDataDic["tags_position"] = self.tagPositions
        productDataDic["environment"] = "ios"
//
        if self.type == PRODUCT {

            productDataDic["product_name"] = txtProductName.text!
            productDataDic["quantity"] = txtMaxQuantity.text!
            productDataDic["rates"] = txtProductRate.text!
            productDataDic["description"] = txtviewProductDescription.text!
            productDataDic["product_details"] = txtviewProductDetails.text!
            productDataDic["category_position"] = self.strCategoryPosition
            productDataDic["minimum_days"] = txtMinimumDays.text!
            productDataDic["product_fee"] = txtProductFee.text!
            productDataDic["product_care"] = txtviewProductCare.text!

        }else{

            productDataDic["product_name"] = self.txtVenuneName.text!
            productDataDic["rates"] = txtVenueRate.text!
            productDataDic["product_details"] = txtAboutVenue.text!
            productDataDic["description"] = venueAdditionalInfo.text!
            productDataDic["environment"] = "ios"
            productDataDic["advance_booking_date"] = txtBookingDate.text!
            productDataDic["booking_duration"] = txtVenueBookingDuation.text!
            productDataDic["product_care"] = txtVenueUsage.text!
        }

        vc.imagesEditDataDic = productDataDic
        vc.product_id = self.ProductId!
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
   
    
    
    @objc func checkWithImagesChecking(sender:UITapGestureRecognizer)
    {
//        let imageview:UIImageView = (sender.view as? UIImageView)!;
//
//        imagePlaceholder = UIImage(named: "addImgSmall")!
//
//        if (imageview.image == imagePlaceholder)
//        {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        else
//        {
        
//            if editItem {
            
                // move to image edit page
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditImagesViewController") as! EditImagesViewController
                
//                vc.image1 = self.imgProduct1.image
//                vc.image2 = self.imgProduct2.image
//                vc.image3 = self.imgProduct3.image
//                vc.image4 = self.imgProduct4.image
//                vc.image5 = self.imgProduct5.image
//
//                vc.arr_changedfilePaths = self.arr_selectedfilePaths
//                vc.arrchangedbase64Images = self.arrbase64Images
//
//                productDataDic["api_key_data"] = WebServices.API_KEY
//                productDataDic["type"] = self.type
//                productDataDic["user_id"] = merchantId
//                productDataDic["product_id"] = ProductId
//                productDataDic["phone_number"] = merchantPhoneNumber
//                productDataDic["specifications"] = strSpecifications
//                productDataDic["category"] = self.catagoryId
//                productDataDic["tags_name"] = self.str
//                productDataDic["tags"] =  self.tagId
//                productDataDic["tags_position"] = self.tagPositions
//                productDataDic["environment"] = "ios"
//
//
//                if self.type == PRODUCT {
//
//                    productDataDic["product_name"] = txtProductName.text!
//                    productDataDic["quantity"] = txtMaxQuantity.text!
//                    productDataDic["rates"] = txtProductRate.text!
//                    productDataDic["description"] = txtviewProductDescription.text!
//                    productDataDic["product_details"] = txtviewProductDetails.text!
//                    productDataDic["category_position"] = self.strCategoryPosition
//                    productDataDic["minimum_days"] = txtMinimumDays.text!
//                    productDataDic["product_fee"] = txtProductFee.text!
//                    productDataDic["product_care"] = txtviewProductCare.text!
//
//                }else{
//
//                    
//                    productDataDic["product_name"] = self.txtVenuneName.text!
//                    productDataDic["rates"] = txtVenueRate.text!
//                    productDataDic["product_details"] = txtAboutVenue.text!
//                    productDataDic["description"] = venueAdditionalInfo.text!
//                    productDataDic["environment"] = "ios"
//                    productDataDic["advance_booking_date"] = txtBookingDate.text!
//                    productDataDic["booking_duration"] = txtVenueBookingDuation.text!
//                    productDataDic["product_care"] = txtVenueUsage.text!
//                }
//
//                vc.productEditDataDic = productDataDic
                vc.product_id = self.ProductId!
                self.navigationController?.pushViewController(vc, animated: false)
//            }
//            else{
//                let otherAlert = UIAlertController(title:APP_NAME, message: "Are you sure you want Delete?", preferredStyle: UIAlertControllerStyle.alert)
//
//                let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
//
//                let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:
//                {(alert: UIAlertAction!) in
//
//                    self.arr_selectedImages.remove(at: imageview.tag-1)
//                    self.arr_selectedfilePaths.remove(at: imageview.tag-1)
//                    self.checkWithImages()
//                })
//                otherAlert.addAction(okAction)
//                otherAlert.addAction(deleteAction)
//                present(otherAlert, animated: true, completion: nil)
//            }
            
            
            
            
            
//        }
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
        
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAllCategories(ListType : String)
    {
        
        let Dict = ["api_key_data":WebServices.API_KEY, "type" : self.type]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_ALL_CATAGORIES, params: Dict) { (result, success) in
            self.txtVenueOrServiceCategory.text = ""
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.arrCatagoryids.removeAll()
                self.arrCatagoryNames.removeAll()
                
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary:[String:Any]? = resultDictionary["data"] as? [String:Any]
                self.arrCatagorydata = dataDictionary!["category"] as! [AnyObject]
                
                for catagorydata in self.arrCatagorydata
                {
                    
                    self.arrCatagoryids.append(catagorydata["id"] as AnyObject)
                    self.arrCatagoryNames.append(catagorydata["name"] as AnyObject)
                    
                }
                
                self.arrTagsdata = dataDictionary!["tags"] as! [AnyObject]
                
                for tagsdata in self.arrTagsdata
                {
                    self.arrTagids.append(tagsdata["id"] as AnyObject)
                    self.arrTagName.append(tagsdata["name"] as AnyObject)
                }
                self.tagsTV.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTagName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        
        cell!.textLabel?.text = self.arrTagName[indexPath.row] as? String
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell!.accessoryType = rowIsSelected ? .checkmark : .none
        
        cell?.textLabel?.textColor = UIColor.init(hexString: "#4A4A4A")
        cell?.backgroundColor = UIColor.init(hexString: "#F5F5F5")
        cell?.textLabel?.textAlignment = .center
        
        return cell!
        
    }
    
    var str : String! = ""
    var tagId : String! = ""
    var tagPositions : String! = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        cell.selectionStyle = .none
        self.selectedArr.append(self.arrTagName[indexPath.row] as! String)
        self.tagsArr.append(self.arrTagids[indexPath.row] as! String)
        
        self.tagsPositionsArr.append(String(indexPath.row))
     
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
      
        
//        if indexPath.row >= self.selectedArr.count {
//            selectedArr.remove(at: indexPath.row - self.selectedArr.count)
//            tagsArr.remove(at: indexPath.row - self.tagsArr.count)
//            self.tagsPositionsArr.remove(at: indexPath.row - tagsPositionsArr.count)
//        }else{
        
//        print(self.selectedArr.count)
//        for _ in 0..<self.selectedArr.count {
//            self.chipField.removeChip(chipView)
//            self.chipView.removeFromSuperview()
//            self.chipField.deselectAllChips()
//        }
//
        
        
            selectedArr.remove(at: indexPath.row)
            tagsArr.remove(at: indexPath.row)
            self.tagsPositionsArr.remove(at: indexPath.row)
       
        selectedArr.removeAll()
        tagsArr.removeAll()
        tagsPositionsArr.removeAll()
        
        
       removeTag()
        
        
        
        
        
       
        tagsTV.reloadData()
//    }
        
//         self.chipView.removeFromSuperview()
        
    }
    
    @IBAction func btnCatagoriesTapped(_ sender: UIButton)
    {
        
        ActionSheetStringPicker.show(withTitle: "Choose Catagory", rows: self.arrCatagoryNames as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                if self.type == PRODUCT {
                    self.txtItemCatagory.text = index as? String
                }
                else{
                    self.txtVenueOrServiceCategory.text = index as? String
                }
                
                self.catagoryId = self.arrCatagoryids[value] as! String
                self.strCategoryPosition = String(value)
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    
    @IBAction func listMyItemTapped()
    {
        self.view.endEditing(true)
        
        if arrProductImages.count == 0
        {
            showAlert(message: "Please upload images")
            return
        }
        if self.type == PRODUCT {
            
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
            
            if (txtviewProductDetails.text?.isEmpty)! || txtviewProductDetails.text == ""
            {
                showAlert(message: "Please enter Product Description")
                txtviewProductDetails.becomeFirstResponder()
                return
            }
          
            if (txtItemCatagory.text?.isEmpty)! || txtItemCatagory.text == ""
            {
                showAlert(message: "Please Select Product Catagory")
                return
            }
            if txtOpt1.text != ""
            {
                if (option1txtChc1.text?.isEmpty)! &&  (option1txtChc2.text?.isEmpty)! && (option1txtChc3.text?.isEmpty)!
                {
                    showAlert(message: "Please enter Choices")
                    return
                }
                else
                {
                    if  option1txtChc1.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc1.text as Any)
                    }
                    if  option1txtChc2.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc2.text as Any)
                    }
                    if  option1txtChc3.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc3.text as Any)
                    }
                    if  option1txtChc4.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc4.text as Any)
                    }
                    if  option1txtChc5.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc5.text as Any)
                    }
                    if  option1txtChc6.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc6.text as Any)
                    }
                    if  option1txtChc7.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc7.text as Any)
                    }
                    if  option1txtChc8.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc8.text as Any)
                    }
                    if  option1txtChc9.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc9.text as Any)
                    }
                }
            }
            if  txtOpt2.text != ""
            {
                if (option2txtChc1.text?.isEmpty)! &&  (option2txtChc2.text?.isEmpty)! && (option2txtChc3.text?.isEmpty)!
                {
                    showAlert(message: "Please enter Choices")
                    return
                }
                else
                {
                    if option2txtChc1.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc1.text as Any)
                    }
                    if  option2txtChc2.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc2.text as Any)
                    }
                    if  option2txtChc3.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc3.text as Any)
                    }
                    if  option2txtChc4.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc4.text as Any)
                    }
                    if  option2txtChc5.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc5.text as Any)
                    }
                    if  option2txtChc6.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc6.text as Any)
                    }
                    if  option2txtChc7.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc7.text as Any)
                    }
                    if  option2txtChc8.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc8.text as Any)
                    }
                    if  option2txtChc9.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc9.text as Any)
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
            productDataDic["phone_number"] = merchantPhoneNumber
            productDataDic["user_id"] = merchantId
            productDataDic["product_name"] = txtProductName.text!
            productDataDic["specifications"] = strSpecifications!
            productDataDic["quantity"] = txtMaxQuantity.text!
            productDataDic["rates"] = txtProductRate.text!
            productDataDic["description"] = txtviewProductDescription.text!
            productDataDic["product_details"] = txtviewProductDetails.text!
            productDataDic["category"] = self.catagoryId
            productDataDic["category_position"] = self.strCategoryPosition
            productDataDic["environment"] = "ios"
            productDataDic["minimum_days"] = txtMinimumDays.text!
            productDataDic["product_fee"] = txtProductFee.text!
            productDataDic["product_care"] = txtviewProductCare.text!
            productDataDic["type"] = self.type
            productDataDic["tags"] = self.tagId
            productDataDic["tags_position"] = self.tagPositions
            productDataDic["tags_name"] = self.str
            productDataDic["product_id"] = ProductId
            
            
            self.view.StartLoading()
            
           
//            if editItem {
            
                ApiManager().postRequest(service: WebServices.MERCHANT_EDIT_ITEM, params: productDataDic) { (result, success) in
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
                        if self.editItem {
                            let successClass = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                            
                            self.navigationController?.pushViewController(successClass, animated: false)
                        }else{
                            let resultDictionary = result as! [String : Any]
                            let title = resultDictionary["message"] as? String
                            let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                            successClass.strTitle = title!
                            successClass.strMessage = ""
                            self.navigationController?.pushViewController(successClass, animated: false)
                        }
                        
                    }
                }
                
                
                
                
//            }
//            else{
//
//                ApiManager().postRequest(service: WebServices.CREATE_PRODUCT, params: productDataDic) { (result, success) in
//                    self.view.StopLoading()
//                    if success == false
//                    {
//                        self.arrOptionsChoice1.removeAllObjects()
//                        self.arrOptionsChoice2.removeAllObjects()
//                        self.showAlert(message: result as! String)
//                        return
//                    }
//                    else
//                    {
//                        let resultDictionary = result as! [String : Any]
//                        let title = resultDictionary["message"] as? String
//                        let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
//                        successClass.strTitle = title!
//                        successClass.strMessage = ""
//                        self.navigationController?.pushViewController(successClass, animated: false)
//                    }
//                }
//            }
    
        }else {
            // Venue type or service type
            
            if (txtVenuneName.text?.isEmpty)! || txtVenuneName.text == ""
            {
                if self.type == VENUE {
                    showAlert(message: "Please enter Venue Name")
                }else{
                    showAlert(message: "Please enter Service Name")
                }
                
                txtVenuneName.becomeFirstResponder()
                return
            }
            if (txtBookingDate.text?.isEmpty)! || txtBookingDate.text == ""
            {
                showAlert(message: "Please enter Booking Date")
                txtBookingDate.becomeFirstResponder()
                return
            }
            
            if (txtVenueRate.text?.isEmpty)! || txtVenueRate.text == ""
            {
                showAlert(message: "Please enter Rate Per Day")
                txtVenueRate.becomeFirstResponder()
                return
            }
            if (txtVenueBookingDuation.text?.isEmpty)! || txtVenueBookingDuation.text == ""
            {
                showAlert(message: "Please enter Booking Duration")
                txtVenueBookingDuation.becomeFirstResponder()
                return
            }
            
            //            if (txtVenueUsage.text?.isEmpty)! || txtVenueUsage.text == ""
            //            {
            //                if self.type == "2" {
            //                    showAlert(message: "Please enter venue usage")
            //                }else{
            ////                    showAlert(message: "Please enter service usage")
            //                }
            //                txtVenueUsage.becomeFirstResponder()
            //                return
            //            }
            if (venueAdditionalInfo.text?.isEmpty)! || venueAdditionalInfo.text == ""
            {
                showAlert(message: "Please enter additional Info")
                venueAdditionalInfo.becomeFirstResponder()
                return
            }
            
            if txtOpt1.text != ""
            {
                if (option1txtChc1.text?.isEmpty)! &&  (option1txtChc2.text?.isEmpty)! && (option1txtChc3.text?.isEmpty)!
                {
                    showAlert(message: "Please enter Choices")
                    return
                }
                else
                {
                    if  option1txtChc1.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc1.text as Any)
                    }
                    if  option1txtChc2.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc2.text as Any)
                    }
                    if  option1txtChc3.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc3.text as Any)
                    }
                    if  option1txtChc4.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc4.text as Any)
                    }
                    if  option1txtChc5.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc5.text as Any)
                    }
                    if  option1txtChc6.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc6.text as Any)
                    }
                    if  option1txtChc7.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc7.text as Any)
                    }
                    if  option1txtChc8.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc8.text as Any)
                    }
                    if  option1txtChc9.text != ""
                    {
                        arrOptionsChoice1.add(option1txtChc9.text as Any)
                    }
                }
            }
            if  txtOpt2.text != ""
            {
                if (option2txtChc1.text?.isEmpty)! &&  (option2txtChc2.text?.isEmpty)! && (option2txtChc3.text?.isEmpty)!
                {
                    showAlert(message: "Please enter Choices")
                    return
                }
                else
                {
                    if option2txtChc1.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc1.text as Any)
                    }
                    if  option2txtChc2.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc2.text as Any)
                    }
                    if  option2txtChc3.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc3.text as Any)
                    }
                    if  option2txtChc4.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc4.text as Any)
                    }
                    if  option2txtChc5.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc5.text as Any)
                    }
                    if  option2txtChc6.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc6.text as Any)
                    }
                    if  option2txtChc7.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc7.text as Any)
                    }
                    if  option2txtChc8.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc8.text as Any)
                    }
                    if  option2txtChc9.text != ""
                    {
                        arrOptionsChoice2.add(option2txtChc9.text as Any)
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
            productDataDic["type"] = self.type
            productDataDic["user_id"] = merchantId
            productDataDic["product_id"] = ProductId
            productDataDic["phone_number"] = merchantPhoneNumber
            productDataDic["product_name"] = self.txtVenuneName.text!
            productDataDic["tags"] =  self.tagId
            productDataDic["tags_position"] = self.tagPositions
            productDataDic["tags_name"] = self.str
            productDataDic["rates"] = txtVenueRate.text!
            productDataDic["product_details"] = txtAboutVenue.text!
            productDataDic["description"] = venueAdditionalInfo.text!
            productDataDic["category"] = self.catagoryId
            productDataDic["specifications"] = strSpecifications!
            productDataDic["environment"] = "ios"
            productDataDic["advance_booking_date"] = txtBookingDate.text!
            productDataDic["booking_duration"] = txtVenueBookingDuation.text!
            productDataDic["product_care"] = txtVenueUsage.text!
            
            /// service integration...
            self.view.StartLoading()
            
            
            
            
//            if editItem {
            
                ApiManager().postRequest(service: WebServices.MERCHANT_EDIT_ITEM, params: productDataDic) { (result, success) in
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
                        if self.editItem {
                            let successClass = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                            self.navigationController?.pushViewController(successClass, animated: false)
                        }else{
                            let resultDictionary = result as! [String : Any]
                            let title = resultDictionary["message"] as? String
                            let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                            successClass.strTitle = title!
                            successClass.strMessage = ""
                            self.navigationController?.pushViewController(successClass, animated: false)
                        }
                      
                    }
                }
                
//            }
//
//            else {
//
//                ApiManager().postRequest(service: WebServices.CREATE_PRODUCT, params: productDataDic) { (result, success) in
//                    self.view.StopLoading()
//                    if success == false
//                    {
//                        self.showAlert(message: result as! String)
//                        return
//                    }
//                    else
//                    {
//                        let resultDictionary = result as! [String : Any]
//                        let title = resultDictionary["message"] as? String
//                        let successClass = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
//                        successClass.strTitle = title!
//                        successClass.strMessage = ""
//                        self.navigationController?.pushViewController(successClass, animated: false)
//                    }
//                }
//            }
        }
    }
    
    @IBAction func btn_choose_rentalDays_tapped(sender:UIButton) {
        
        var arrbaseMinimumRentalDays = [Int]()
        for index in 1...10
        {
            arrbaseMinimumRentalDays.append(index)
        }
        ActionSheetStringPicker.show(withTitle: durationStr, rows: arrbaseMinimumRentalDays as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                if self.type == PRODUCT {
                    self.txtMinimumDays.text = " \(String(describing: index!))"
                    
                }else if self.type == VENUE ||  self.type == SERVICE  {
                    self.txtVenueBookingDuation.text = " \(String(describing: index!))"
                }
                
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
                option1txtChc1.isHidden = false
            }
        case 2:
            if (option1txtChc1.text?.isEmpty)! || option1txtChc1.text == ""
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
                option1txtChc2.isHidden = false
                
            }
        case 3:
            if (option1txtChc2.text?.isEmpty)! || option1txtChc2.text == ""
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
                option1txtChc3.isHidden = false
            }
        case 4:
            if (option1txtChc3.text?.isEmpty)! || option1txtChc3.text == ""
            {
                print("not tapped")
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
                option1txtChc4.isHidden = false
            }
        case 5:
            if (option1txtChc4.text?.isEmpty)! || option1txtChc4.text == ""
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
                option1txtChc5.isHidden = false
            }
        case 6:
            if (option1txtChc5.text?.isEmpty)! || option1txtChc5.text == ""
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
                option1txtChc6.isHidden = false
            }
        case 7:
            if (option1txtChc6.text?.isEmpty)! || option1txtChc6.text == ""
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
                option1txtChc7.isHidden = false
            }
            
        case 8:
            if (option1txtChc7.text?.isEmpty)! || option1txtChc7.text == ""
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
                option1txtChc8.isHidden = false
            }
        case 9:
            if (option1txtChc8.text?.isEmpty)! || option1txtChc8.text == ""
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
                option1txtChc9.isHidden = false
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
                option2txtChc1.isHidden = false
                strChoicesCount2 += 1
                strOptionsCount += 1
                
            }
        case 2:
            if  (option2txtChc1.text?.isEmpty)! || option2txtChc1.text == ""
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
                option2txtChc2.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 3:
            if  (option2txtChc2.text?.isEmpty)! || option2txtChc2.text == ""
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
                option2txtChc3.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 4:
            if  (option2txtChc3.text?.isEmpty)! || option2txtChc3.text == ""
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
                option2txtChc4.isHidden = false
                strChoicesCount2 += 1
            }
        case 5:
            if  (option2txtChc4.text?.isEmpty)! || option2txtChc4.text == ""
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
                option2txtChc5.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 6:
            if  (option2txtChc5.text?.isEmpty)! || option2txtChc5.text == ""
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
                option2txtChc6.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 7:
            if  (option2txtChc6.text?.isEmpty)! || option2txtChc6.text == ""
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
                option2txtChc7.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 8:
            if  (option2txtChc7.text?.isEmpty)! || option2txtChc7.text == ""
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
                option2txtChc8.isHidden = false
                strChoicesCount2 += 1
                
            }
        case 9:
            if  (option2txtChc8.text?.isEmpty)! || option2txtChc8.text == ""
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
                option2txtChc9.isHidden = false
                strChoicesCount2 += 1
            }
        default:
            print("Something Wrong")
        }
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    @objc func backvc()
    {
        self.navigationController?.popViewController(animated: true)
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == txtviewProductDetails
        {
            let newText = (txtviewProductDetails.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                txtviewProductDetails.resignFirstResponder()
                showAlert(message: "You can able enter max 500 Characters")
                return false
            }
        }
        if textView == txtviewProductCare
        {
            let newText = (txtviewProductCare.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                txtviewProductCare.resignFirstResponder()
                showAlert(message: "You can able enter max 500 Characters")
                return false
            }
        }
        if textView == txtviewProductDescription
        {
            let newText = (txtviewProductDescription.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                txtviewProductDescription.resignFirstResponder()
                showAlert(message: "You can able enter max 500 Characters")
                return false
            }
        }
        
        if textView == txtAboutVenue
        {
            let newText = (txtAboutVenue.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                txtAboutVenue.resignFirstResponder()
                showAlert(message: "You can able enter max 500 Characters")
                return false
            }
        }
        
        if textView == txtVenueUsage
        {
            let newText = (txtVenueUsage.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count >= 501
            {
                txtVenueUsage.resignFirstResponder()
                showAlert(message: "You can able enter max 500 Characters")
                return false
            }
        }
        return true
    }
    
    @IBAction func selectTypeofOderTapped(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Choose Selection Type", rows:
            self.SelectionTypes as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                self.txtSelectedType.text = index as? String
                
                if value == 0 {
                    
                    self.productCreateView.isHidden = false
                    self.venueCreateView.isHidden = true
                    self.txtItemCatagory.text = ""
                    self.categoryDropdown.isHidden = false
                    self.durationStr = "Minimum Rental Days"
                    self.type = PRODUCT
                }
                else{
                    self.productCreateView.isHidden = true
                    self.venueCreateView.isHidden = false
                    
                    self.durationStr = "Minimum Rental Hours"
                    if value == 1 {
                        
                        self.type = VENUE
                        self.usageLbl.text = "Venue Usage"
                        
                    }else{
                        self.type = SERVICE
                        self.usageLbl.text = "Service Usage"
                    }
                }
                
                self.getAllCategories(ListType: self.type)
                self.orderView.isHidden = false
                return
                
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
        self.navigationController?.pushViewController(navigateToHome!, animated: false)
        
    }
    
    @objc func removeTag() {
        selectedArr.removeAll()
        if type == PRODUCT{
            createTagCloud(OnView: self.productTagsView, withArray: selectedArr as [AnyObject])
        }else {
            self.createTagCloud(OnView: self.venueTagsView, withArray: selectedArr as [AnyObject])
        }
        
    }
    
    
    func createTagCloud(OnView view: UIView, withArray data:[AnyObject]) {
        for tempView in view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        var xPos:CGFloat = 4.0
        var ypos: CGFloat = 6.0
        var tag: Int = 1
        for str in data  {
            let startstring = str as! String
            let width = startstring.widthOfString(usingFont: UIFont(name:"SFProDisplay-Regular", size: 13.0)!)
            let checkWholeWidth = CGFloat(xPos) + CGFloat(width) + CGFloat(13.0) + CGFloat(25.5 )//13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
            if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                //we are exceeding size need to change xpos
                xPos = 15.0
                ypos = ypos + 29.0 + 8.0
            }
            let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:width + 38.5 , height: 25.0))
            bgView.layer.cornerRadius = 12.0
            bgView.backgroundColor = APP_COLOR
            bgView.tag = tag
            let textlable = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            textlable.font = UIFont(name: "SFProDisplay-Regular", size: 13.0)
            textlable.text = startstring
            textlable.textColor = UIColor.white
            bgView.addSubview(textlable)
//            let button = UIButton(type: .custom)
//            button.frame = CGRect(x: bgView.frame.size.width - 2.5 - 23.0, y: 3.0, width: 23.0, height: 23.0)
//            button.backgroundColor = UIColor.white
//            button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
//            button.setImage(UIImage(named: "CrossWithoutCircle"), for: .normal)
//            button.tag = tag
//            button.addTarget(self, action: #selector(removeTag), for: .touchUpInside)
//            bgView.addSubview(button)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(43.0)
            
            if type == PRODUCT {
                  productTagsView.addSubview(bgView)
            }else{
                venueTagsView.addSubview(bgView)
            }
          
            tag = tag  + 1
        }
    }
    
    var alertController = UIAlertController()
    
    @IBAction func selectTags_Tapped(_ sender: Any) {
     
        
        if self.arrTagName.count > 0 {
            
            alertController = UIAlertController(title: "Select Tags", message: nil, preferredStyle: .actionSheet)
            alertController.view.addSubview(tagsTV)
            
            tagsTV.translatesAutoresizingMaskIntoConstraints = false
            tagsTV.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
            tagsTV.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
            tagsTV.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
            tagsTV.heightAnchor.constraint(equalToConstant: 130).isActive = true
            
            alertController.view.translatesAutoresizingMaskIntoConstraints = false
            alertController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            tagsTV.backgroundColor = .white
          
            let selectAction = UIAlertAction(title: "Select", style: .default) {(alert: UIAlertAction!) in
                
                
//                if self.selectedArr.count == 0 {
//                    self.chipField.removeSelectedChips()
//                    self.chipView.removeFromSuperview()
//                    self.chipField.deselectAllChips()
//                }
//
                 if self.selectedArr.count > 0 {
                   
                     if self.type == PRODUCT {                        self.createTagCloud(OnView: self.productTagsView, withArray: self.selectedArr as [AnyObject])
                     }else{
                        self.createTagCloud(OnView: self.venueTagsView, withArray: self.selectedArr as [AnyObject])
                    }
                    
                    self.txtTagsSelected.placeholder = ""
                    self.txtVenueTags.placeholder = ""
                  
                    self.str = self.selectedArr.joined(separator: ",")
                    self.tagId = self.tagsArr.joined(separator: ",")
                    self.tagPositions = self.tagsPositionsArr.joined(separator: ",")
                    
//                    self.txtTagsSelected.text = self.str
                    self.txtTagsSelected.resignFirstResponder()
//                    self.txtVenueTags.text = self.str
                    self.txtVenueTags.resignFirstResponder()
                  
                    
                }else{
                    self.txtTagsSelected.placeholder = "Select Tags"
                    self.txtVenueTags.placeholder = "SelectTags"
                    self.str = ""
                    self.tagId = ""
                    self.tagPositions = ""
               
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
            alertController.view.tintColor = APP_COLOR
            
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)

        }else{
            self.showAlert(message: "No Tags Available")
        }
    }
    
}
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
