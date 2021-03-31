//
//  HistoryTableViewCell.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell
{

    
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var viewUnderimgProduct: UIView!
    @IBOutlet weak var lbl_Product_Name: UILabel!
    @IBOutlet weak var lblProductRate: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var deliveryType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
//    @IBOutlet weak var lblProductAttribute: UILabel!
    
    @IBOutlet weak var lblAttribute2: UILabel!
    @IBOutlet weak var lbl_Order_Number: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lbl_Product_Status: UILabel!
  
    @IBOutlet weak var ButtonsViewHeight: NSLayoutConstraint!
  
    
    

    
    
    @IBOutlet weak var btn_Active: UIButton!
    
    @IBOutlet weak var btn_Cancel: UIButton!
        
    
    //Profile Details
    
   
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //Settings
    @IBOutlet weak var lblSettings: UILabel!
    
    //Link Account
    
    @IBOutlet weak var lblLinkAccount: UILabel!
    @IBOutlet weak var imgLinkAccount: UIImageView!
    
    //Push Notifications
    @IBOutlet weak var lblPushNotifications: UILabel!
    @IBOutlet weak var btnPushNotifications: UISwitch!
    
    //Email Notifications
    @IBOutlet weak var lblEmailNotifications: UILabel!
    @IBOutlet weak var btnEmailNotifications: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        mainBackgroundView.layer.cornerRadius = 5.0
        mainBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        mainBackgroundView.layer.shadowOpacity = 3
        mainBackgroundView.layer.shadowOffset = CGSize.zero
        mainBackgroundView.layer.shadowRadius = 2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
