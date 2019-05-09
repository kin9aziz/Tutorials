//
//  BounceViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/28/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class KeyframePathViewController: UIViewController {

    @IBOutlet weak var bounceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bounceView.center = CGPoint(x: 0, y: 300)
    }
    
    @IBAction func play(_ sender: Any) {
        let thePath = CGMutablePath()
        thePath.move(to: CGPoint(x: 0, y: 300))
        thePath.addCurve(to: CGPoint(x: 200, y: 300),
                         control1: CGPoint(x: 0, y: 50),
                         control2: CGPoint(x: 200, y: 50))
        thePath.addCurve(to: CGPoint(x: 400, y: 300),
                         control1: CGPoint(x: 200, y: 50),
                         control2: CGPoint(x: 400, y: 50))
        
        let theAnimaton = CAKeyframeAnimation(keyPath: "position")
        theAnimaton.path = thePath
        theAnimaton.duration = 5
        self.bounceView.layer.add(theAnimaton, forKey: "position")
        
        
    }
}
