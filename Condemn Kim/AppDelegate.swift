	//
//  AppDelegate.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 10/22/15.
//  Copyright (c) 2015 Brandon Lassiter. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse
import Bolts

import ParseFacebookUtilsV4
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions);
        FBSDKAppEvents.activateApp();
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("L6d8gYIOZ3TNTj7DV86VmW2bLKCWMP5lgg3GGGKR",
            clientKey: "p3VwjmX4oUvPGZA9QweEcbcIXPrFzDOqYm5XDRgO")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        AdColony.configureWithAppID("app069d5086d4d94626a9", zoneIDs: ["vz1720a2178a634eb581"], delegate: nil, logging: true)
        Supersonic.sharedInstance();
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        print("open URL appdelgate callback")
        return FBSDKApplicationDelegate.sharedInstance().application(application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

}

