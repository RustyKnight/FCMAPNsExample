//
//  MessageTableViewCell.swift
//  FCMAPNExample
//
//  Created by Shane Whitehead on 21/11/18.
//  Copyright © 2018 Kaizen Enteripises. All rights reserved.
//

import UIKit

// Message table view cell
class MessageTableViewCell: UITableViewCell {
  
  static var dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }()
  
  @IBOutlet weak var messageImageView: UIImageView!
  @IBOutlet weak var messageTitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure(with message: Message) {
    // The image could be static (its cached by paint code)
    // but I like to be able to provide a configuration point
    messageImageView.image = APNExample.imageOfMessage(imageSize: CGSize(width: 50, height: 50))
    messageTitleLabel.text = message.title
    messageLabel.text = message.body
    dateLabel.text = MessageTableViewCell.dateFormat.string(from: message.date)
  }
  
}
