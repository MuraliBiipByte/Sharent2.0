//
//  MyAccountViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMerchantCompanyName: UILabel!
    
    @IBOutlet weak var tblProfileList: UITableView!
    @IBOutlet weak var tblHight: NSLayoutConstraint!
    
    @IBOutlet weak var profileView: UIView!
    var arrProfileTitles = [String]()
    var arrProfileIdentifiers = [String]()
    
    var userLoginType : String? = ""
    var userId :String? = ""
    var userName = String()
    
    
    let arrBuyerProfileTitles = ["Favourites","Edit Profile","Change Password"]
    let arrBuyerProfileIdentifiers = ["MyFavouriteViewController","EditAccountViewController","ChangePasswordViewController"]
    
    
    let arrMerchantProfileTitles = ["Edit Profile","My Revenue","Change Password"]
    let arrMerchantProfileIdentifiers = ["EditProfileMerchantViewController","MyRevenueViewController","ChangePasswordViewController"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        profileView.layer.cornerRadius = 5.0
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOpacity = 0.5
        profileView.layer.shadowOffset = CGSize.zero
        profileView.layer.shadowRadius = 3
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // No need for semicolon
        
        
        self.title = "My Account"
        
        scrollView.isHidden = true
        
        getUserDetails()
        
        if userLoginType == UserType.BUYER
        {
            arrProfileTitles = arrBuyerProfileTitles
            arrProfileIdentifiers = arrBuyerProfileIdentifiers
        }
        else
        {
            arrProfileTitles = arrMerchantProfileTitles
            arrProfileIdentifiers = arrMerchantProfileIdentifiers
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.width/2
        imgProfile.layer.masksToBounds = true
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrProfileTitles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (tableView.contentSize.height < tableView.frame.size.height)
        {
            
            self.tblProfileList.isScrollEnabled = false
        }
        else
        {
            
            self.tblProfileList.isScrollEnabled = true
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell")as! MenuTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        cell.lblProfileListName.text = arrProfileTitles[indexPath.row]
        tblHight.constant = tableView.contentSize.height
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controllerId = arrProfileIdentifiers[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: controllerId)
        viewController?.title = arrProfileTitles[indexPath.row]
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    @IBAction func btnHome_Tapped(_ sender: Any)
    {
        
        UIView.animate(withDuration: 0.4, animations:{
            
            self.sideMenuController?.leftViewWidth = 280
            
            self.sideMenuController?.showLeftView(animated:true, completionHandler :self.callMenu)
            
        })
    }
    
    
    func callMenu ()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
        
    }
    
    func  getUserDetails()
    {
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        userId = UserDefaults.standard.value(forKey: "user_id") as? String
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":userLoginType!,"user_id":userId!]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_USERDETAILS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String )
                return
            }
            else
            {
                self.scrollView.isHidden = false
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary?["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                
                UserDefaults.standard.set(User.userID, forKey: "user_id")
                UserDefaults.standard.set(User.username, forKey: "userName")
                UserDefaults.standard.set(User.photouser, forKey: "userImage")
                UserDefaults.standard.set(User.usertype, forKey: "user_type")
                UserDefaults.standard.set(User.phone, forKey: "user-phone")
                UserDefaults.standard.set(User.usercompany, forKey: "company")
                UserDefaults.standard.set(User.useraddress, forKey: "address")
                UserDefaults.standard.set(User.userCity, forKey: "city")
                UserDefaults.standard.set(User.gender, forKey: "gender")
                UserDefaults.standard.set(User.latitude, forKey: "lat")
                UserDefaults.standard.set(User.longtitude, forKey: "lng")
                UserDefaults.standard.set(User.email, forKey: "email")
                
                
                self.lblName.text = User.username!
                let image =  String("\(WebServices.BASE_URL)\(String(describing: User.photouser ?? ""))")
                self.imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
                self.lblMerchantCompanyName.text = (User.usercompany ?? nil)
                
            }
        }
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
