//
//  AppDelegate.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import UIKit
import LogWrapperKit
import Hermes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    initFirebase()
    initMessaging()
    registerForNotifications()
    
    updateNotificationsList()
    
    return true
  }

  // APNS App token
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    
    let token = tokenParts.joined()
    log(debug: "Device Token: \(token)")
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    log(error: "\(error)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    log(debug: "")
    log(debug: "\(userInfo)")
  }
  
  // Make sure the list of messages is up-to-date
  func applicationWillEnterForeground(_ application: UIApplication) {
    updateNotificationsList()
  }

}

