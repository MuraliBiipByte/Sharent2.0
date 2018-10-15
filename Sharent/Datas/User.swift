//
//  User.swift
//  Sharent
//
//  Created by Biipbyte on 23/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import Foundation
import UIKit

class  User
{

    static var userID:String?
    static var username:String?
    static var usertype:String?
    static var usertypeid:String?
    static var usercompany:String?
    static var telcode:String?
    static var phone:String?
    static var mobileverify:String?
    static var emailverify:String?
    static var active:String?
    static var photouser:String?
    static var photouserthumb:String?
    static var userCity:String?
    static var useraddress:String?
    static var email:String?
    static var gender:String?
    static var latitude:String?
    static var longtitude:String?
    static var nricno:String?


    init(userDictionay:[String:Any])
    {
        User.userID          = userDictionay["id"] as? String
        User.username        = userDictionay["username"] as? String
        User.usertype        = userDictionay["usertype"] as? String
        User.usertypeid      = userDictionay["usertype_id"] as? String
        User.usercompany     = userDictionay["company"] as? String
        User.telcode         = userDictionay["telcode"] as? String
        User.phone           = userDictionay["phone"] as? String
        User.mobileverify    = userDictionay["mobile_verify"] as? String
        User.emailverify     = userDictionay["email_verify"] as? String
        User.active          = userDictionay["active"] as? String
        User.photouser       = userDictionay["photo_user"] as? String
        User.photouserthumb  = userDictionay["photo_user_thumb"] as? String
        User.userCity        = userDictionay["city"]as? String
        User.useraddress     = userDictionay["address"]as? String
        User.email           = userDictionay["email"]as? String
        User.gender          = userDictionay["gender"]as? String
        User.latitude        = userDictionay["lat"]as? String
        User.longtitude      = userDictionay["lng"]as? String
        User.nricno          = userDictionay["nric"]as? String
    }
    
}


