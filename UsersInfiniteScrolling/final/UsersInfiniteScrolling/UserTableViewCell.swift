//
//  UserCellTableViewCell.swift
//  UsersInfiniteScrolling
//
//  Created by Quang Tran on 5/7/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var companyLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var indicatorView: UIActivityIndicatorView!
  
  var user: User? {
    didSet {
      if let user = user {
        infoView.isHidden = false
        nameLabel.text = user.firstName + " " + user.lastName
        companyLabel.text = user.company
        emailLabel.text = user.email
        let firstChars = user.firstName.prefix(1) + user.lastName.prefix(1)
        let avatarUrl = URL(string: "https://dummyimage.com/100/\(user.avatarBackgroundColor)/fff.png&text=\(firstChars)")
        avatarView.sd_setImage(with: avatarUrl)
        indicatorView.stopAnimating()
      }
      else {
        infoView.isHidden = true
        indicatorView.startAnimating()
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    containerView.layer.cornerRadius = 5
    containerView.layer.masksToBounds = true
    
    avatarView.layer.cornerRadius = avatarView.bounds.size.height / 2
    avatarView.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    avatarView.sd_cancelCurrentImageLoad()
  }
  
}
