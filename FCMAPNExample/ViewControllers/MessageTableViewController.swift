//
//  MessageTableViewController.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import UIKit
import FlowKit
import RealmSwift
import LogWrapperKit

// List of messages
class MessageTableViewController: UITableViewController {
  
  @IBOutlet var settingsItem: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // Settings icon
    settingsItem.image = APNExample.imageOfSettings(imageSize: CGSize(width: 25, height: 25))
    navigationItem.rightBarButtonItem = settingsItem
    
    configureMessageAdapter()
    configureMainSection()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Register for notifications to monitor for changes, to the database in particular
    NotificationCenter.default.addObserver(self, selector: #selector(notificationArrived), name: AppDelegate.notificationArrived, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(notificationsUpdated), name: AppDelegate.notificationsUpdate, object: nil)

    // Allow autolayout to control row size
    tableView.director.rowHeight = .autoLayout(estimated: 70)
    
    loadModel()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  // This basically binds the model/data with the cell
  func configureMessageAdapter() {
    let adpator = TableAdapter<Message, MessageTableViewCell>()
    adpator.on.dequeue = { ctx in
      ctx.cell?.configure(with: ctx.model)
    }
    adpator.on.tap = { ctx in
      return .deselectAnimated
    }
    tableView.director.register(adapter: adpator)
  }
  
  // Add the main section
  func configureMainSection() {
    let section = TableSection(headerTitle: nil, footerTitle: nil)
    self.tableView.director.add(section: section)
  }
  
  // Load the data from the database into the model
  // This is heavy handed as it remove all the existig rows and add all
  // the messages to the table again
  // Messages are sorted in time order, with the newest at the top
  func loadModel() {
    do {
      let realm = try Realm()
      let messages = realm.objects(Message.self).sorted(byKeyPath: "date").reversed()
      log(debug: "Load \(messages.count) messages")
      
      guard let section = tableView.director.section(at: 0) else {
        fatalError("Main section should have already be defined")
      }
      section.removeAll()
      for message in messages {
        section.add(model: message, at: nil)
      }
      
      tableView.director.reloadData()
    } catch let error {
      log(error: error)
      presentOkAlert(title: "Error", message: "Failed to load messages")
    }
  }
  
  @objc func notificationsUpdated(_ notification: Notification) {
    loadModel()
  }
  
  // Inserts the new message at the top the list
  @objc func notificationArrived(_ notification: Notification) {
    guard let userInfo = notification.userInfo, let message = userInfo["message"] as? Message else {
      presentOkAlert(message: "New message notification without message content")
      return
    }
    guard let section = tableView.director.section(at: 0) else {
      fatalError("Main section should have already be defined")
    }
    tableView.director.reloadData(after: { (director) -> (TableReloadAnimationProtocol?) in
      section.add(model: message, at: 0)
      return TableReloadAnimations.default()
    })
  }
}
