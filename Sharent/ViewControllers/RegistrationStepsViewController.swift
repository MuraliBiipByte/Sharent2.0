//
//  RegistrationStepsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class RegistrationStepsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var navigationView:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var lblMessage1:UILabel!
    @IBOutlet weak var btnOK:UIButton!
    @IBOutlet weak var imgResult:UIImageView!
    
    @IBOutlet weak var lblMessageHeight:NSLayoutConstraint!
    @IBOutlet weak var lblMessage1Height:NSLayoutConstraint!
    
    var btnTag = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationView.backgroundColor = APP_COLOR
        
        self.ImagesStatusChecking()
    }

    func ImagesStatusChecking()
    {
        lblMessageHeight.constant = 78
        lblMessageHeight.isActive = true
        
        lblMessage1Height.constant = 0
        lblMessage1Height.isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.termsAndconditions))
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.termsAndconditions1))
        
        switch btnTag
        {
        case 1:
            lblTitle.text = "Back of NRIC/FIN"
            lblMessage.text = "Now turn to the back of your NRIC/FIN and snap a photo of it."
            imgResult.image = UIImage(named: "IconRefresh")
            btnOK.setTitle("GOT IT", for: UIControlState.normal)
        case 2:
            
            let message:NSString = "I confirm that I have read and I agree to be bound by the Service Agreement and"
            
            let message1:NSString = "Privacy Policy , and I wish to submit my application."
            
            lblTitle.text = "Final Step"
            imgResult.image = UIImage(named: "LalamoveStatusIcon")
            btnOK.setTitle("I AGREE", for: UIControlState.normal)
            
            let wholeStr = "Service Agreement"
            let wholeStr1 = "Privacy Policy"
            
            let range1:NSRange = message.range(of: wholeStr, options: .caseInsensitive)
            let underLineTxt = NSMutableAttributedString(string: message as String)
            underLineTxt.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
            
            lblMessage.attributedText = underLineTxt
            lblMessage.isUserInteractionEnabled = true
            lblMessage.addGestureRecognizer(tap)
            
            let range2:NSRange = message1.range(of: wholeStr1, options: .caseInsensitive)
            
            let underLineTxt1 = NSMutableAttributedString(string: message1 as String)
            
            underLineTxt1.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range2)
            
            lblMessage1.attributedText = underLineTxt1
            
            lblMessage1.isUserInteractionEnabled = true
            lblMessage1.addGestureRecognizer(tap1)
            
            lblMessageHeight.constant = 39
            lblMessage1Height.constant = 39
        default:
            lblTitle.text = "Front of NRIC/FIN"
            lblMessage.text = "Snap a front page of NRIC/FIN."
            imgResult.image = UIImage(named: "IconRefresh")
            btnOK.setTitle("GOT IT", for: UIControlState.normal)
        }
        
    }
    
    @IBAction func btn_OK_Tapped(_ sender: Any)
    {
        switch btnTag
        {
        case 2:
            self.merchantRegistration()
        case 3:
            self.initialVc()
        default:
             self.camera()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if Merchant.img == nil
        {
            Merchant.img = image
            btnTag = 1
        }
        else
        {
            Merchant.img2 = image
            btnTag = 2
        }
        self.dismiss(animated: true, completion:
            {
            self.dataReadableVc()
            })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func dataReadableVc()
    {
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "DataReadableViewController") as! DataReadableViewController
        self.present(initialVC, animated: true, completion: nil)
    }
    func initialVc()
    {
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
        self.present(initialVC, animated: true, completion: nil)
    }
    func camera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        self.present(imagePicker, animated: true, completion: nil)
    }
    func merchantRegistration()
    {
        let paramsDic = ["api_key_data":WebServices.API_KEY,"name":Merchant.name!,"type":Merchant.type!,"telcode":Merchant.telcode!,"mobile":Merchant.phone!,"email":Merchant.email!,"company":Merchant.company!,"password":Merchant.password!,"confpassword":Merchant.confpassword!,"nric":Merchant.nricno!,"address":Merchant.address!,"lat":Merchant.latitude!,"long":Merchant.longtitude!,"city":Merchant.city!,"bank_name":Merchant.bankname!,"account_holder_name":Merchant.acntHolderName!,"account_num":Merchant.acntNum!,"bank_code":Merchant.bankcode!,"status":Merchant.status!]
        
        let images = ["image2":Merchant.img,"image3":Merchant.img2] as! [String : UIImage]
        self.view.endEditing(true)
        self.view.StartLoading()
        
        ApiManager().postRequestwithImages(service: WebServices.CREATE_MERCHANT, images: images, params: paramsDic)
            { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                self.btnTag = 3
                self.lblTitle.text = "You're on your way to becoming a RentLord"
                self.lblMessage.text = "Thank you for your submission. We will now process your application."
                
                self.lblMessageHeight.constant = 78
                self.lblMessageHeight.isActive = true
                
                self.lblMessage1Height.constant = 0
                self.lblMessage1Height.isActive = true
                
                self.imgResult.image = UIImage(named: "IconSuccess")
                self.btnOK.setTitle("YAY!", for: UIControlState.normal)
                
            }
        }
    }
    
    @objc func termsAndconditions(sender:UITapGestureRecognizer)
    {
        let terms = storyboard?.instantiateViewController(withIdentifier: "RegisterTermsViewController")as! RegisterTermsViewController
        terms.urlIndex = 2
        self.present(terms, animated: true, completion: nil)
    }
    @objc func termsAndconditions1(sender:UITapGestureRecognizer)
    {
        let terms = storyboard?.instantiateViewController(withIdentifier: "RegisterTermsViewController")as! RegisterTermsViewController
        terms.urlIndex = 3
        self.present(terms, animated: true, completion: nil)
    }
    
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        
        switch btnTag
        {
        case 1:
            Merchant.img = nil
            Merchant.img2 = nil
            btnTag = 0
            self.ImagesStatusChecking()
        case 2:
            Merchant.img2 = nil
            btnTag =  1
            self.ImagesStatusChecking()
        case 3:
            self.initialVc()
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message:message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
