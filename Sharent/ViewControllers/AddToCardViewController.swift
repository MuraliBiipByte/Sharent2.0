//
//  AddToCardViewController.swift
//  Sharent
//
//  Created by Biipbyte on 24/09/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//
import ActionSheetPicker
import Alamofire
import Stripe
import UIKit

class AddToCardViewController: UIViewController ,STPAddCardViewControllerDelegate
{
   
    @IBOutlet weak var displayView: UIView!
    
    @IBOutlet weak var txtCardNumber: UITextField!
    
    @IBOutlet weak var txtMonth: UITextField!
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtCVVNumber: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnMonth: UIButton!
    
    @IBOutlet weak var btnYear: UIButton!
    
    var strUserId = String()
    var monthNames = [String]()
    var years = [String]()
    var monthIndex = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: date)
        let year:Int? = Int(result)
        self.years.append(String(format:"%d",year!))
        
     
        for i in 1 ... 15
        {
            let year1 = year! + i
           self.years.append(String(format: "%d", year1))
            
        }
        
        self.monthNames = ["1","2","3","4","5","6","7","8","9","10","11","12"];
        
        displayView.layer.shadowColor = UIColor.black.cgColor
        displayView.layer.shadowOpacity = 0.5
        displayView.layer.shadowOffset = CGSize.zero
        displayView.layer.shadowRadius = 3
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.title = "Add Card"
        
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SaveButtonTapped(_ sender: Any)
    {
         self.view.endEditing(true)
        
        if (txtCardNumber.text?.isEmpty)!
        {
            self.showAlert(message:"Card Number can't be empty!")
            self.txtCardNumber.resignFirstResponder()
            return
        }
        if (txtMonth.text?.isEmpty)!
        {
            self.showAlert(message:"Month Can't be empty")
            self.txtMonth .resignFirstResponder()
            return
        }
        if (txtYear.text?.isEmpty)!
        {
            self.showAlert(message:"Year Can't be empty")
            self.txtYear .resignFirstResponder()
            return
        }
        if (txtCVVNumber.text?.isEmpty)!
        {
            self.showAlert(message:"CVV Number Can't be empty")
            self.txtCVVNumber .resignFirstResponder()
            return
        }
     //   let addCardViewController = STPAddCardViewController()
       
        let cardParams = STPCardParams()
         print(self.txtCardNumber.text ?? "",self.txtMonth.text ?? "",self.txtYear.text ?? "",self.txtCVVNumber.text ?? "",self.monthIndex)
        let monthstr = "\(self.txtMonth.text!)"
        let month  = Int(monthstr)!
        let yearstr = "\(self.txtYear.text!)"
        let year:Int = Int(yearstr)!
        let cvvNumber = "\(self.txtCVVNumber.text!)"
        cardParams.number = self.txtCardNumber.text
        cardParams.expMonth = UInt(month)
        cardParams.expYear = UInt(year)
        cardParams.cvc = cvvNumber
        cardParams.currency = "SGD"
        
        print(self.txtCardNumber.text ?? "",self.txtMonth.text ?? "",self.txtYear.text ?? "",self.txtCVVNumber.text ?? "")
        self.view.StartLoading()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            self.view.StopLoading()
            guard let token = token, error == nil else
            {
                self.showAlert(message: (error?.localizedDescription)!)
                return
            }
            print(token.tokenId)
            let tkn = "\(token.tokenId)"
            
            let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":self.strUserId,"stripetoken":tkn]
          
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.LALAMOVE_ADD_NEW_CARD, params: paramsDic )
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                }
                else
                {
                    
                    let response = result as! [String:Any]
                    let message = response["message"] as! String
                    self.showAlertWithAction(message: message, selector:#selector(self.myCards))
                    
                }
            }
        }
        
         
        
    }

    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock)
    {
       
        
    }
    @objc func myCards()
    {
        self.navigationController?.popViewController(animated: true)
    }
    // textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        backVc()
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func MonthButtonTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if (txtCardNumber.text?.count)! < 16
        {
            self.showAlert(message: "Card details are invalid. Enter valid data")
        }
        else
        {
            ActionSheetStringPicker.show(withTitle: "Select Month", rows: monthNames, initialSelection: 0, doneBlock:
                {
                picker, value, index in
                
                print("value = \(value)")
                
                self.txtMonth.text = self.monthNames[value]

                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        }
        
       
    }
    
    @IBAction func YearButtonTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Select Year", rows: years, initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            
            self.txtYear.text = self.years[value]
    
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
}

