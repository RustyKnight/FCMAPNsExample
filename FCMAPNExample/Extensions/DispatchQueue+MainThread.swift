//
//  DispatchQueue+MainThread.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import Foundation

// Quick step methods to get code to run on the main thread
extension DispatchQueue {
  static func onMainThread(_ then: @escaping () -> Void) {
    guard !Thread.isMainThread else {
      then()
      return
    }
    DispatchQueue.main.async {
      then()
    }
  }
  static func laterOnMainThread(_ then: @escaping () -> Void) {
    DispatchQueue.main.async {
      then()
    }
  }
}
