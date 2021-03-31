//
//  MyReviewTableViewCell.swift
//  Sharent
//
//  Created by Biipbyte on 25/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class MyReviewTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var viewRelatedRating: FloatRatingView!
    @IBOutlet weak var lblReviewPersonName:UILabel!
    @IBOutlet weak var lblReviewDate:UILabel!
    @IBOutlet weak var lblReviewText:UILabel!

    @IBOutlet weak var imgReviewPerson:UIImageView!
    
    
    @IBOutlet weak var mainBackgroundView: UIView!
    //See All Reviews
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
//        imgReviewPerson.layer.cornerRadius = imgReviewPerson.frame.size.height/2
//        imgReviewPerson.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
