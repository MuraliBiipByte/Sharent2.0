//
//  MenuViewController.swift
//  Sharent
//
//  Created by Biipbyte on 04/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import SendBirdSDK


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  
    //Buyer
    var arrBuyerMenuImages = [String]()
    var arrBuyerMenuTitles = [String]()
    var arrBuyerMenuClassesIds = [String]()
    
    // Merchant
    var arrMarchantMenuImages = [String]()
    var arrMarchantMenuTitles = [String]()
    var arrMarchantMenuClassesIds = [String]()
    
    var userLoginType : String? = ""
    var userId :String? = ""
    var userImage : String? = ""
    var userName : String? = ""
    var userFcmToken : String? = ""
    var merchantCompany : String? = ""
    var merchantType : String? = ""
    var cartCount : Int = 0
    
    @IBOutlet weak var lblPersonName:UILabel!
    @IBOutlet weak var imagePerson:UIImageView!
    @IBOutlet weak var lblPersonCompany:UILabel!
    
    @IBOutlet weak var menuTableview:UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
        
        imagePerson.layer.cornerRadius = imagePerson.frame.size.height/2
        imagePerson.layer.masksToBounds = true
        imagePerson.layer.borderWidth = 0.2
        imagePerson.layer.borderColor = NAVIGATION_COLOR.cgColor
      

        // Buyer
         arrBuyerMenuTitles = ["Home","Cart","Rental History", "Favourites","Payment Methods","FAQ","Settings","Logout"]
        
         arrBuyerMenuImages = ["HomeIcon","CartIcon","RentalHistory","favorite","PaymentMethods","FAQs","IconMenuSettings","IconMenuLogout"]
        
        arrBuyerMenuClassesIds = ["HomeViewController","CartListViewController","MyBookingsViewController","MyFavouriteViewController","CardListViewController","HelpViewController","MyAccountViewController","logout"]
        
         // Merchant
        arrMarchantMenuTitles = ["Home","Cart","Rental History", "Favourites","Payment Methods","FAQ","Settings","Logout"]
        arrMarchantMenuImages = ["HomeIcon","CartIcon","RentalHistory","favorite","PaymentMethods","FAQs","IconMenuSettings","IconMenuLogout"]
        arrMarchantMenuClassesIds = ["HomeViewController","CartListViewController","MyBookingsViewController","MyFavouriteViewController","CardListViewController","HelpViewController","MyAccountViewController","logout"]
        
        
       
        userImage = UserDefaults.standard.value(forKey: "userImage")as? String
        
        userName = UserDefaults.standard.value(forKey: "userName")as? String
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userFcmToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        merchantCompany = UserDefaults.standard.value(forKey: "company") as? String
        merchantType = UserDefaults.standard.value(forKey: "merchantType") as? String
        
        if userId != nil
        {
            
            lblPersonName.text = userName
            let image =  String("\(WebServices.BASE_URL)\(userImage ?? "")")
            
              UserDefaults.standard.set(image, forKey: "userImage")
            imagePerson?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
            lblPersonCompany.text = nil
            if userLoginType == MERCHANT
            {
                if merchantType != "3"
                {
                    lblPersonCompany.text = merchantCompany
                }
                else
                {
                    lblPersonCompany.text = nil
                }
            }
        }
            
        else
        {
            arrBuyerMenuTitles[4] = "Login"
            arrBuyerMenuImages[4] = "login"
            
            imagePerson.image = UIImage(named: "userplaceholder")
            lblPersonName.text = "Guest User"
            lblPersonCompany.text = nil
            
        }
          menuTableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        cartCount = UserDefaults.standard.value(forKey: "cart_count") as? Int ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if userLoginType == BUYER || userId == nil
        {
            
            return arrBuyerMenuTitles.count
            
        }
        else
        {
            return arrMarchantMenuTitles.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        if userLoginType == BUYER || userId == nil
        {
            
            cell.lblTitleMenu.text = "\(arrBuyerMenuTitles[indexPath.row])"
            cell.imageMenu.image = UIImage(named: "\(arrBuyerMenuImages[indexPath.row])")
         
            if indexPath.row == 1 {
                if cartCount != 0 {
                cell.lblCartCount.text = "\(cartCount)"
                cell.lblCartCount.isHidden = false
                 cell.lblCartCount.layer.cornerRadius = cell.lblCartCount.frame.size.width / 2
                cell.lblCartCount.layer.masksToBounds = true
                }else{
                     cell.lblCartCount.isHidden = true
                }
            }else{
                 cell.lblCartCount.isHidden = true
            }
            }
        else
        {
            
            cell.lblTitleMenu.text = "\(arrBuyerMenuTitles[indexPath.row])"
            cell.imageMenu.image = UIImage(named: "\(arrBuyerMenuImages[indexPath.row])")
            
            if indexPath.row == 1 {
                if cartCount != 0 {
                    cell.lblCartCount.text = "\(cartCount)"
                    cell.lblCartCount.isHidden = false
                    cell.lblCartCount.layer.cornerRadius = cell.lblCartCount.frame.size.width / 2
                    cell.lblCartCount.layer.masksToBounds = true
                }else{
                    cell.lblCartCount.isHidden = true
                }
            }else{
                cell.lblCartCount.isHidden = true
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
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
            case 7:
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
                break
                
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
        
        if userLoginType == BUYER || userId == nil
        {
            vcClassId = "\(arrBuyerMenuClassesIds[index])"
            let controller = self.storyboard?.instantiateViewController(withIdentifier:vcClassId)
            navigationController.pushViewController(controller!, animated: false)
            sideMenuController?.hideLeftView(animated: true, completionHandler: nil)
        }
        else
        {
            vcClassId = "\(arrBuyerMenuClassesIds[index])"
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
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
