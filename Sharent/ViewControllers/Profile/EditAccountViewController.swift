//
//  EditAccountViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import ActionSheetPicker

class EditAccountViewController: UIViewController,GMSAutocompleteViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate
{

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEditImage: UIButton!
    var placesClient: GMSPlacesClient!
    let arrGender = ["Male","Female","Others"]

    var strUserId = String()
    var strUserType = String()
    var strImage = String()
    var address = String()
    var city = String()
    var lat = String()
    var long = String()
    var genderText = String()
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
          self.imagePicker.delegate = self
          self.txtName.delegate = self
          imgProfile.layer.cornerRadius = imgProfile.frame.height / 2;
            imagePicker.delegate = self
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.masksToBounds = true
        
       strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
       strUserType = UserDefaults.standard.value(forKey: "user_type")! as! String
 
      
        let image = String("\(WebServices.BASE_URL)\(User.photouser ?? "")")
       self.imgProfile.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named: "userplaceholder"))
        
        self.txtName.text = User.username!
        self.txtMobileNumber.text = User.phone!
        self.txtMobileNumber.isEnabled = false
        
        self.txtEmail.text = User.email
        self.txtEmail.isEnabled = false
        self.lblAddress.text = "\((User.useraddress == nil) ? "Select Address" : "\(User.useraddress!)")"
        lat = User.latitude ?? ""
        long = User.longtitude ?? ""
        
    }
    
    @IBAction func btn_Photo_Tapped(_ sender: Any)
    {
        
        let alert = UIAlertController(title: Constants.APP_NAME, message: nil, preferredStyle: .actionSheet)
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
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
        else
        {
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func openGallary()
    {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func btn_Address_Tapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.country = "SG"
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self 
        present(autocompleteController, animated: true, completion: nil)
    }
  
    @IBAction func btn_Save_Tapped(_ sender: Any)
    {
        if (self.txtName.text?.isEmpty)!
        {
            self.showAlert(message: "Name Should not be empty")
            return
        }
       
        var paramsDic = [String : String]()
     
        paramsDic = ["api_key_data":WebServices.API_KEY,"user_type":strUserType,"user_id":strUserId,"username":self.txtName.text!,"address":self.lblAddress.text!,"city":"Singpore","lat":lat,"long":long]
        
        print(paramsDic)
        
        let urlString = WebServices.BASE_URL_SERVICE + WebServices.BUYER_EDIT_PROFILE
        self.view.StartLoading()
        ApiManager().editProfileSendRequest(urlString, image: self.profileImage.image!, parameters: paramsDic)
        { (response, Success) in
            self.view.StopLoading()
            
            if Success == false
            {
                let responseData = response as! [String:Any]
                let resp = responseData["response"] as! [String:Any]
                let mess = resp["message"] as! String
                self.showAlert(message: mess)
                return
            }
            else
            {
                print(response)
                let responseData = response as! [String:Any]
                let resp = responseData["response"] as! [String:Any]
                let dataDictionary = resp["data"] as? [String:Any]
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

                let mess = resp["message"] as! String
                let status  = resp["status"] as! String
                if status == "1"
                {
                    self.showAlertWithAction(message:mess)
                    self.viewWillAppear(true)
                }
                else
                {
                    self.showAlertWithAction(message:mess)
                    self.viewWillAppear(true)
                }
               
                
            }
        }
  }
    @IBAction func btn_back_Tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
       self.imgProfile.image = nil
        
       if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
           //self.imgProfile.contentMode = .scaleAspectFit
        
           self.imgProfile.image = pickedImage
           let imageData = UIImagePNGRepresentation(pickedImage)! as NSData
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            self.strImage = strBase64
        
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(myAccount), Controller: self)], Controller: self)
    }
    @objc func myAccount()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
        self.lblAddress.text = "\(place.name),\(place.formattedAddress!)"
        
        print("\(place.name)")
       
        User.latitude =  "\(place.coordinate.latitude)"
        lat = "\(place.coordinate.latitude)"
        User.longtitude = "\(place.coordinate.longitude)"
        long = "\(place.coordinate.longitude)"
        User.useraddress = "\(place.name),\(place.formattedAddress!)"
        self.lblAddress.text = "\( User.useraddress!)"
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
