//
//  DataReadableViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class DataReadableViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet weak var imgNric:UIImageView!

    var rgtStepsVC = RegistrationStepsViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
       rgtStepsVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationStepsViewController") as! RegistrationStepsViewController
        
        if Merchant.img2 != nil
        {
            imgNric.image = Merchant.img2
            rgtStepsVC.btnTag = 2
        }
        else
        {
            imgNric.image = Merchant.img
            rgtStepsVC.btnTag = 1
        }
        
        
    }
  
    @IBAction func btn_back_tapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_OK_tapped(_ sender: Any)
    {
        self.present(rgtStepsVC, animated: true, completion: nil)
    }
}
