//
//  MyRevenueTableViewCell.swift
//  Sharent
//
//  Created by Biipbyte on 03/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MyRevenueTableViewCell: UITableViewCell
{

    @IBOutlet weak var lblProductName:UILabel!
    @IBOutlet weak var imgProduct:UIImageView!
    @IBOutlet weak var lblProductDate:UILabel!
    @IBOutlet weak var lblProductUserName:UILabel!
    @IBOutlet weak var lblProductUserPaidPrice:UILabel!
    @IBOutlet weak var lblProductRentalDates:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
