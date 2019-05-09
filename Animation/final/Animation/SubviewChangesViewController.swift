//
//  SubviewChangesViewController.swift
//  Animation
//
//  Created by Quang Tran on 1/26/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class SubviewChangesViewController: UIViewController {
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var swapLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tearCalendar(_ sender: Any) {
        UIView.transition(
            with: calendarView,
            duration: 2,
            options: .transitionCurlUp,
            animations: {
                self.currentLabel.isHidden = true
                self.swapLabel.isHidden = false
        }) { (finished) in
            self.currentLabel.text = String(format: "%d", Int(self.currentLabel.text!)! + 2)
            let temp = self.currentLabel
            self.currentLabel = self.swapLabel
            self.swapLabel = temp
            
        }
    }
}
