//
//  PrivacyPolicyViewController.swift
//  Sharent
//  Created by Biipbyte on 28/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate
{
    
    @IBOutlet weak var wkWebView:WKWebView!
    
    var urlIndex = Int()
    var userLoginType : String? = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userLoginType = UserDefaults.standard.value(forKey: "user_type")as? String
        switch urlIndex
        {
        case 0:
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.PRIACY_POLICY)
        case 1:
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.TERMS_OF_USE)
        case 2:
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.CONTACT_US)
        case 3:
            
            if userLoginType == MERCHANT
            {
                self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.MERCHANT_FAQ)
            }
            else
            {
                self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.USER_FAQ)
            }
            
        case 4:
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.REGISTER_TERMS_CONDITIONS)
        default:
            print("Something wrong")
        }
    }
    
    func loadWebview(urlString:String)
    {
        let url = URL(string: (urlString as NSString) as String)
        let request = URLRequest(url: url!)
        wkWebView.navigationDelegate = self
        wkWebView.load(request)
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        self.view.StartLoading()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.view.StopLoading()
    }
    @IBAction func btn_Back_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
