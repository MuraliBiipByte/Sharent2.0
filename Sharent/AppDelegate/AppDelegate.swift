//
//  AppDelegate.swift
//  Sharent
//
//  Created by Biipbyte on 22/05/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import GoogleSignIn
import LGSideMenuController
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Stripe

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{
    
    

    var window: UIWindow?

    var storyboard:UIStoryboard!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        STPPaymentConfiguration.shared().publishableKey = Constants.STRIPE_PUBLISHABLE_KEY

        GMSPlacesClient.provideAPIKey(Constants.GMS_PROVIDEAPI_KEY)
        GMSServices.provideAPIKey(Constants.GMS_PROVIDEAPI_KEY)
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        registerForNotifications()
        
        GIDSignIn.sharedInstance().clientID = Constants.GOOGLE_SIGNIN_CLIENTID
        UINavigationBar.appearance().barTintColor = Constants.APP_COLOR
        UINavigationBar.appearance().tintColor = Constants.NAVIGATION_COLOR
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: Constants.NAVIGATION_FONT,NSAttributedStringKey.foregroundColor: Constants.NAVIGATION_COLOR]
        UITextField.appearance().tintColor = Constants.NAVIGATION_COLOR
        UITextView.appearance().tintColor = Constants.NAVIGATION_COLOR

        rootclassVc()
      
        return true
    }

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
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        
        return true
        // Process the URL.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        print(notification)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print(response)
    }
    
    func rootclassVc()
    {
        
        storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let userId = UserDefaults.standard.string(forKey: "user_id")
        let userType = UserDefaults.standard.string(forKey: "user_type")
        let introductionType = UserDefaults.standard.bool(forKey: "introduction_Flag")
        
        if introductionType == false
        {
            let introViewController = self.storyboard?.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
            let window = UIApplication.shared.delegate!.window!!;
            window.rootViewController = introViewController
        }
        else
        {
            if (userId != nil && userType == UserType.MERCHANT)
            {
                let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier:"MerchantHomeViewController"))!], animated: false)
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
                mainViewController.rootViewController = navigationController
                let window = UIApplication.shared.delegate!.window!
                window?.rootViewController = mainViewController
                
                
            }
            else
            {
                let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController"))!], animated: false)
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LGSideMenu") as! LGSideMenuController
                mainViewController.rootViewController = navigationController
                let window = UIApplication.shared.delegate!.window!
                window?.rootViewController = mainViewController
                
            }
        }
    }


}

