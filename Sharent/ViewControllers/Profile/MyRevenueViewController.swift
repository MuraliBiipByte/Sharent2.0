//
//  MyRevenueViewController.swift
//  Sharent
//
//  Created by Biipbyte on 03/08/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker

class MyRevenueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
  
    
    var userId  = String()
    var revenuedetails = [AnyObject]()
    
    var arrMonths = [String]()
    var arrYears = [String]()
    
    var currentYear = String()
    var selectedYear = String()
    var Yearsless5 = Int()
    var currentMonthName = String()
    var currentMonthValue = String()
    var selectedMonth = String()
    
    @IBOutlet weak var btnMonth:UIButton!
    @IBOutlet weak var btnYear:UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblTotalRevenue:UILabel!
    
    @IBOutlet weak var tblRevenueDetails:UITableView!
    
    @IBOutlet weak var tblRevenueDetailsHeight:NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        scrollView.isHidden = true
        
        tblRevenueDetails.delegate = self
        tblRevenueDetails.dataSource = self
        
        userId = UserDefaults.standard.value(forKey: "user_id") as! String
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
      
        currentYear = String(format: "%d", year!)
        selectedYear = currentYear
        currentMonthValue = String(format: "%02d", month!)
        selectedMonth = currentMonthValue
        
        Yearsless5 = year! - 5
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        currentMonthName = dateFormatter.string(from: date)
        
        btnMonth.setTitle(currentMonthName, for: .normal)
        btnYear.setTitle(currentYear, for: .normal)
        
        getRevenueDetails(year: currentYear, month: currentMonthValue)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  getRevenueDetails(year:String,month:String)
    {
        
        let paramsDic = ["api_key_data":WebServices.API_KEY,"merchant_id":userId,"year":year,"month":month]
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.MY_REVENUE_DETAILS, params: paramsDic) { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.scrollView.isHidden = false

               self.showAlertWithAction(message: result as! String, selector:#selector(self.backVc))
                self.lblTotalRevenue.text = String(format: " $ 0.0")
                self.tblRevenueDetailsHeight.constant = 0.0
                 self.tblRevenueDetailsHeight.isActive = true
                
                return
            }
            else
            {
                self.scrollView.isHidden = false
                let resultDictionary = result as! [String : Any]
                let dataDictionary = resultDictionary["data"] as? [String:Any]
                self.revenuedetails = dataDictionary!["revenue_details"] as! [AnyObject]
                self.lblTotalRevenue.text = String(format: " $ %@", dataDictionary!["total_amount"] as! String)
               
                if self.revenuedetails.count > 0
                {
                    self.tblRevenueDetails.reloadData()
                }
            
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.revenuedetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRevenueTableViewCell") as! MyRevenueTableViewCell
        cell.viewUnderimgProduct.layer.cornerRadius = 8
        cell.viewUnderimgProduct.layer.masksToBounds = true
        
        cell.lblProductName.text = self.revenuedetails[indexPath.row]["product_name"] as? String
        cell.lblProductUserName.text = self.revenuedetails[indexPath.row]["user_name"] as? String
        cell.lblProductUserPaidPrice.text = String(format: "$ %@", self.revenuedetails[indexPath.row]["price"] as! String)
        cell.lblProductRentalDates.text = String(format:" %@ to %@ ", self.revenuedetails[indexPath.row]["rental_period_startdate"] as! String,self.revenuedetails[indexPath.row]["rental_period_enddate"] as! String)
        let image =  "\(WebServices.BASE_URL)\(self.revenuedetails[indexPath.row]["photo_android1"] as! String)"
        cell.imgProduct.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "productPlaceholder"))
        
        self.tblRevenueDetailsHeight.constant = CGFloat(self.revenuedetails.count * 90)
        self.tblRevenueDetailsHeight.isActive = true
        
        return cell
    }
    @IBAction func btn_month_tapped(sender:UIButton)
    {
        for myInt in 1...12
        {
            arrMonths.append(String(format: "%02d", myInt))
        }
        
        let monthComponents = Calendar.current.shortMonthSymbols

        ActionSheetStringPicker.show(withTitle: "Select Month", rows: monthComponents as [Any], initialSelection: Int(currentMonthValue)!-1, doneBlock:
            {
            picker, value, index in
            
                self.selectedMonth = self.arrMonths[value]
                self.currentMonthName = "\(index!)"
                self.btnMonth.setTitle(self.currentMonthName, for: .normal)

            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    @IBAction func btn_year_tapped(sender:UIButton)
    {
        let currentYearInt = Int(self.currentYear)
        
        for index in stride(from: currentYearInt!, to: Yearsless5, by: -1)
        {
            arrYears.append(String(format: "%02d", index))
        }
        
        ActionSheetStringPicker.show(withTitle: "Select Year", rows: arrYears as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                self.selectedYear = "\(index!)"
                self.btnYear.setTitle(self.selectedYear, for: .normal)

                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    @IBAction func btn_submit_tapped()
    {

        if currentYear == selectedYear
        {
            if selectedMonth > currentMonthValue
            {
                showAlert(message: " Please select valid month and year ")
            }
            else
            {
                scrollView.isHidden = true
                self.getRevenueDetails(year: selectedYear, month: selectedMonth)
            }
        }
        else
        {
            scrollView.isHidden = true
            self.getRevenueDetails(year: selectedYear, month: selectedMonth)
        }
  
    }
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_back_Tapped(_ sender: Any)
    {
        backVc()
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
}
