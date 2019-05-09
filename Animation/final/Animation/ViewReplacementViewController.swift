//
//  ViewReplacementViewController.swift
//  Animation
//
//  Created by Quang Tran on 1/26/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ViewReplacementViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    
    var displayingFront = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func flip(_ sender: Any) {
        UIView.transition(
            from: displayingFront ? frontImageView : backImageView,
            to: displayingFront ? backImageView : frontImageView,
            duration: 1,
            options: [displayingFront ? .transitionFlipFromRight : .transitionFlipFromLeft, .showHideTransitionViews]) { (finished) in
                if (finished) {
                    self.displayingFront = !self.displayingFront
                }
        }
    }
    
}
