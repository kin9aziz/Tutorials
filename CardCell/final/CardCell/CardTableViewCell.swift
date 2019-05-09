//
//  CardTableViewCell.swift
//  CardCell
//
//  Created by Quang Tran on 1/22/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleCardView()
    }
    
    private func styleCardView() {
        // Specify position of shadow
        cardView.layer.shadowOffset = CGSize(width: 6, height: 12)
        
        // Set blurriness of shadow
        cardView.layer.shadowRadius = 5
        
        // Set roundness of card view
        cardView.layer.cornerRadius = 5
        
        // Set opacity of shadow
        cardView.layer.shadowOpacity = 0.2
    }
}
