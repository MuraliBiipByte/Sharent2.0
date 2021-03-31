//
//  AppDelegate.swift
//  Sharent
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.


import UIKit
import UserNotifications
import Firebase
import FirebaseAuth
import GoogleSignIn
import LGSideMenuController
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Stripe
import SendBirdSDK

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{

    var window: UIWindow?
    var storyboard:UIStoryboard!
    var userId :String?
    var userType :String?
    var loginemail :String?

    static let instance: NSCache<AnyObject, AnyObject> = NSCache()
     var receivedPushChannelUrl: String?
    
    static func imageCache() -> NSCache<AnyObject, AnyObject>! {
        if AppDelegate.instance.totalCostLimit == 104857600 {
            AppDelegate.instance.totalCostLimit = 104857600
        }
        
        return AppDelegate.instance
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        STPPaymentConfiguration.shared().publishableKey = STRIPE_PUBLISHABLE_KEY

        GMSPlacesClient.provideAPIKey(GMS_PROVIDEAPI_KEY)
        GMSServices.provideAPIKey(GMS_PROVIDEAPI_KEY)
        
        //old one
//        SBDMain.initWithApplicationId("9DA1B1F4-0BE6-4DA8-82C5-2E81DAB56F23")
       
        // new one
        SBDMain.initWithApplicationId("E71EA9A8-1009-4F1E-98A5-CB7CB996D4A2")
            SBDMain.setLogLevel(SBDLogLevel.none)
            SBDOptions.setUseMemberAsMessageSender(true)
        
//        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "https://shserv.sharent.com.sg/index.php/welcome/android/1"
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        registerForNotifications()
        
        GIDSignIn.sharedInstance().clientID = GOOGLE_SIGNIN_CLIENTID
        UINavigationBar.appearance().barTintColor = APP_COLOR
        UINavigationBar.appearance().tintColor = NAVIGATION_COLOR
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: NAVIGATION_FONT,NSAttributedStringKey.foregroundColor: NAVIGATION_COLOR]
        UITextField.appearance().tintColor = APPEARENCE_COLOR
        UITextView.appearance().tintColor = APPEARENCE_COLOR

        self.appVersion()
        
        
  
        return true
        
    }

//    func openCustomURLSchemeAction(strUrl : String) {
//        if let url = URL(string: strUrl) {
//            if UIApplication.shared.canOpenURL(url) {
//                if let url = URL(string: "https://shserv.sharent.com.sg/index.php/welcome/android/1") {
//                    UIApplication.shared.canOpenURL(url)
//
//                }
//            } else {
//                if let url = URL(string: "https://apps.apple.com/sg/app/sharent-rent-earn-save/id1422672482") {
//                    UIApplication.shared.canOpenURL(url)
//                }
//                print("Can't open url to show projects related to Swift examples")
//            }
//        }
//    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
  

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        if SBDMain.getConnectState() == .closed {
            print("closed")
           }
        else {
            print("opened")
        }
  
    }

    
    func registerForNotifications()
    {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in
            
            DispatchQueue.main.async
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            
        })
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.set(fcmToken, forKey: "fcm_Token")
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print(response)
    }
    
    func rootclassVc()
    {
        storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        userId = UserDefaults.standard.string(forKey: "user_id")
        userType = UserDefaults.standard.string(forKey: "user_type")
        loginemail = UserDefaults.standard.string(forKey: "email")
        if userType == MERCHANT
        {
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier:"MerchantHomeViewController"))!], animated: false)
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
            mainViewController.rootViewController = navigationController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
        }
        else  if userType == BUYER
        {
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController"))!], animated: false)
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
            mainViewController.rootViewController = navigationController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
        }
        else
        {
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewLoginViewController") as! NewLoginViewController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
            
        }
    }
    func appVersion()
    {
        let paramsDict:[String:Any] = ["api_key_data":WebServices.API_KEY]
        ApiManager().postRequest(service: WebServices.APP_VERSION, params: paramsDict) { (result, success) in
            
            if success == true
            {
                let resultDictionary = result as! [String : Any]
                guard let appVersion = resultDictionary["ios_version"] as? String else
                {
                    return
                }
                if APP_CURRENT_VERSION < Int(appVersion)!
                {
                    let title = "Update Available"
                    let message = "A new version is available in apple app store. Update soon to get the latest features"
                    self.showAlert(title: title, message: message)
                    
                }
                else
                {
                    self.rootclassVc()
                }
            }
        }
    }
    
    func showAlert(title:String,message:String)
    {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
            { action in
            
                if title != APP_NAME
                {
                   self.appstore()
                }
            }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func appstore()
    {
        if let url = URL(string: APPSTORE_URL),
            UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler:
                {
                (success) in
                exit(0)
                })
        }
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options:
        [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // if
        let isDynamicLink = DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url)
        // isDynamicLink {
        print(isDynamicLink)
        //            self.handleDynamicLink(isDynamicLink)
        print("I'm having a link through incoming dynamic link")
        // let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        //  handleDynamicLink(dynamicLink)
        return true
        
        //  }
        // Handle incoming URL with other methods as necessary
        // ...
        //  return false
    }
    

//    func application(_ app: UIApplication, open url: URL, options:
//        [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        print("I've received url through custom scheme \(url.absoluteString)")
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//            let x = self.handleIncomingDynamicLink(dynamicLink)
//            print(x)
//            return true
//        }else{
//            // google / facebook signin code here...
//            return false
//        }
//
//        //                // if
////        let isDynamicLink = DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url)
////        // isDynamicLink {
////        print(isDynamicLink)
////        //            self.handleDynamicLink(isDynamicLink)
////        print("I'm having a link through incoming dynamic link")
////        // let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
////        //  handleDynamicLink(dynamicLink)
////        return true
//
//        //  }
//        // Handle incoming URL with other methods as necessary
//        // ...
//        //  return false
//    }
    
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
    if let incomingUrl = userActivity.webpageURL {
                print(incomingUrl)
        
    let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl)  { (dynamicLink, error) in
        
        
        guard error == nil else {
            print("Found an error! \(error!.localizedDescription)")
            return
        }
        
                  //  let strongSelf = self
        if dynamicLink != nil {
           let x = self.handleIncomingDynamicLink(dynamicLink!)
            print(x)
            
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginPageView = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            loginPageView.strProductId = self.productID
            
            let rootViewController = navigationController
            rootViewController.pushViewController(loginPageView, animated: true)
                        self.window?.rootViewController = rootViewController
                        self.window?.makeKeyAndVisible()

                    }
                }
        if linkHandled {
            return true
        }else{
            
            // do other things with incoming URL
            print("Navigate to product description")
            
            return false
        }
//                return linkHandled
        
            }
            return false

        }
    else{
        return true
      }
    }
    var productID : String = ""
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
                guard let dynamicLink = dynamicLink else { return false }
                guard let deepLink = dynamicLink.url else { return false }
                let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
                let invitedBy = queryItems?.filter({(item) in item.name == "prodId"}).first?.value
                let user = Auth.auth().currentUser
                // If the user isn't signed in and the app was opened via an invitation
                // link, sign in the user anonymously and record the referrer UID in the
                // user's RTDB record.
//        print(user!)
        print(invitedBy!)
        
        
                if user == nil && invitedBy != nil {
                    self.productID = invitedBy!
                    print(self.productID)
                    
//                    Auth.auth().signInAnonymously() { (user, error) in
//                        if let user = user {
//                            print(user)
//                            guard let uid = Auth.auth().currentUser?.uid else { return }
//                            print(uid)
//                            let link = URL(string: "https://apps.apple.com/sg/app/sharent-rent-earn-save/id1422672482")
//                            print(link!)
//                        }
//                    }
                }
        
        return true
    }
    
    
    
//    @available(iOS 10.0, *)
//    func application(_ application: UIApplication,
//                     //                     continue userActivity: NSUserActivity,
////        restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
////        let dynamicLinks = DynamicLinks.dynamicLinks()
////        let handled = dynamicLinks.handleUniversalLink(userActivity!.webpageURL!) { (dynamicLink, error) in
////            if (dynamicLink != nil) && !(error != nil) {
////                let x = self.handleDynamicLink(dynamicLink)
////                print(x)
////            }
////        }
////        if !handled {
////            // Handle incoming URL with other methods as necessary
////            // ...
////        }
////        return handled
////    }
    //
//    func handleDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
//        guard let dynamicLink = dynamicLink else { return false }
//        guard let deepLink = dynamicLink.url else { return false }
//        let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
//        let invitedBy = queryItems?.filter({(item) in item.name == "invitedby"}).first?.value
//        let user = Auth.auth().currentUser
//        // If the user isn't signed in and the app was opened via an invitation
//        // link, sign in the user anonymously and record the referrer UID in the
//        // user's RTDB record.
//        if user == nil && invitedBy != nil {
//            Auth.auth().signInAnonymously() { (user, error) in
//                if let user = user {
//                    print(user)
//                    guard let uid = Auth.auth().currentUser?.uid else { return }
//                    print(uid)
//                    let link = URL(string: "https://apps.apple.com/sg/app/sharent-rent-earn-save/id1422672482")
//                    print(link!)
//                }
//            }
//        }
//
//        return true
//    }
    
    
    
    
}

