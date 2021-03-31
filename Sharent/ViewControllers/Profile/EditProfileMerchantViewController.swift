//
//  EditProfileMerchantViewController.swift
//  Sharent
//
//  Created by Biipbyte on 03/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class EditProfileMerchantViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    
    @IBOutlet weak var imgProfileMerchant: UIImageView!
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var txtMerchantCompanyName: UITextField!
    @IBOutlet weak var txtMerchantID: UITextField!
    @IBOutlet weak var txtMerchanNricNo: UITextField!
    @IBOutlet weak var txtMerchanPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
   // @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var lblMerchantAddress: UILabel!
    
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var viewCompanyHeight: NSLayoutConstraint!
    
    var lat = String()
    var long = String()
    
    var profileImage = UIImage()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadMerchantDetails()
        
        txtMerchantID.isEnabled = false
        txtEmail.isEnabled = false
        txtMerchanPhoneNo.isEnabled = false
        txtMerchantCompanyName.isEnabled = false
        txtMerchanNricNo.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btn_Edit_profile_Tapped(_ sender: Any)
    {
        imagePicker.delegate = self
        
        let alert = UIAlertController(title:APP_NAME, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallary()
    {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        profileImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imgProfileMerchant.image = profileImage
        self.saveImage()
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btn_save_tapped()
    {
        self.view.endEditing(true)
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":User.userID!,"company":txtMerchantCompanyName.text!,"address":User.useraddress!,"nric":txtMerchanNricNo.text!,"lat":lat,"long":long]
        
        
        let urlString = WebServices.MERCHANT_EDIT_PROFILE
        self.view.StartLoading()
        ApiManager().editProfileSendRequest(service: urlString, image: profileImage, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String, selector:#selector(self.backVc))
                return
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary!["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!, selector:#selector(self.backVc))
            }
        }
        
        
    }
    func saveImage()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":User.userID!,"company":txtMerchantCompanyName.text!,"address":User.useraddress!,"nric":txtMerchanNricNo.text!,"lat":lat,"long":long,"type":User.merchantType!]
        
        
        let urlString = WebServices.MERCHANT_EDIT_PROFILE
        self.view.StartLoading()
        ApiManager().editProfileSendRequest(service: urlString, image: profileImage, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlertWithAction(message: result as! String, selector:#selector(self.backVc))
                return
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let userDataDictionary = dataDictionary!["userdata"] as? [String : Any]
                _ = User(userDictionay: userDataDictionary!)
                let message = resultDictionary["message"] as? String
                self.showAlertWithAction(message: message!, selector:#selector(self.backVc))
            }
        }
        
        
    }
    
    func loadMerchantDetails()
    {
        viewCompany.isHidden = true
        viewCompanyHeight.constant = 0
        viewCompanyHeight.isActive = true
        txtMerchantCompanyName.text = nil
        
        lblMerchantName.text = User.username!
        lblMerchantAddress.text = User.useraddress!
        txtEmail.text = User.email
        txtMerchantID.text = User.userID
        txtMerchanNricNo.text = User.nricno
        if User.merchantType != "3"
        {
            viewCompany.isHidden = false
            viewCompanyHeight.constant = 40
            txtMerchantCompanyName.text = User.usercompany 
        }
        txtMerchanPhoneNo.text = User.phone!
        lat = User.latitude!
        long = User.longtitude!
        
        let image =  String("\(WebServices.BASE_URL)\(User.photouser ?? "")")
        imgProfileMerchant?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "userplaceholder"))
        imgProfileMerchant.layer.cornerRadius = imgProfileMerchant.frame.size.height/2
        imgProfileMerchant.layer.masksToBounds = true
        imgProfileMerchant.layer.borderWidth = 0.2
        imgProfileMerchant.layer.borderColor = NAVIGATION_COLOR.cgColor
        
        profileImage = self.imgProfileMerchant.image!
        
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        backVc()
    }
}
