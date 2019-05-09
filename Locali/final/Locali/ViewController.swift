//
//  ViewController.swift
//  Locali
//
//  Created by Quang Tran on 2/4/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var numbersLabel: UILabel!
    @IBOutlet weak var nounSingularsLabel: UILabel!
    @IBOutlet weak var nounPluralsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameLabel.text = NSLocalizedString("Name", comment: "")
        
        dateTimeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .long)

        numbersLabel.text = NumberFormatter.localizedString(from: 3.2, number: .currency)
        
        let messageTemplate = NSLocalizedString("%d file(s) remaining", comment: "Message shown for remaining files")
        nounSingularsLabel.text = String.localizedStringWithFormat(messageTemplate, 1)
        nounPluralsLabel.text = String.localizedStringWithFormat(messageTemplate, 5)
    }


}

