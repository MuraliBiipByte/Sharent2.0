//
//  Constants.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
struct Constants
    {
    
        static let APP_NAME = "Sharent"
    
        static let COUNTRY_CODE = "+65"
    
        //We Are using Global APP_COLOR (#E6E6E6)
        static let APP_COLOR: UIColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
        //We Are using Global NAVIGATION_COLOR (#4A4A4A)
        static let NAVIGATION_COLOR: UIColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
        //If you Change font here automatically it reflects in Navigation Bar
        static let NAVIGATION_FONT: UIFont = UIFont(name: "SFProDisplay-Semibold", size: 16)!
    
        //If you Change font here automatically it reflects in Navigation Bar
        static let APP_FONT: UIFont = UIFont(name: "SFProDisplay-Regular", size: 16)!
    
        //Google Sign in Client Id(We need use it for getting response of google sign in).
        static let GOOGLE_SIGNIN_CLIENTID = "276450425589-rm85kbeknkho6q0n3fu4gquh9v1260m4.apps.googleusercontent.com"
        static let GMS_PROVIDEAPI_KEY = "AIzaSyDrTsvbNpK2QPOcKCDeHMSgipwyuoxm2kE"
    
       // static let GMS_PROVIDEAPI_KEY = "AIzaSyCw8CJboqpOnYjgbSPcVTqLDGcrw5WsACY"
    
        //Live STRIPE_PUBLISHABLE_KEY
        // static let STRIPE_PUBLISHABLE_KEY = "pk_live_tDqmJhb5IDr8jyGr1TVEmjCz"
    
        //Test STRIPE_PUBLISHABLE_KEY
        static let STRIPE_PUBLISHABLE_KEY = "pk_test_iyXovgUzeUUSK8FaIZOqYLlb"
    }
struct UserType
{
    static let BUYER = "buyer"
    static let MERCHANT = "merchant"
}
    

