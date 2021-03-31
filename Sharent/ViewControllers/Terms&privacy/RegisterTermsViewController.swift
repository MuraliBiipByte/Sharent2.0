//
//  RegisterTermsViewController.swift
//  Sharent
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import WebKit
class RegisterTermsViewController: UIViewController,WKNavigationDelegate {
    
    var urlIndex = Int()
    
    @IBOutlet weak var wkWebView:WKWebView!
    @IBOutlet weak var navigationView:UIView!
    
    @IBOutlet weak var navigationTitle:UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationView.backgroundColor = APP_COLOR
        
        switch urlIndex
        {
        
        case 1:
            navigationTitle.text = "TERMS OF USE"
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.REGISTER_TERMS_CONDITIONS)
        case 2:
             navigationTitle.text = "SERVICE AGREEMENT"
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.SERVICE_AGREEMENT)
        case 3:
            navigationTitle.text = "PRIVACY POLICY"
            self.loadWebview(urlString: WebServices.BASE_URL_SERVICE+WebServices.PRIACY_POLICY)
        default:
            print("Something wrong")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
