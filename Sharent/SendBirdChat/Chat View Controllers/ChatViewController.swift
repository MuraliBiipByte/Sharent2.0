//
//  ChatViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController {
    var groupChannelListViewController: GroupChannelListViewController?

    weak var delegate: CreateGroupChannelSelectOptionViewControllerDelegate?

    var merchantid = String()
    var merchantname = String()
    
    var username = String()
    
    
//     var merchantid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let id =  UserDefaults.standard.value(forKey: "user_id")
        if id != nil
        {
            merchantid = UserDefaults.standard.value(forKey: "user_id")! as! String
        }
        else
        {
            merchantid = ""
        }
        
        let name =  UserDefaults.standard.value(forKey: "userName")
        if name != nil
        {
            merchantname = UserDefaults.standard.value(forKey: "userName")! as! String
        }
        else
        {
            merchantname = ""
        }
        
            ConnectionManager.login(userId: merchantid, nickname: merchantname) { (user, error) in
                DispatchQueue.main.async {
                  
                }
                
                guard error == nil else {
                    let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                    let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
                    vc.addAction(closeAction)
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if self.groupChannelListViewController == nil {
                        self.groupChannelListViewController = GroupChannelListViewController(nibName: "GroupChannelListViewController", bundle: Bundle.main)
                        self.groupChannelListViewController?.addDelegates()
                    }
                    self.navigationController?.pushViewController(self.groupChannelListViewController!, animated: false)
//                    self.present(self.groupChannelListViewController!, animated: false) {
//                        self.groupChannelListViewController?.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                    }
//
                    
                    
                    
//                    self.createNewChannel()
                }
            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func connect() {
//
//
//        ConnectionManager.login(userId: userid, nickname: username) { (user, error) in
//            DispatchQueue.main.async {
////                self.userIdTextField.isEnabled = true
////                self.nicknameTextField.isEnabled = true
////
////                self.indicatorView.stopAnimating()
//            }
//
//            guard error == nil else {
//                let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
//                let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: nil)
//                vc.addAction(closeAction)
//                DispatchQueue.main.async {
//                    self.present(vc, animated: true, completion: nil)
//                }
//
//                return
//            }
//
//            DispatchQueue.main.async {
//                print("sidemenu")
//                self.createNewChannel()
//
////                let vc: MenuViewController = MenuViewController()
////                self.present(vc, animated: false, completion: nil)
//            }
//        }
//    }
   
    
    private var isDistinct: Bool = true
    
    @objc private func createNewChannel() {
        
        SBDGroupChannel.createChannel(withUserIds: [merchantid,merchantname], isDistinct: self.isDistinct, completionHandler: { (channel, error) in
            if error != nil {
                let vc = UIAlertController(title: Bundle.sbLocalizedStringForKey(key: "ErrorTitle"), message: error?.domain, preferredStyle: UIAlertController.Style.alert)
                let closeAction = UIAlertAction(title: Bundle.sbLocalizedStringForKey(key: "CloseButton"), style: UIAlertAction.Style.cancel, handler: { (action) in
                    
                })
                vc.addAction(closeAction)
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
                                
                return
            }
            
            self.delegate?.didFinishCreating(channel: channel!, vc: self)
            
            let vc = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
            vc.groupChannel = channel
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }

    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
