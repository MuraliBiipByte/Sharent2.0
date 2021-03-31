//
//  CardListTableViewCell.swift
//  Sharent
//
//  Created by Biipbyte on 24/09/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class CardListTableViewCell: UITableViewCell
{

    @IBOutlet weak var cardlistDisplayView: UIView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var cardDeleteBtn: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        cardlistDisplayView.layer.shadowColor = UIColor.black.cgColor
        cardlistDisplayView.layer.shadowOpacity = 0.5
        cardlistDisplayView.layer.shadowOffset = CGSize.zero
        cardlistDisplayView.layer.shadowRadius = 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
