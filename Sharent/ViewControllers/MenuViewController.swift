//
//  MenuViewController.swift
//  Sharent
//
//  Created by Biipbyte on 04/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    //Buyer
    var arrBuyerMenuImages = [String]()
    var arrBuyerMenuTitles = [String]()
    var arrBuyerMenuClassesIds = [String]()
    
    // Marchant
    
    var arrMarchantMenuImages = [String]()
    var arrMarchantMenuTitles = [String]()
    var arrMarchantMenuClassesIds = [String]()
    
    var userLoginType : String? = ""
    var userId :String? = ""
    var userImage : String? = ""
    var userName : String? = ""
    var userFcmToken : String? = ""
    var merchantCompany : String? = ""

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
        
        lblPersonCompany.text = nil
        
        arrBuyerMenuTitles = ["Home","My Booking","My Account","Help","Logout"]
        arrBuyerMenuImages = ["IconMenuHome","IconMenuMyBookings","IconMenuMyAccount","IconMenuHelp","IconMenuLogout"]
        arrBuyerMenuClassesIds = ["HomeViewController","MyBookingsViewController","MyAccountViewController","HelpViewController","logout"]
        
        arrMarchantMenuTitles = ["My Inventory","My Booking","My Account","Help","Logout"]
        arrMarchantMenuImages = ["IconMenuHome","IconMenuMyBookings","IconMenuMyAccount","IconMenuHelp","IconMenuLogout"]
        arrMarchantMenuClassesIds = ["MerchantHomeViewController","MyBookingsViewController","MyAccountViewController","HelpViewController","logout"]
        
        
        
        
        userImage = UserDefaults.standard.value(forKey: "userImage")as? String
        userName = UserDefaults.standard.value(forKey: "userName")as? String
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userFcmToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        merchantCompany = UserDefaults.standard.value(forKey: "company") as? String
        
        if userId != nil
        {
            
            lblPersonName.text = userName
            let image =  String("\(WebServices.BASE_URL)\(userImage ?? "")")
            imagePerson?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
            
            if userLoginType == UserType.MERCHANT
            {
                lblPersonCompany.text = merchantCompany
            }
    
        }
            
        else
        {
            arrBuyerMenuTitles[4] = "Login"
            arrBuyerMenuImages[4] = "login"
            
            imagePerson.image = UIImage(named: "userplaceholder")
            lblPersonName.text = "Guest User"
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if userLoginType == UserType.BUYER || userId == nil
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
        
        if userLoginType == UserType.BUYER || userId == nil
        {
            
            cell.lblTitleMenu.text = "\(arrBuyerMenuTitles[indexPath.row])"
            cell.imageMenu.image = UIImage(named: "\(arrBuyerMenuImages[indexPath.row])")
            
        }
        else
        {
            cell.lblTitleMenu.text = "\(arrMarchantMenuTitles[indexPath.row])"
            cell.imageMenu.image = UIImage(named: "\(arrMarchantMenuImages[indexPath.row])")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if userId == nil
        {
            
            switch indexPath.row
            {
            case 0 :
                pushViewControllers(index: indexPath.row)
                
            case 1...2:
                showAlert(message: "Please login to continue")
            case 4:
                let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(initialVc, animated: true, completion: nil)
                break
                
            default:
                pushViewControllers(index: indexPath.row)
                
                return
            }
            
        }
        else
        {
            
            if userLoginType == UserType.BUYER
            {
                switch indexPath.row
                {
                case 4:
                    
                    UserDefaults.standard.set(nil, forKey: "user_id")
                    UserDefaults.standard.set(nil, forKey: "userName")
                    UserDefaults.standard.set(nil, forKey: "userImage")
                    UserDefaults.standard.set(nil, forKey: "user_type")
                    
                    fcmDeregistration()
                    
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                    
                default:
                    fcmRegistration()
                    pushViewControllers(index: indexPath.row)
                    return
                    
                }
            }
            else
            {
                switch indexPath.row
                {
                case 4:
                    
                    UserDefaults.standard.set(nil, forKey: "user_id")
                    UserDefaults.standard.set(nil, forKey: "userName")
                    UserDefaults.standard.set(nil, forKey: "userImage")
                    UserDefaults.standard.set(nil, forKey: "user_type")
                    
                    fcmDeregistration()
                    
                    let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
                    self.present(navigateToHome!, animated: true, completion: nil)
                    
                default:
                    fcmDeregistration()
                    pushViewControllers(index: indexPath.row)
                    
                    return
                }
            }
            
        }
        
        
        
    }
    
    func pushViewControllers(index:Int)
    {
        let navigationController = sideMenuController?.rootViewController as! UINavigationController
        
        var vcClassId = String()
        
        if userLoginType == UserType.BUYER || userId == nil
        {
            vcClassId = "\(arrBuyerMenuClassesIds[index])"
            
        }
        else
        {
            vcClassId = "\(arrMarchantMenuClassesIds[index])"
            
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier:vcClassId)
        navigationController.pushViewController(controller!, animated: false)
        sideMenuController?.hideLeftView(animated: true, completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return menuTableview.frame.size.height/8
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
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
