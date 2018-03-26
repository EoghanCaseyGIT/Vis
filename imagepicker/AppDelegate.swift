//
//  AppDelegate.swift
//  imagepicker
//
//  Created by Eoghan Casey on 07/03/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Moltin

// Declare some global constants to make them easily accessible in other classes.

let client_ID = "umRG34nxZVGIuCSPfYf8biBSvtABgTR8GMUtflyE"
//let Moltin.clientID = "79KdddnVIBnSCLI9CJDd2qLNAhdLoLFHYPEX0qWuhh"

let MOLTIN_LOGGING = true

// RGB: 139, 98, 181
let MOLTIN_COLOR = UIColor(red: (139.0/255.0), green: (98.0/255.0), blue: (181.0/255.0), alpha: 1.0)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init(){
        super.init()
        
        FirebaseApp.configure()
//        setRootViewController()
//        logUser()
        
    }
    
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set the window's tint color to the Moltin color
        self.window?.tintColor = MOLTIN_COLOR
        
        // Initialise the Moltin SDK with our store ID.
        Moltin.sharedInstance().setPublicId(client_ID)
        
        // Do you want the Moltin SDK to log API calls? (This should probably be false in production apps...)
        Moltin.sharedInstance().setLoggingEnabled(MOLTIN_LOGGING)
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func switchToCartTab() {
        let tabBarController = self.window!.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        
    }
    
        //code to show if a user doesn't sign out, they're brought straight to the tabBarController
    
//    func logUser(){
//
//        if Auth.auth().currentUser != nil {
//            let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
//            self.window?.rootViewController = tabBar
//
//        }
//    }
    
//    func setRootViewController() {
//        if Auth.auth().currentUser != nil {
//            // Set Your home view controller Here as root View Controller
//            self.presentTabBar()
//        } else {
//            // Set you login view controller here as root view controller
//        }
//    }
//
//
//    func presentTabBar(){
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier :"myTabBar")
//        self.present(viewController, animated: true)
//    }
}

