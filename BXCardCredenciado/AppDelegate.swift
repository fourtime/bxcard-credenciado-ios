//
//  AppDelegate.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Ok"
        
        ConnectivityService.instance.startConnectionListener()
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: { _, _ in
        })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        TerminalService.instance.invalidateRenewTimer()
        ConnectivityService.instance.stopConnectionListener()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        TerminalService.instance.login(withCompletion: nil)
        ConnectivityService.instance.startConnectionListener()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ConnectivityService.instance.stopConnectionListener()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("didRegister with notification settings")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notification with device token \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error on registering for remote notification - \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(fcmToken ?? "")")

        if let fcmToken = fcmToken, fcmToken != DataService.instance.fcmToken {
            DataService.instance.fcmToken = fcmToken
        }
    }
    
}

