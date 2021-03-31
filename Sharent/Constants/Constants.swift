//
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit


let APP_NAME = "Sharent"
    
let COUNTRY_CODE = "+65"
    
let APP_CURRENT_VERSION = 8
    
let APPSTORE_URL = "itms-apps://itunes.apple.com/us/app/sharent-rent-earn-save/id1422672482?ls=1&mt=8"
    
        //We Are using Global APP_COLOR (#F5F5F5)
//let APP_COLOR: UIColor = UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1.0)
let APP_COLOR: UIColor = UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1.0)

        //We Are using Global NAVIGATION_COLOR (#4A4A4A)
let NAVIGATION_COLOR: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

let APPEARENCE_COLOR: UIColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)

//We Are using Global GUEST_COLOR (#C8C8C8)
let GUEST_COLOR: UIColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)


        //If you Change font here automatically it reflects in Navigation Bar
let NAVIGATION_FONT: UIFont = UIFont(name: "SFProDisplay-Semibold", size: 16)!
    
        //If you Change font here automatically it reflects in Navigation Bar
let APP_FONT: UIFont = UIFont(name: "SFProDisplay-Regular", size: 16)!
    
        //Google Sign in Client Id(We need use it for getting response of google sign in).
let GOOGLE_SIGNIN_CLIENTID = "276450425589-rm85kbeknkho6q0n3fu4gquh9v1260m4.apps.googleusercontent.com"
let GMS_PROVIDEAPI_KEY = "AIzaSyDrTsvbNpK2QPOcKCDeHMSgipwyuoxm2kE"


//Live STRIPE_PUBLISHABLE_KEY
// let STRIPE_PUBLISHABLE_KEY = "pk_live_tDqmJhb5IDr8jyGr1TVEmjCz"

//Test STRIPE_PUBLISHABLE_KEY
 let STRIPE_PUBLISHABLE_KEY = "pk_test_iyXovgUzeUUSK8FaIZOqYLlb"

let DEVICE_TYPE = "IOS"

let GMAIL_USER = "gmail"
let FB_USER = "fb_login"

let BUYER = "buyer"
let MERCHANT = "merchant"

let PRODUCT = "1"
let VENUE = "2"
let SERVICE = "3"


class Constants: NSObject {

    static func navigationBarTitleColor() -> UIColor {
        return UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1)
    }
    
    static func navigationBarSubTitleColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func navigationBarTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func navigationBarSubTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-LightItalic", size: 10.0)!
    }
    
    static func textFieldLineColorNormal() -> UIColor {
        return UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
    }
    
    static func textFieldLineColorSelected() -> UIColor {
        return UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1)
    }
    
    static func nicknameFontInMessage() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 12.0)!
    }
    
//    static func nicknameColorInMessageNo0() -> UIColor {
//        return UIColor(red: 45.0/255.0, green: 27.0/255.0, blue: 225.0/255.0, alpha: 1)
//    }
    
    static func nicknameColorInMessageNo1() -> UIColor {
        return UIColor(red: 53.0/255.0, green: 163.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
//    static func nicknameColorInMessageNo2() -> UIColor {
//        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
//    }
//
//    static func nicknameColorInMessageNo3() -> UIColor {
//        return UIColor(red: 207.0/255.0, green: 72.0/255.0, blue: 251.0/255.0, alpha: 1)
//    }
//
//    static func nicknameColorInMessageNo4() -> UIColor {
//        return UIColor(red: 226.0/255.0, green: 27.0/255.0, blue: 225.0/255.0, alpha: 1)
//    }
    
    static func messageDateFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 10.0)!
    }
    
    static func messageDateColor() -> UIColor {
        return UIColor(red: 191.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1)
    }
    
    static func incomingFileImagePlaceholderColor() -> UIColor {
        return UIColor(red: 238.0/255.0, green: 241.0/255.0, blue: 246.0/255.0, alpha: 1)
    }
    
    static func messageFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func outgoingMessageColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func incomingMessageColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
    }
    
    static func outgoingFileImagePlaceholderColor() -> UIColor {
        return UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo0() -> UIColor {
        return UIColor(red: 45.0/255.0, green: 227.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo1() -> UIColor {
        return UIColor(red: 53.0/255.0, green: 163.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo2() -> UIColor {
        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo3() -> UIColor {
        return UIColor(red: 207.0/255.0, green: 72.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo4() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 72.0/255.0, blue: 195.0/255.0, alpha: 1)
    }
    
    static func leaveButtonColor() -> UIColor {
        return UIColor.red
    }
    
    static func hideButtonColor() -> UIColor {
        return UIColor(red: 116.0/255.0, green: 127.0/255.0, blue: 145.0/255.0, alpha: 1)
    }
    
    static func leaveButtonFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func hideButtonFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func distinctButtonSelected() -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
    }
    
    static func distinctButtonNormal() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 18.0)!
    }
    
    static func navigationBarButtonItemFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func memberOnlineTextColor() -> UIColor {
        return UIColor(red: 41.0/255.0, green: 197.0/255.0, blue: 25.0/255.0, alpha: 1)
    }
    
    static func memberOfflineDateTextColor() -> UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 142.0/255.0, alpha: 1)
    }
    
    static func connectButtonColor() -> UIColor {
        return UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 150.0/255.0, alpha: 1)
    }
    
    static func urlPreviewDescriptionFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 12.0)!
    }
}
