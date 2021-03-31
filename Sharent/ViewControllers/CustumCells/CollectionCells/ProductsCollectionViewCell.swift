//
//  ProductsCollectionViewCell.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell
{
    
    //Products Cell
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductType: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductRate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
 
    //category cell
    @IBOutlet weak var lblCategoryName: UILabel!
    
    
    //Related review Cell
    @IBOutlet weak var reviewRelatedImg: UIImageView!
    @IBOutlet weak var review_userName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var reviewRating: FloatRatingView!
    @IBOutlet weak var commentedTime: UILabel!
    
    //Fav Products CollectionView
    
    @IBOutlet weak var imgFavProduct: UIImageView!
    @IBOutlet weak var lblFavProductName: UILabel!
    @IBOutlet weak var lblFavProductRate: UILabel!
    @IBOutlet weak var FavratingView: FloatRatingView!
    @IBOutlet weak var lblFavRating: UILabel!
    @IBOutlet weak var imgFav: UIImageView!
    
    @IBOutlet weak var FavBackGroung: FloatRatingView!
    
    // Hot items collection
//    
//    @IBOutlet weak var itemImage: UIImageView!
//    
//    @IBOutlet weak var itemName: UILabel!
//    @IBOutlet weak var itemRate: UILabel!
    
    
}
