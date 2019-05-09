//
//  TransitionViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/29/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {

    @IBOutlet weak var myView1: UIView!
    @IBOutlet weak var myView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func animate(_ sender: Any) {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = 1.0

        // Add the transition animation to both layers
        myView1.layer.add(transition, forKey: "transition")
        myView2.layer.add(transition, forKey: "transition")

        // Finally, change the visibility of the layers.
        myView1.isHidden = true
        myView2.isHidden = false
    }
}
