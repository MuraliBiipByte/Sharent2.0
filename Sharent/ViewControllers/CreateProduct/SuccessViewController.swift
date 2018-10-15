//
//  SuccessViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController
{
    
    var strTitle = String()
    var strMessage = String()
    
    var userLoginType = String()

    @IBOutlet weak var imageSuccess:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        userLoginType = UserDefaults.standard.value(forKey: "user_type") as! String
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        lblTitle.text = strTitle
        lblMessage.text = strMessage
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    @IBAction func btnBackToHomeTapped()
    {
        
        if userLoginType == UserType.BUYER
        {
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }
        else
        {
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }
        
    }

   
}
