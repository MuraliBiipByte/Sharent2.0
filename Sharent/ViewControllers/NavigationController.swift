//
//  NavigationController.swift
//  ResourceCoach
//
//  Created by Biipmi on 25/10/17.
//  Copyright © 2017 Biipmi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation
    {
        return sideMenuController!.isRightViewVisible ? .slide : .fade
    }
    
}

