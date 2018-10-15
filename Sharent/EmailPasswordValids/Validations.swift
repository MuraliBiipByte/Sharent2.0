//
//  Validations.swift
//  Sharent
//
//  Created by Biipbyte on 30/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import Foundation
class Validations
{
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    func isPasswordValid(_ password : String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{6,25}")
        return passwordTest.evaluate(with: password)
    }
}
