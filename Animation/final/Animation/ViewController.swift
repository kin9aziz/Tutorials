//
//  ViewController.swift
//  Animation
//
//  Created by Quang Tran on 1/25/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    var displayingPrimary = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func toggle(_ sender: Any) {
        UIView.transition(from: displayingPrimary ? primaryView : secondaryView,
                          to: displayingPrimary ? secondaryView : primaryView,
                          duration: 3.0,
                          options: [displayingPrimary ? .transitionFlipFromRight : .transitionFlipFromLeft, .showHideTransitionViews])
                            { (finished) in
                                if (finished) {
                                    self.displayingPrimary = !self.displayingPrimary
                                }
                            }
    }
    
}

