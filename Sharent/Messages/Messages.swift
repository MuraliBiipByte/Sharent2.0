//
//  Messages.swift
//  Sharent
//
//  Created by Biipbyte on 30/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
final class Message
{
    
    static let shared = Message()
    
    func Alert(Title:String,Message:String, TitleAlign:AlertTextAllignment, MessageAlign:AlertTextAllignment,Actions:[UIAlertAction],Controller:UIViewController)
    {
        
        let Alert = UIAlertController.init(title: TitleAlign == .normal ? Title : nil, message: MessageAlign == .normal ? Message : nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let TitleStr:String? = Title == "Sharent" ? nil : Title
        let MsgStr:String? = Message == "" ? nil : Message
        
        var AttributedTitle = NSAttributedString()
        var AttributedMessage = NSAttributedString()
        
        
        if (TitleStr != nil) {
            if TitleAlign != .normal {
                let TitleParaStyle = NSMutableParagraphStyle()
                TitleParaStyle.alignment = TitleAlign == .left ? .left : .right
                AttributedTitle = NSAttributedString.init(string: TitleStr!, attributes: [NSAttributedStringKey.paragraphStyle:TitleParaStyle,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.black])
                Alert.setValue(AttributedTitle, forKey: "attributedTitle")
            }
        }
        
        if (MsgStr != nil) {
            if MessageAlign != .normal {
                let MessageParaStyle = NSMutableParagraphStyle()
                MessageParaStyle.alignment = MessageAlign == .left ? .left : .right
                AttributedMessage = NSAttributedString.init(string: MsgStr!, attributes: [NSAttributedStringKey.paragraphStyle:MessageParaStyle,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.darkGray])
                Alert.setValue(AttributedMessage, forKey: "attributedMessage")
            }
        }
        
        for Action in Actions {
            Alert.addAction(Action)
        }
        
        Controller.present(Alert, animated: true, completion: nil)
        
    }
    
    class func AlertActionWithSelector(Title:NSString,Selector:Selector,Controller:UIViewController) -> UIAlertAction
    {
        let Action = UIAlertAction.init(title: Title as String, style: UIAlertActionStyle.default, handler: { (AlertAction:UIAlertAction) in
            
            Controller.perform(Selector)
            
        })
        return Action
    }
    
    class func AlertActionWithOutSelector(Title:NSString) -> UIAlertAction
    {
        let Action = UIAlertAction.init(title: Title as String, style: UIAlertActionStyle.default, handler: nil)
        return Action
    }
    
    enum AlertTextAllignment
    {
        case left, right, normal
    }
}
