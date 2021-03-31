//
//  MerchantHomeViewController.swift
//  ProductDetailsSharent
//
//  Created by Biipbyte on 07/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class MerchantHomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, FloatRatingViewDelegate, UITableViewDataSource,UITableViewDelegate
{
    
    
    var groupChannelListViewController: GroupChannelListViewController?
    
    weak var delegate: CreateGroupChannelSelectOptionViewControllerDelegate?
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var imgProfileMerchant:UIImageView!
//    @IBOutlet weak var btnAddProduct:UIButton!
    @IBOutlet weak var merchantView:UIView!
    
    @IBOutlet weak var lblMerchantName:UILabel!
    @IBOutlet weak var lblMerchantCompany:UILabel!
    @IBOutlet weak var listingTableView: UITableView!
   
    
    @IBOutlet weak var listingTableviewHeight: NSLayoutConstraint!
    
    
    var arrProducts = [AnyObject]()
    
    var userId :String? = ""
    var userLoginType : String? = ""
    var userFcmToken : String? = ""
    var userName : String? = ""
    var usercompany :String? = ""
    var userImage :String? = ""
    var merchantType :String? = ""
    
    // Merchant
    var arrMarchantMenuImages = [String]()
    var arrMarchantMenuTitles = [String]()
    var arrMarchantMenuClassesIds = [String]()
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.navigationItem.hidesBackButton = true
        self.title = "HOME"
        
        listingTableView.dataSource = self
        listingTableView.delegate = self
       
        listingTableView.tableFooterView = UIView();
        // Merchant
        
        arrMarchantMenuTitles = ["Create Listing","My Listings","Revenue","History","Chat","Edit Profile","Help","Logout"]
        
        arrMarchantMenuImages = ["iconCreateListing","iconMyListing","iconRevenue","iconTransaction","IconMenuChat","iconProfile","iconHelp","IconMenuLogout"]
        
        arrMarchantMenuClassesIds = ["CreateProductImagesViewController","ProductsViewController","MyRevenueViewController","MyBookingsViewController","Help","MyAccountViewController","HelpViewController","logout"]
      
        
        listingTableView.layer.shadowColor = UIColor.black.cgColor
        listingTableView.layer.shadowOpacity = 0.5
        listingTableView.layer.shadowOffset = CGSize.zero
        listingTableView.layer.shadowRadius = 3
        listingTableView.layer.cornerRadius = 4
        listingTableView.layer.masksToBounds = false
        
        
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        userName = UserDefaults.standard.value(forKey: "userName") as? String
        usercompany = UserDefaults.standard.value(forKey: "company") as? String
        userImage = UserDefaults.standard.value(forKey: "userImage")as? String
        merchantType = UserDefaults.standard.value(forKey: "merchantType") as? String
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userFcmToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String
      
        
        lblMerchantName.text = userName
        lblMerchantCompany.text = nil
        if merchantType != "3"
        {
            lblMerchantCompany.text = usercompany
        }
        
        merchantView.layer.shadowColor = UIColor.black.cgColor
        merchantView.layer.shadowOpacity = 0.5
        merchantView.layer.shadowOffset = CGSize.zero
        merchantView.layer.shadowRadius = 3
        
        let image =  String("\(WebServices.BASE_URL)\(userImage ?? "")")
        imgProfileMerchant?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
        imgProfileMerchant.layer.cornerRadius = imgProfileMerchant.frame.size.height/2
        imgProfileMerchant.layer.masksToBounds = true
        imgProfileMerchant.layer.borderWidth = 0.2
        imgProfileMerchant.layer.borderColor = NAVIGATION_COLOR.cgColor
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMarchantMenuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.lblTitleMenu.text = "\(arrMarchantMenuTitles[indexPath.row])"
        cell.imageMenu.image = UIImage(named: "\(arrMarchantMenuImages[indexPath.row])")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
         listingTableviewHeight.constant = CGFloat(arrMarchantMenuTitles.count * 64)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 1...2:
            if userId == nil
            {
                showAlert(message: "Please login to continue")
            }
            else
            {
                fcmRegistration()
                pushViewControllers(index: indexPath.row)
            }
            
        default:
            if userId != nil
            {
                fcmRegistration()
            }
            pushViewControllers(index: indexPath.row)
            return
        }
    }
    
    func pushViewControllers(index:Int)
    {
        let navigationController = sideMenuController?.rootViewController as! UINavigationController
        
        var vcClassId = String()
        
        
        if index == 7 {
            if userId != nil
            {
                UserDefaults.standard.set(nil, forKey: "user_id")
                UserDefaults.standard.set(nil, forKey: "userName")
                UserDefaults.standard.set(nil, forKey: "userImage")
                UserDefaults.standard.set(nil, forKey: "user_type")
                fcmDeregistration()
            }
            let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
            self.present(initialVc, animated: true, completion: nil)
            
        }
        else if index == 4 {
            
            ConnectionManager.login(userId: userId!, nickname: userName!) { (user, error) in
                DispatchQueue.main.async {
                    
                }
                
                guard error == nil else {
                    let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                    let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                    vc.addAction(closeAction)
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if self.groupChannelListViewController == nil {
                        self.groupChannelListViewController = GroupChannelListViewController(nibName: "GroupChannelListViewController", bundle: Bundle.main)
                        self.groupChannelListViewController?.addDelegates()
                    }
                    
                    self.present(self.groupChannelListViewController!, animated: false, completion: nil)
                }
            }
        }
        else{
            vcClassId = "\(arrMarchantMenuClassesIds[index])"
            let controller = self.storyboard?.instantiateViewController(withIdentifier:vcClassId)
            navigationController.pushViewController(controller!, animated: false)
            sideMenuController?.hideLeftView(animated: true, completionHandler: nil)
        }
        
    }
    
    func fcmRegistration()
    {
        let  userFcmToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY,"user_id":userId!,"fcm_regid":userFcmToken!, "user_type":userLoginType!,"type":"ios"]
        ApiManager().postRequest(service: WebServices.FCMREGISTRATION_USER, params: paramsDict)
        { (result, success) in
            
            print(result)
            
        }
    }
    
    func fcmDeregistration()
    {
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY,"user_id":userId!,"fcm_regid":userFcmToken!, "user_type":userLoginType!,"type":"ios"]
        ApiManager().postRequest(service: WebServices.FCMDEREGISTRATION_USER, params: paramsDict)
        { (result, success) in
            print(result)
        }
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
    

    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    
}
