//
//  KeyframeViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/28/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class KeyframeValuesTimesViewController: UIViewController {

    @IBOutlet weak var movingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movingView.frame = CGRect(x: 25, y: 175, width: 50, height: 50)
    }
    
    @IBAction func play(_ sender: Any) {
        let theAnimation = CAKeyframeAnimation(keyPath: "position")
        theAnimation.duration = 5;
        theAnimation.values = [
            NSValue(cgRect: CGRect(x: 50, y: 200, width: 50, height: 50)),
            NSValue(cgRect: CGRect(x: 250, y: 200, width: 50, height: 50)),
            NSValue(cgRect: CGRect(x: 250, y: 400, width: 50, height: 50))
        ]
        theAnimation.keyTimes = [0, 0.2, 1]
        theAnimation.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        ]
        self.movingView.layer.add(theAnimation, forKey: "position")
        
    }
    
}
