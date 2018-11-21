//
//  AppDelegate+PushNotifications.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Hermes
import Hydra
import LogWrapperKit
import RealmSwift

/*
 Local/Push Notifications based functionality
 */

extension AppDelegate: WillPresentNotificiationDelegate {
  
  // The error message identifier, which we basically ignore
  static let errorIdentifier = "Error"
  
  // App notifications generated
  static let notificationArrived = NSNotification.Name("Notification.arrived")
  static let notificationsUpdate = NSNotification.Name("Notification.updated")

  // Delegate to handle how foreground notifications are handled
  func notificationService(_ service: NotificationService, willPresent notification: UNNotification) -> UNNotificationPresentationOptions {
    guard notification.request.identifier != AppDelegate.errorIdentifier else {
      return [.alert, .sound, .badge]
    }
    do {
      let realm = try Realm()
      let message = try add(notification, to: realm)
      NotificationCenter.default.post(name: AppDelegate.notificationArrived,
                                      object: nil,
                                      userInfo: ["message": message])
    } catch let error {
      log(error: error)
      NotificationServiceManager.shared.add(identifier: AppDelegate.errorIdentifier, title: "Error", body: "Failed to store new message")
        .catch { (error) in
          log(error: error)
      }
    }
    return []
  }
  
  /*
   Setup and register for notifications
   */
  func registerForNotifications() {
    // Notification when the app is brought to the foregound because the user tapped a notification
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didRecieveNotification),
                                           name: NotificationServiceManager.didRecieveNotification, object: nil)
    
    // This has the side effect of setting the UNUserNotificationCenterDelegate
    _ = NotificationServiceManager.shared.set(categories: [])
    NotificationServiceManager.shared.willPresentNotificiationDelegate = self
    // Request authorisation
    UNUserNotificationCenter.current().authorise(options: [.alert, .sound, .badge])
      .then(in: .main) { () in
        self.notificationSettings()
      }.catch(in: .main) { (error) in
        log(error: "User Notification authorisation failed: \(error)")
    }
  }

  // Used to register for remote nortifications
  func notificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.onMainThread {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
  // When notification is tapped by user
  @objc func didRecieveNotification(_ notification: Notification) {
    guard let userInfo = notification.userInfo, let payload = userInfo[NotificationManagerPayload.response] as? UNNotificationResponse else {
      log(warning: "Recivied notification, but not useful payload")
      return
    }
    do {
      try update([payload.notification])
      DispatchQueue.onMainThread {
        NotificationCenter.default.post(name: AppDelegate.notificationsUpdate,
                                        object: nil,
                                        userInfo: nil)
      }
    } catch let error {
      log(error: error)
    }
  }
  
  // Used to update the realm database when new notifications are detected
  func update(_ notifications: [UNNotification]) throws {
    
    guard notifications.count > 0 else {
      return
    }
    
    let realm = try Realm()
    let messages = realm.objects(Message.self)
    
    // Would be more efficient to wrap this in a single write block
    // Probably would also look at generating to sets, one for updates and
    // one for additions
    for notification in notifications {
      guard notification.request.identifier != AppDelegate.errorIdentifier else {
        continue
      }
      if let match = (messages.first { $0.identifier == notification.request.identifier }) {
        try self.update(match, against: notification, to: realm)
      } else {
        try self.add(notification, to: realm)
      }
    }
  }
  
  // Used to get all "delivered" notifications, which the user has not yet cleared
  // or tapped on, and add them to the realm database
  // Because the process "can" take a little bit of time, the function generates a
  // app notification when the notifications are updated.  This prevents possible
  // race conditions with other parts of the app
  func updateNotificationsList() {
    UNUserNotificationCenter.current().deliveredNotifications()
      .then(in: .main) { (notifications) in
        log(debug: "Found \(notifications.count) notifications")
        
        try self.update(notifications)
        
        return UNUserNotificationCenter.current().removeAllDeliveredNotifications()
      }.then(in: .main) { (removed) in
        NotificationCenter.default.post(name: AppDelegate.notificationsUpdate,
                                        object: nil,
                                        userInfo: nil)
      }.catch(in: .main) { (error) in
        log(error: error)
        NotificationServiceManager.shared.add(identifier: AppDelegate.errorIdentifier, title: "Error", body: "Failed to store new message")
          .catch { (error) in
            log(error: error)
        }
    }
  }
  
  // Used to update existing notifications, help prevent duplicates
  func update(_ message: Message, against notification: UNNotification, to realm: Realm) throws {
    try realm.write {
      let date = notification.date
      let content = notification.request.content
      let title = content.title
      let body = content.body
      
      message.date = date
      message.body = body
      message.title = title
    }
  }
  
  // Add a new message to the realm database
  @discardableResult
  func add(_ notification: UNNotification, to realm: Realm) throws -> Message {
    let id = notification.request.identifier
    let date = notification.date
    let content = notification.request.content
    let title = content.title
    let body = content.body
    
    log(debug: "\n\tid = \(notification.request.identifier)\n\t\(notification.date)")
    
    let message = Message()
    message.identifier = id
    message.date = date
    message.title = title
    message.body = body
    try realm.write {
      realm.add(message)
    }
    return message
  }
  
}
