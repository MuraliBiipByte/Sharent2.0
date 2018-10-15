//
//  Product.swift
//  Sharent
//
//  Created by Biipbyte on 26/06/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import Foundation
import UIKit
class  Product
{
    
    static var productImages:[AnyObject]?
    static var productFiles:[AnyObject]?
    static var productFilesNames:[AnyObject]?
    static var productname:String?
    static var productMerchantId:String?
    static var productMerchantPhonenumber:String?
    static var productRate:String?
    static var productDetails:String?
    static var productDescription:String?
    static var productCatagory:String?
    static var productCatagoryId:String?
    static var productMinimumDays:String?
    static var productMaximumQunantity:String?
    static var productvehicleType:String?
    
    init(productDataDictionay:[String:Any])
    {
        Product.productImages                    = productDataDictionay["productImages"] as? [AnyObject]
        Product.productFiles                     = productDataDictionay["files"] as? [AnyObject]
        Product.productFilesNames                = productDataDictionay["filesNames"] as? [AnyObject]
        Product.productMerchantId                = productDataDictionay["user_id"] as? String
        Product.productMerchantPhonenumber       = productDataDictionay["phone_number"] as? String
        Product.productname                      = productDataDictionay["product_name"] as? String
        Product.productRate                      = productDataDictionay["rates"] as? String
        Product.productDetails                   = productDataDictionay["product_details"] as? String
        Product.productDescription               = productDataDictionay["description"] as? String
        Product.productCatagory                  = productDataDictionay["categoryName"] as? String
        Product.productCatagoryId                = productDataDictionay["category"] as? String
        Product.productMinimumDays               = productDataDictionay["minimum_days"] as? String
        Product.productMaximumQunantity          = productDataDictionay["quantity"] as? String
        Product.productvehicleType               = productDataDictionay["vehicletype"] as? String
        
        
        
    }
        
}

class ProductInformation
{
    static var userId:String?
    static var userName:String?
    static var userImage:String?
    static var marchantId:String?
    static var marchantName:String?
    static var marchantNumber:String?
    static var marchantAddress:String?
    static var marchantLat:String?
    static var marchantLang:String?
    static var marchantRemarks:String?
    static var campanyImage:String?
    static var productImage1:String?
    static var productImage2:String?
    static var productImage3:String?
    static var productImage4:String?
    static var productImage5:String?
    static var productName:String?
    static var productPrice:String?

    static var productDescription:String?
    static var productDetails:String?
    static var productRental:String?
    static var productFee:String?
    static var productFeePercentage:String?
    static var productTotalFee:String?
    static var productDiscount:String?
    static var productShipping:String?
    static var productRentalDays:String?
    static var productFromDate:String?
    static var productStartTime:String?
    static var productToDate:String?
    static var productEndTime:String?
    static var productFromDateUTC:String?
    static var productToDateUTC:String?
    static var productDeliveryCharges:String?
    static var productID:String?
    static var productOrderId:String?
    static var productBuyerReviwed:String?
    static var productBuyerLat:String?
    static var productBuyerLang:String?
    static var productBuyerAddress:String?
    static var productCollectionmethod:String?
    static var productReturnmethod:String?
    static var productReferenceId:String?
    static var productOrderstatus:String?
    static var productStatus:String?
    static var productVehicle:String?
    static var productCancelFee : String?
    static var productCategoryId:String?
    static var productCategoryName:String?
    static var companyName:String?
    static var minimumdays:String?
    static var attribute:[String:AnyObject]?
    static var availableAttribute:[[String:AnyObject]]?
    static var relatedProducts:[AnyObject]?
    
    
    
    static var attribute1Name:String?
    static var attribute1Id:String?
    static var attribute2Name:String?
    static var attribute2Id:String?
    static var attribute3Name:String?
    static var attribute3Id:String?
    static var attribute4Name:String?
    static var attribute4Id:String?
    static var attribute5Name:String?
    static var attribute5Id:String?
    

    init(productDetailsDictionay:[String:Any])
    {
         ProductInformation.userId                =  productDetailsDictionay["user_id"]as? String
        ProductInformation.userName               =  productDetailsDictionay["user_name"]as? String
        ProductInformation.userImage              =  productDetailsDictionay["user_image"]as? String
        ProductInformation.productID              =  productDetailsDictionay["product_id"]as? String
        ProductInformation.marchantId             = productDetailsDictionay["merchant_id"]as? String
        ProductInformation.marchantName           = productDetailsDictionay["merchant_name"] as? String
        ProductInformation.marchantNumber         = productDetailsDictionay["merchant_number"] as? String
        ProductInformation.marchantAddress        = productDetailsDictionay["merchant_address"] as? String
        ProductInformation.marchantLat            = productDetailsDictionay["merchant_lat"] as? String
        ProductInformation.marchantLang           = productDetailsDictionay["merchant_long"] as? String
        ProductInformation.marchantRemarks           = productDetailsDictionay["merchant_remarks"] as? String
        ProductInformation.campanyImage           = productDetailsDictionay["company_image"] as? String
        ProductInformation.productImage1          = productDetailsDictionay["photo_android1"] as? String
        ProductInformation.productImage2          = productDetailsDictionay["photo_android2"] as? String
        ProductInformation.productImage3          = productDetailsDictionay["photo_android3"] as? String
        ProductInformation.productImage4          = productDetailsDictionay["photo_android4"] as? String
        ProductInformation.productImage5          = productDetailsDictionay["photo_android5"] as? String
        ProductInformation.productName            = productDetailsDictionay["product_name"]  as? String
        ProductInformation.productDescription     = productDetailsDictionay["description"] as? String
        ProductInformation.productDetails           = productDetailsDictionay["product_details"] as? String
        
        
        ProductInformation.productPrice           = productDetailsDictionay["product_price"] as? String
        
        ProductInformation.productFee           = productDetailsDictionay["product_fee"] as? String
        
        ProductInformation.productFeePercentage           = productDetailsDictionay["product_fee_percentage"] as? String
        
        ProductInformation.productDiscount        = productDetailsDictionay["discount_price"] as? String
        ProductInformation.productShipping        = productDetailsDictionay["shipping_amount"] as? String
      
        ProductInformation.productRental          = productDetailsDictionay["rental_fee"] as? String
        
        ProductInformation.productRentalDays      = productDetailsDictionay["rental_period_days"] as? String
        
        ProductInformation.productTotalFee        = productDetailsDictionay["total_amount"] as? String
        
        ProductInformation.productCategoryId      = productDetailsDictionay["category"] as? String
        ProductInformation.productCategoryName    = productDetailsDictionay["category_name"] as? String
        ProductInformation.companyName            = productDetailsDictionay["company"] as? String
        ProductInformation.minimumdays            = productDetailsDictionay["minimum_days"] as? String
        ProductInformation.attribute              = productDetailsDictionay["attribute"] as? [String:AnyObject]
        ProductInformation.availableAttribute     = productDetailsDictionay["available_attribute"] as? [[String:AnyObject]]
        ProductInformation.relatedProducts        = productDetailsDictionay["related_products"] as? [AnyObject]
        ProductInformation.productBuyerReviwed        = productDetailsDictionay["review"] as? String
        ProductInformation.productCollectionmethod = productDetailsDictionay["collection_method"] as? String
        ProductInformation.productReturnmethod    = productDetailsDictionay["return_method"] as? String
        ProductInformation.productReferenceId     = productDetailsDictionay["reference_id"] as? String
        ProductInformation.productFromDate         = productDetailsDictionay["rental_period_startdate"] as? String
        ProductInformation.productStartTime         = productDetailsDictionay["start_time"] as? String
        ProductInformation.productToDate          = productDetailsDictionay["rental_period_enddate"] as? String
        ProductInformation.productEndTime         = productDetailsDictionay["end_time"] as? String
        ProductInformation.productOrderstatus      = productDetailsDictionay["order_status"] as? String
        ProductInformation.productStatus      = productDetailsDictionay["status_name"] as? String
        ProductInformation.productVehicle      = productDetailsDictionay["vehicletype"] as? String
        ProductInformation.productCancelFee = productDetailsDictionay["cancel_fee"] as? String
        
        ProductInformation.attribute1Name = productDetailsDictionay["attribute1"] as? String
        ProductInformation.attribute2Name = productDetailsDictionay["attribute2"] as? String
     }
}
