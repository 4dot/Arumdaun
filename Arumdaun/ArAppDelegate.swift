//
//  ArAppDelegate.swift
//  Arumdaun
//
//  Created by Park, Chanick on 6/21/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import HockeySDK
import OneSignal
import UserNotifications
import AVFoundation

var isLandscape = false

@UIApplicationMain
class ArAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // init hockeyapp
        initHockeyApp()
        
        // init tracker
        ArAnalytics.initWoopra()
        
        // init OpenSignal
        initPushNotification(launchOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            // Handle setCategory failure
            print(error)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // send user information to woopra
        ArAnalytics.addTrackProperty(["name" : ArDevice.userName,
                                     "version" : ArUtils.versionString(),
                                     "uuid" : ArDevice.deviceUUID,
                                     "devicetype" : ArDevice.deviceModel])
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if isLandscape {
            return UIInterfaceOrientationMask.all;
        }else{
            return UIInterfaceOrientationMask.portrait;
            
        }
    }
}

extension ArAppDelegate : BITHockeyManagerDelegate {
    // MARK: - HockeyApp
    func initHockeyApp() {
        //
        // Set HockeyApp SDK
        //
        BITHockeyManager.shared().configure(withIdentifier: "5865b525e1e4461b8d7d573ca105d7bc")
        
        // This line is obsolete in the crash only build
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        BITHockeyManager.shared().logLevel = .debug
        
        // AutoSend Crash Report to HockeyApp
        BITHockeyManager.shared().crashManager.crashManagerStatus = .autoSend
        
        // Enable In-App updated notification
        BITHockeyManager.shared().isStoreUpdateManagerEnabled = true
        
        BITHockeyManager.shared().start()
    }
}

extension ArAppDelegate {
    func initPushNotification(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "908b6d2c-7d75-4d3d-ad24-02904d8581a0",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let   tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        // kDeviceToken=tokenString
        print("deviceToken: \(tokenString)")
    }
}
