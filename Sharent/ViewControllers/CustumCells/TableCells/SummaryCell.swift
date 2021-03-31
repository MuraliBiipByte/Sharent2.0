//
//  SummaryCell.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    
    
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblBookedDays: UILabel!
    
    @IBOutlet weak var rentalFee: UILabel!
    
    @IBOutlet weak var preauthorisationAmount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
