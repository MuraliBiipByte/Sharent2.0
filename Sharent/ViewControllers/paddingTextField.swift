//
//  paddingTextField.swift
//  paddingTextField
//
//  Created by chumbakadmin on 26/09/18.
//  Copyright © 2018 chumbakadmin. All rights reserved.
//

import UIKit

class paddingTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0,8, 0,8))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 8, 0, 8))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 8, 0, 8))
    }

}
