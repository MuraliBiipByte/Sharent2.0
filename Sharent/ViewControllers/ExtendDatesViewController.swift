//
//  ExtendDatesViewController.swift
//  Sharent
//
//  Created by Biipbyte on 20/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker

class ExtendDatesViewController: UIViewController
{
    
    
    @IBOutlet weak var lblProductname:UILabel!
    @IBOutlet weak var lblExtendedDates:UILabel!
    @IBOutlet weak var lblExtendedDays:UILabel!
    @IBOutlet weak var txtProductCurrentDates:UITextField!
    @IBOutlet weak var txtProductExtendStartDate:UITextField!
    @IBOutlet weak var txtProductExtendEndDate:UITextField!
    @IBOutlet weak var imgProduct:UIImageView!
    @IBOutlet weak var btnExtendDates:UIButton!
    @IBOutlet weak var viewCurrentDateBackground: UIView!
    @IBOutlet weak var viewExtenddatesBackGround: UIView!
    
    var strCurrentExtendEndDate = String()
    var minimumExtendedDate = Date()
    let dateFormatter = DateFormatter()
    var currentEnddate =  Date()
    var extendedEnddate =  Date()
    
    var extentionRentalDays = Int()
   

    override func viewDidLoad()
    {
        super.viewDidLoad()

        txtProductCurrentDates.isEnabled = false
        
        txtProductExtendStartDate.isEnabled = false
        txtProductExtendEndDate.isEnabled = false
        
        lblProductname.text = ProductInformation.productName!
        
        txtProductCurrentDates.text = String(format: "%@ to %@", ProductInformation.productFromDate!,ProductInformation.productToDate!)
        self.lblExtendedDays.text = nil
        self.lblExtendedDates.text = nil
        
        
        let image =  "\(WebServices.BASE_URL)\(ProductInformation.productImage1!)"
        self.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        minimumExtendedDate = dateFormatter.date(from: ProductInformation.productToDate!)!
        
        self.txtProductExtendStartDate.text = ProductInformation.productFromDate!
        self.strCurrentExtendEndDate = dateFormatter.string(from: minimumExtendedDate)
        self.currentEnddate = self.dateFormatter.date(from: ProductInformation.productToDate!)!
        self.extendedEnddate = minimumExtendedDate
        self.txtProductExtendEndDate.text = self.strCurrentExtendEndDate
        
        btnExtendDates.tag = 1
        viewCurrentDateBackground.layer.shadowColor = UIColor.black.cgColor
        viewCurrentDateBackground.layer.shadowOpacity = 0.5
        viewCurrentDateBackground.layer.shadowOffset = CGSize.zero
        viewCurrentDateBackground.layer.shadowRadius = 3
        
        viewExtenddatesBackGround.layer.shadowColor = UIColor.black.cgColor
        viewExtenddatesBackGround.layer.shadowOpacity = 0.5
        viewExtenddatesBackGround.layer.shadowOffset = CGSize.zero
        viewExtenddatesBackGround.layer.shadowRadius = 3

        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnExtend_EndDate_Tapped(_ sender: Any)
    {
        let datePicker = ActionSheetDatePicker(title: "End Date", datePickerMode: UIDatePickerMode.date, selectedDate:minimumExtendedDate, doneBlock:
        {
            picker, value, index in
            
            self.strCurrentExtendEndDate = self.dateFormatter.string(from: value as! Date)
            self.txtProductExtendEndDate.text = self.strCurrentExtendEndDate
            self.extendedEnddate = self.dateFormatter.date(from: self.strCurrentExtendEndDate)!
            
            if self.btnExtendDates.tag == 2
            {
                if self.currentEnddate == self.extendedEnddate
                {
                    self.lblExtendedDays.text = nil
                    self.lblExtendedDates.text = nil
                    self.showAlert(message:"Extended date should be greater than End date")
                }
                else
                {
                    self.extentionRentalDays = Int((self.extendedEnddate.timeIntervalSince(self.currentEnddate)) / (60 * 60 * 24))
                    self.lblExtendedDays.text = String(format: "Day Extended : %d Days ", self.extentionRentalDays )
                    self.lblExtendedDates.text = String(format: "%@ to %@", ProductInformation.productFromDate!,self.strCurrentExtendEndDate )
                }
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
         datePicker?.minimumDate = minimumExtendedDate
         datePicker?.show()
    }
    
    @IBAction func btnConfirm_EndDate_Tapped()
    {
        
        switch btnExtendDates.tag
        {
        case 1:
            if currentEnddate == self.extendedEnddate
            {
                showAlert(message:"Extended date should be greater than End date")
            }
            else
            {
                extentionRentalDays = Int((self.extendedEnddate.timeIntervalSince(self.currentEnddate)) / (60 * 60 * 24))
                self.lblExtendedDays.text = String(format: "Day Extended : %d Days ", extentionRentalDays )
                self.lblExtendedDates.text = String(format: "%@ t0 %@", ProductInformation.productFromDate!,self.strCurrentExtendEndDate )
                
                btnExtendDates.tag =  2
            }
        case 2:
            
            let extentionVc = self.storyboard?.instantiateViewController(withIdentifier: "ExtentionRentalPeriodViewController") as! ExtentionRentalPeriodViewController
            extentionVc.referenceProductId = ProductInformation.productReferenceId!
            extentionVc.extentionRentalDays = self.extentionRentalDays
            extentionVc.strCurrentExtendEndDate = self.strCurrentExtendEndDate
            self.navigationController?.pushViewController(extentionVc, animated: false)
            
        default:
            return
        }
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }

    
}
