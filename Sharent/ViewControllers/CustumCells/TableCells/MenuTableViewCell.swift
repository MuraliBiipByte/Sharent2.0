//
//  MenuTableViewCell.swift
//  Sharent
//
//  Created by Biipbyte on 11/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell
{
   
    ///Menu
    
    @IBOutlet weak var imageMenu:UIImageView!
    @IBOutlet weak var lblTitleMenu:UILabel!
    
    @IBOutlet weak var lblCartCount: UILabel!
    
    //Account
    
    @IBOutlet weak var lblProfileListName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        
    }

}
