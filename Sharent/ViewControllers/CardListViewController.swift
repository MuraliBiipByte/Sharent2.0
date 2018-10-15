//
//  CardListViewController.swift
//  Sharent
//
//  Created by Biipbyte on 24/09/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import ActionSheetPicker
import Stripe
class CardListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource
{
   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var btnAddCard: UIButton!
    
    @IBOutlet weak var imgArray: UIImageView!
    @IBOutlet weak var ImgCard: UIImageView!
    @IBOutlet weak var cardListTableView: UITableView!
    
    @IBOutlet weak var imgCarImage: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    var strUserId = String()
    var cardList = [AnyObject]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.title = "Payment Methods"
        strUserId = UserDefaults.standard.value(forKey: "user_id")! as! String
        cardListTableView.isHidden = true
        self.getRecentCard()
        
    }
    
    func getRecentCard()
    {
        print(strUserId)
        let paramsDic = ["api_key_data":WebServices.API_KEY,"user_id":strUserId]
        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.LALAMOVE_GET_ALL_CARDS, params: paramsDic )
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                return
            }
            else
            {
                let response = result as! [String:Any]
                let data = response["data"]as! [String:Any]
                self.cardList = data["cards"] as! [AnyObject]
                if self.cardList.count > 0
                {
                    self.cardListTableView.isHidden = false
                    self.cardListTableView.reloadData()
                }
                
            }
        }
    }
    
   
    func showAlert(message:String)
    {
        Message.shared.Alert(Title: Constants.APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
   
    @IBAction func btn_AddCard_Tapped(_ sender: Any)
    {
        let addCardClass = self.storyboard?.instantiateViewController(withIdentifier: "AddToCardViewController") as! AddToCardViewController
        self.navigationController?.pushViewController(addCardClass, animated: false)
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        backVc()
    }
    
    @objc func backVc()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cardList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardlistCell") as! CardListTableViewCell
        let cardNumber = self.cardList[indexPath.row]["card_last4"] as! String
        
        cell.lblCardNumber.text = String(format: " **** **** **** %@", cardNumber)
        
        let cardName = String(describing:self.cardList[indexPath.row]["card_brand"]as AnyObject)
        let cardName1 = STPCard.brand(from: cardName)
        let cardImage = STPImageLibrary.brandImage(for: cardName1)
        cell.cardImage.image = cardImage
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cardNumber = self.cardList[indexPath.row]["card_last4"] as! String
        let cardName = self.cardList[indexPath.row]["card_brand"] as! String
        let customerId = self.cardList[indexPath.row]["customer_id"] as! String
       
        
        let cardDict = [ "card_last4": cardNumber, "card_brand":cardName, "customer_id":customerId]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardSelect"), object:cardDict);
         self.navigationController?.popViewController(animated: false)
        
    }

}
