//
//  UIViewController+Alert.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation
import UIKit

// Alias to handle the "completed" state of a controller presentation
typealias thenHandler = () -> Void
// Basic action handler
typealias actionHandler = (UIAlertAction) -> Void

extension UIViewController {
  
  // Common alert controller
  func presentAlert(title: String? = nil,
                    message: String? = nil,
                    preferredStyle: UIAlertController.Style = .alert,
                    actions: [UIAlertAction],
                    then: thenHandler? = nil) {
    guard Thread.isMainThread else {
      DispatchQueue.onMainThread {
        self.presentAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions)
      }
      return
    }
    
    let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    for action in actions {
      controller.addAction(action)
    }
    
    self.present(controller, animated: true, completion: then)
  }

  // Alert controller with a ok button
  func presentOkAlert(title: String? = nil,
                    message: String? = nil,
                    preferredStyle: UIAlertController.Style = .alert,
                    whenOkayed: actionHandler? = nil,
                    then: thenHandler? = nil) {
    let actions: [UIAlertAction] = [UIAlertAction.ok { (action) in
      whenOkayed?(action)
    }]
    
    presentAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, then: then)
  }

  // Alert controller with a ok and cancel buttons
  func presentOkCancelAlert(title: String? = nil,
                      message: String? = nil,
                      preferredStyle: UIAlertController.Style = .alert,
                      whenOkayed: actionHandler? = nil,
                      whenCancelled: actionHandler? = nil,
                      then: thenHandler? = nil) {
    let actions: [UIAlertAction] = [
      UIAlertAction.ok { (action) in
        whenOkayed?(action)
      },
      UIAlertAction.cancel { (action) in
        whenCancelled?(action)
      }
    ]
    
    presentAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, then: then)
  }
  
  // Alert controller with a yes and no buttons
  func presentYesNoAlert(title: String? = nil,
                            message: String? = nil,
                            preferredStyle: UIAlertController.Style = .alert,
                            whenYesed: actionHandler? = nil,
                            whenNoed: actionHandler? = nil,
                            then: thenHandler? = nil) {
    let actions: [UIAlertAction] = [
      UIAlertAction.yes { (action) in
        whenYesed?(action)
      },
      UIAlertAction.no { (action) in
        whenNoed?(action)
      }
    ]
    
    presentAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, then: then)
  }
}
