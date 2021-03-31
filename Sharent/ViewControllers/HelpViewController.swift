//
//  HelpViewController.swift
//  Sharent
//
//  Created by Biipbyte on 28/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   
    var helpAttributes = [String]()
    var userType :String?
    @IBOutlet weak var helpTableview:UITableView!
    
    @IBOutlet weak var helpTableviewHeight:NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "HELP"
        
        helpAttributes = ["Privacy Policy","Terms of use","Contact Us","FAQ"]
    
        userType = UserDefaults.standard.string(forKey: "user_type")
        helpTableview.delegate = self
        helpTableview.dataSource = self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return helpAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let helpCell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell") as! HelpTableViewCell
        helpCell.lblHelpAttribute.text = "\(helpAttributes[indexPath.row])"
        helpCell.accessoryType = .disclosureIndicator
        
        helpTableviewHeight.constant = helpTableview.contentSize.height
        helpTableviewHeight.isActive = true
        
        return helpCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 2:
            let contactVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(contactVc, animated: true)
        default:
            let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            privacyVc.title = "\(helpAttributes[indexPath.row].uppercased())"
            privacyVc.urlIndex = indexPath.row
            self.navigationController?.pushViewController(privacyVc, animated: true)
        }
    }
    
   
    
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {

        if userType == MERCHANT
        {
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "MerchantHomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }else{
            let navigateToHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(navigateToHome!, animated: false)
        }
       
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
