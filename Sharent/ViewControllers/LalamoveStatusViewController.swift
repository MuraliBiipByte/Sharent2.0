//
//  LalamoveStatusViewController.swift
//  Sharent
//
//  Created by Biipbyte on 17/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class LalamoveStatusViewController: UIViewController
{
    @IBOutlet weak var viewlalamovestatus: UIView!
    @IBOutlet weak var lbllalamovestatus: UILabel!
    @IBOutlet weak var lbllalamoveDetails: UILabel!
    @IBOutlet weak var btnstatusok: UIButton!
    
    var myMutableString = NSMutableAttributedString()
    var lalamoveDetails = NSString()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.btnstatusok.setTitle("OK", for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "My Booking"
        
        let lalamoveStatus = LalaMoveStatus(rawValue: Lalamove.status!)!
        switch lalamoveStatus
        {
        case .ASSIGNING_DRIVER:
            lbllalamovestatus.text = "Matching in Progress!"
            lbllalamoveDetails.text = "Hang on tight while we match you with a driver to deliver your item."
            self.btnstatusok.setTitle("Got it", for: .normal)
        case .ON_GOING:
           
            lbllalamovestatus.text = "Item En-Route!"
            lalamoveDetails = "Your item is on it's way to the user. For more information, contact your with a driver, \(Lalamove.drivername!), at \(Lalamove.driverphone!)." as NSString
            self.setText(lalamoveDetails: lalamoveDetails)
        case .PICKED_UP:
            lbllalamovestatus.text = "Item Picked Up!"
            lalamoveDetails = "Your item has been picked up by \(Lalamove.drivername!). For more information, Contact the driver at \(Lalamove.driverphone!)." as NSString
            self.setText(lalamoveDetails: lalamoveDetails)
        case .COMPLETED:
            lbllalamovestatus.text = "Item Delivered!"
            lalamoveDetails = "Your item has been safely delivered by \(Lalamove.drivername!). For more information, Contact the driver at \(Lalamove.driverphone!)." as NSString
            self.setText(lalamoveDetails: lalamoveDetails)
        case .EXPIRED:
            lbllalamovestatus.text = "Matching in Progress!"
            lbllalamoveDetails.text = "Hang on tight while we match you with a driver to deliver your item."
            self.btnstatusok.setTitle("Got it", for: .normal)
        case .CANCELED:
            lbllalamovestatus.text = "Matching in Progress!"
            lbllalamoveDetails.text = "Hang on tight while we match you with a driver to deliver your item."
            self.btnstatusok.setTitle("Got it", for: .normal)
        }
    }

    func setText(lalamoveDetails: NSString)
    {
        let range:NSRange = lalamoveDetails.range(of: Lalamove.drivername!, options: .caseInsensitive)
        let range1:NSRange = lalamoveDetails.range(of: Lalamove.driverphone!, options: .caseInsensitive)
        myMutableString = NSMutableAttributedString(
            string: lalamoveDetails as String)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range1)
        lbllalamoveDetails.attributedText = myMutableString
    }
    
    @IBAction func btn_lalamove_status_ok_tapped(_ sender: Any)
    {
        backvc()
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        backvc()
    }
    func backvc()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
