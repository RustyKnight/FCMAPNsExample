//
//  Notification.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation
import RealmSwift
import FlowKit

// Message stored in realm
class Message: Object, ModelProtocol {
  @objc dynamic var identifier: String = ""
  @objc dynamic var date: Date = Date()
  @objc dynamic var title: String = ""
  @objc dynamic var body: String = ""
  
  // Requirement imposed by flowkit
  @objc dynamic fileprivate let guid: String = NSUUID().uuidString
  var id: Int {
    return guid.hashValue
  }
  
  override static func ignoredProperties() -> [String] {
    return ["guid"]
  }
  
  override static func primaryKey() -> String? {
    return "identifier"
  }
}
