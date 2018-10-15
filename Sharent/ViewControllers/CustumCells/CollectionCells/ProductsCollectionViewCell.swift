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
    
    //Related Products Cell
    @IBOutlet weak var imgRelatedProduct: UIImageView!
    @IBOutlet weak var lblRelatedProductName: UILabel!
    @IBOutlet weak var lblRelatedProductRate: UILabel!
    @IBOutlet weak var lblRelatedProductRatings: UILabel!
    
    @IBOutlet weak var viewRelatedRating: FloatRatingView!
    
    //Fav Products CollectionView
    
    @IBOutlet weak var imgFavProduct: UIImageView!
    @IBOutlet weak var lblFavProductName: UILabel!
    @IBOutlet weak var lblFavProductRate: UILabel!
    @IBOutlet weak var FavratingView: FloatRatingView!
    @IBOutlet weak var lblFavRating: UILabel!
    @IBOutlet weak var imgFav: UIImageView!
    
    @IBOutlet weak var FavBackGroung: FloatRatingView!
    
}
