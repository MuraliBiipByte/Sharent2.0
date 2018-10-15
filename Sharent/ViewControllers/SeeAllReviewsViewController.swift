//
//  SeeAllReviewsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class SeeAllReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FloatRatingViewDelegate {

    

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lbl_avg_Rating: UILabel!
    @IBOutlet weak var progress_5Star: UIProgressView!
    @IBOutlet weak var progress_4Star: UIProgressView!
    @IBOutlet weak var progress_3Star: UIProgressView!
    @IBOutlet weak var progress_2Star: UIProgressView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var progress_1Star: UIProgressView!
    @IBOutlet weak var tblReviews: UITableView!
    
    var arrReviewData = [AnyObject]()
    var strProductId:String? = ""
    
    var userId = String()
    var userLoginType = String()
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.title = "Review"
        backGroundView.isHidden = true
        
        getAllProductReviews()

        tblReviews.rowHeight = UITableViewAutomaticDimension
        tblReviews.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    func getAllProductReviews()
    {
        self.view.StartLoading()
        let paramsDic = ["api_key_data":WebServices.API_KEY,"product_id":strProductId!]
        ApiManager().postRequest(service: WebServices.SEE_ALL_REVIEWS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.backGroundView.isHidden = true
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                imageView.center = self.view.center
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "IconNoReviews")
                let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.origin.y+imageView.frame.height, width: self.view.frame.width, height: 21))
                label.textAlignment = NSTextAlignment.center
                label.font = Constants.APP_FONT
                label.text = "No Reviews found"
                self.view.addSubview(imageView)
                self.view.addSubview(label)
                return
            }
            else
            {
                self.backGroundView.isHidden = false

                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                let total_Review_Count = String(describing:dataDictionary!["reviewcount"]!)
                self.lblRating.text =  "\((Int(total_Review_Count)! > 1 ) ? "\(total_Review_Count) Ratings" : "\(total_Review_Count) Rating")"
                self.lbl_avg_Rating.text = "\(dataDictionary!["average_rating"]as! String) \n out of 5.0"
                let max :Float = 5
                let rating5 = dataDictionary!["5_star_rating_count"]as! String
                let rating4 = dataDictionary!["4_star_rating_count"]as! String
                let rating3 = dataDictionary!["3_star_rating_count"]as! String
                let rating2 = dataDictionary!["2_star_rating_count"]as! String
                let rating1 = dataDictionary!["1_star_rating_count"]as! String
                self.progress_5Star.progress = Float(rating5)!/max
                self.progress_4Star.progress = Float(rating4)!/max
                self.progress_3Star.progress = Float(rating3)!/max
                self.progress_2Star.progress = Float(rating2)!/max
                self.progress_1Star.progress = Float(rating1)!/max
                self.arrReviewData = dataDictionary!["review_data"] as! [AnyObject]

                self.tblReviews.reloadData()

        }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell")as! MyReviewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        cell.imgUser.image = #imageLiteral(resourceName: "SharentLogo")
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height/2
        cell.imgUser.layer.masksToBounds = true
        
        let userDict = self.arrReviewData[indexPath.row]["user_data"] as! [String:AnyObject]
  
        let userImg =  String("\(WebServices.BASE_URL)\(String(describing: userDict["user_image"]!))")
        
        print(userImg)
        cell.imgUser.sd_setImage(with: URL(string: userImg), placeholderImage: UIImage(named: "userplaceholder"))
       
        cell.lbl_UserName.text = userDict["username"] as? String
        cell.lbl_date.text = self.arrReviewData[indexPath.row]["created_on"] as? String
        cell.lbl_Comment.text = self.arrReviewData[indexPath.row]["comment"] as? String
        cell.ratingView.editable = false
        
        let rating = String(describing:self.arrReviewData[indexPath.row]["rate"]as AnyObject)
        cell.ratingView.rating = Double(rating)!
        cell.ratingView.type = .wholeRatings
        cell.ratingView.delegate = self
        cell.ratingView.backgroundColor = UIColor.clear
        
        return cell
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        backVc()
        
    }
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
}
