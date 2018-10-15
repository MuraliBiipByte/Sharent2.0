//
//  ViewController.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var btnLogin:UIButton! 
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnMerchantLogin:UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        self.navigationController?.navigationBar.isHidden = true
    
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }

   @IBAction func btnLoginTapped()
    {
       gotoLogin(userlogintype:UserType.BUYER)
    }
  @IBAction func btnRegisterTapped()
    {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        registerVC.userType = UserType.BUYER
        self.present(registerVC, animated: true, completion: nil)
    }
 @IBAction func btnMerchantLoginTapped()
    {
        gotoLogin(userlogintype:UserType.MERCHANT)
    }
    
   //We are using this method to go login as per usertype
    func gotoLogin(userlogintype:String)
    {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.userLoginType = userlogintype
        self.present(loginVC, animated: true, completion: nil)
    }
    @IBAction func btn_Guestlogin_Tapped(_ sender: Any)
    {
        let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu")
        self.present(navigateToHome!, animated: true, completion: nil)
    }
    
}
