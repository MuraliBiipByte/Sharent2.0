//
//  Lalamove.swift
//  Sharent
//
//  Created by Biipbyte on 17/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import Foundation
import UIKit

enum LalaMoveStatus :String
{
    case ASSIGNING_DRIVER
    case ON_GOING
    case PICKED_UP
    case COMPLETED
    case EXPIRED
    case CANCELED
}

class  Lalamove
{
    
    static var driverid:String?
    static var drivername:String?
    static var driverphone:String?
    static var status:String?
    
    init(lalamoveDataDictionay:[String:Any])
    {
        Lalamove.driverid      = lalamoveDataDictionay["driver_id"] as? String
        Lalamove.drivername    = lalamoveDataDictionay["driver_name"] as? String
        Lalamove.driverphone   = lalamoveDataDictionay["driver_phone"] as? String
        Lalamove.status        = lalamoveDataDictionay["status"] as? String
        
    }
}
