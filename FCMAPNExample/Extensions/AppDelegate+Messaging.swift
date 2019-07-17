//
//  AppDelegate+Messaging.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation
import Firebase
import Cadmus

/*
 Google messaging based functionality
 */

extension AppDelegate: MessagingDelegate {
  func initMessaging() {
    Messaging.messaging().delegate = self
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    log(debug: "fcmToken = \(fcmToken)")
    // Could store this in use defaults or something, but it seems to would be better
    // to use InstanceID.instanceID().instanceID 
  }
}
