//
//  CartListTableCell.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit

class CartListTableCell: UITableViewCell {

    
    // cart cell items
    
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    
    
    
    // venue/service fields
    
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    
    // product
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblColour: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    
    @IBOutlet weak var btn_deleteSelectedItem: UIButton!
    
    @IBOutlet weak var btn_viewOrder_Details: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
