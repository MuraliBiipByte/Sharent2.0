//
//  BannerDetailsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Biipbyte. All rights reserved.
//

import UIKit

class BannerDetailsViewController: UIViewController {

    var bannerID : Any = 0
    var bannerDetails = [AnyObject]()
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var bannerNameLbl: UILabel!
    @IBOutlet weak var bannerDescLbl: UILabel!
    
    @IBOutlet weak var bannerDescTextView: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bannerDescTextView.isEditable = false
        self.bannerDescTextView.dataDetectorTypes = UIDataDetectorTypes.all
        
        getBannerRelatedInformation()
        self.title = "PROMOTION"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.isHidden = true
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        imgBanner.layer.cornerRadius = 5
        imgBanner.layer.masksToBounds = true
    }

    func getBannerRelatedInformation() {
       let paramsDic = ["api_key_data" :WebServices.API_KEY,"banner_id":bannerID]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.GET_BANNER_DETAILS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.scrollView.isHidden = true
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                self.scrollView.isHidden = false
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                self.bannerDetails = (data["banner"] as? [AnyObject]) != nil  ?  (data["banner"] as! [AnyObject]) : []
                
                let image =  "\(WebServices.BASE_URL)\(self.bannerDetails[0]["image"] as! String)"
                self.imgBanner.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "productPlaceholder"))
                self.bannerNameLbl.text = self.bannerDetails[0]["name"] as? String
                self.bannerDescLbl.text = ""
                
                self.bannerDescTextView.text = self.bannerDetails[0]["description"] as? String
                
                if self.bannerDescTextView.text  != "" {
                    self.textViewHeight.constant = self.bannerDescTextView.contentSize.height + 100
                    
                }
                else{
                    self.textViewHeight.constant = 0
                    
                }
              
                
            }
        }
    }
    
    
    @IBAction func go_backTo_HomeTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}
