//
//  UIAlertAction+DefaultActions.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation
import UIKit

// Common UIAlertActions
// Normally the text would be localised, but I didn't implement that in this project
extension UIAlertAction {
  
  static func ok(style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: "Ok",
                         style: style,
                         handler: handler)
  }
  
  static func cancel(style: UIAlertAction.Style = .cancel, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: "Cancel",
                         style: style,
                         handler: handler)
  }
  
  static func yes(style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: "Yes",
                         style: style,
                         handler: handler)
  }
  
  static func no(style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: "No",
                         style: style,
                         handler: handler)
  }
  
  // This will create cancel actions
  // On a table, this will create a "default" cancel operation and a "cancel" operation, so that
  // if the user taps anywhere on the screen, the "cancel" operation will be called
  // On a handset, this will only create the "cancel" operation
  static func cancelActions(performing: ((UIAlertAction) -> Void)? = nil) -> [UIAlertAction] {
    var actions: [UIAlertAction] = []
    if UIDevice.current.userInterfaceIdiom == .pad {
      actions.append(UIAlertAction.cancel(style: .default, handler: performing))
    }
    actions.append(UIAlertAction.cancel(style: .cancel, handler: performing))
    
    return actions
  }
  
  static func noActions(performing: ((UIAlertAction) -> Void)? = nil) -> [UIAlertAction] {
    var actions: [UIAlertAction] = []
    if UIDevice.current.userInterfaceIdiom == .pad {
      actions.append(UIAlertAction.no(style: .default, handler: performing))
    }
    actions.append(UIAlertAction.no(style: .cancel, handler: performing))
    
    return actions
  }
  
}
