//
//  LayerViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/30/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class MiscViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeBackgroundColor(_ sender: Any) {
        self.view1.layer.backgroundColor = UIColor.green.cgColor
    }
    
    @IBAction func addNewLayer(_ sender: Any) {
        let newLayer = CALayer()
        newLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        newLayer.backgroundColor = UIColor.blue.cgColor
        view2.layer.addSublayer(newLayer)
    }
    
    @IBAction func addCornerRadius(_ sender: Any) {
         view3.layer.cornerRadius = 10
    }
    
    @IBAction func addShadow(_ sender: Any) {
        view4.layer.shadowOpacity = 0.3
        view4.layer.shadowOffset = CGSize(width: 8, height: 10) // defaults to (0, -3)
        view4.layer.shadowRadius = 5 // defaults to 3
    }
    
    @IBAction func animateImplicitly(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            self.view5.layer.opacity = 0
        }
    }
    
    @IBAction func animteExplicitly(_ sender: Any) {
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0
        fadeAnim.duration = 1.0
        view6.layer.add(fadeAnim, forKey: "fadeAnim")
        view6.layer.opacity = 0.0
    }
    
    @IBAction func rotate3D(_ sender: Any) {
        let eyePosition: CGFloat = 250.0
        UIView.animate(withDuration: 2) {
            var rotate = CATransform3DMakeRotation(180 * CGFloat.pi / 180, 0.0, 1.0, 0.0)
            rotate.m34 = -1.0 / eyePosition
            self.view7.layer.transform = rotate
        }
    }
}
