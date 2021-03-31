//
//  HomeCollectionViewCell.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell
{
    
    
    
    
   
    
    
    //Objects For Banner
    @IBOutlet weak var imgBanner: UIImageView!
    
    
    //Objects For quick picks
    @IBOutlet weak var imgQuickPick: UIImageView!
    @IBOutlet weak var quickPickTagName: UILabel!
 
    
    // Objects for featured brands
    
    @IBOutlet weak var imgFeaturedBrand: UIImageView!
    
    
    //Objects For Featured Products
    @IBOutlet weak var imgFeaturedProducts: UIImageView!
    @IBOutlet weak var viewFeaturedProducts: UIView!
    
    //Objects For Popular Picks
    @IBOutlet weak var imgPopularPicks: UIImageView!
    
    
    //Objects For Featured Deals
    @IBOutlet weak var imgFeaturedDeals: UIImageView!
    
    //Objects For Category1
    @IBOutlet weak var ImgCategory1: UIImageView!
    @IBOutlet weak var lblCategory1: UILabel!
//    @IBOutlet weak var lblCategory1OverLay: UILabel!
    
    //Objects For Category2
    @IBOutlet weak var imgCategory2: UIImageView!
    @IBOutlet weak var lblCategory2: UILabel!
//    @IBOutlet weak var lblCategory2OverLay: UILabel!
    
    // hot items Collection
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemRate: UILabel!
    
    @IBOutlet weak var rateView: FloatRatingView!
    
    @IBOutlet weak var rateLbl: UILabel!
    
}
