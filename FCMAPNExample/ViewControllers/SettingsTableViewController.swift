//
//  SettingsTableViewController.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import UIKit
import Firebase
import LogWrapperKit
import RealmSwift

/*
 This is a static table, it's a little lazy, but since there are only two rows, and they have
 very specific functionality, it was simpler and quicker to setup
 */

class SettingsTableViewController: UITableViewController {
  
  @IBOutlet weak var keyCell: UITableViewCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      presentYesNoAlert(title: "Clear all messages", message: "Are you sure?", whenYesed: { (action) in
        self.removeAllMessages()
      })
    } else if indexPath.row == 1 {
      InstanceID.instanceID().instanceID { (result, error) in
        if let error = error {
          log(error: error)
          self.presentOkAlert(title: "Error", message: "Could not find FCM client key")
        } else if let result = result {
          self.present(token: result.token)
        } else {
          self.presentOkAlert(title: "Error", message: "Could not find FCM client key")
        }
      }
    }
  }
  
  func removeAllMessages() {
    do {
      let realm = try Realm()
      try realm.write {
        realm.deleteAll()
      }
      NotificationCenter.default.post(name: AppDelegate.notificationsUpdate,
                                      object: nil,
                                      userInfo: nil)
      // Is it worth also removing all the "delivered" notifications while
      // we're here?
      presentOkAlert(message: "All the messages have been remove")
    } catch let error {
      log(error: error)
      self.presentOkAlert(title: "Error", message: "Could remove existing messages")
    }
  }
  
  func present(token: String) {
    let okAction = UIAlertAction.ok()
//    let copyAction = UIAlertAction(title: "Copy", style: .default) { (action) in
//      UIPasteboard.general.string
//    }
    let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
      let controller = UIActivityViewController(activityItems: [token], applicationActivities: nil)
      controller.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
      
      // exclude some activity types from the list (optional)
      controller.excludedActivityTypes = [
        UIActivity.ActivityType.postToVimeo,
        UIActivity.ActivityType.postToWeibo,
        UIActivity.ActivityType.postToFlickr,
        UIActivity.ActivityType.postToTwitter,
        UIActivity.ActivityType.postToFacebook,
        UIActivity.ActivityType.postToTencentWeibo,
        UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.addToReadingList,
        UIActivity.ActivityType.markupAsPDF,
        UIActivity.ActivityType.openInIBooks,
      ]
      
      // present the view controller
      self.present(controller, animated: true, completion: nil)
    }
    
    self.presentAlert(title: "FCM",
                      message: token,
                      actions: [
                        okAction,
//                        copyAction,
                        shareAction])
  }
}
