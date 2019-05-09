//
//  AnimationGroupViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/29/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class AnimationGroupViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func animate(_ sender: Any) {
        // Animation 1
        let widthAnim = CAKeyframeAnimation(keyPath: "borderWidth")
        widthAnim.values = [1.0, 10.0, 5.0, 30.0, 0.5, 15.0, 2.0, 50.0, 0.0]
        widthAnim.calculationMode = .paced

        // Animation 2
        let colorAnim = CAKeyframeAnimation(keyPath: "borderColor")
        colorAnim.values = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        colorAnim.calculationMode = .paced

        // Animation group
        let group = CAAnimationGroup()
        group.animations = [colorAnim, widthAnim]
        group.duration = 5.0

        animationView.layer.add(group, forKey: "BorderChanges")
    }
}
