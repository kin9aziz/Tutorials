//
//  PropertyChangesViewController.swift
//  Animation
//
//  Created by Quang Tran on 1/26/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class PropertyChangesViewController: UIViewController {

    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var rotatingView: UIView!
    @IBOutlet weak var scalingView: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func moveView(_ sender: Any) {
        self.movingView.frame.origin.x = 25
        
        UIView.animate(
            withDuration: 1,
            animations: {
                self.movingView.frame.origin.x = 200
        })
    }

    @IBAction func rotateView(_ sender: Any) {
        self.rotatingView.transform = CGAffineTransform.identity
        
        UIView.animate(
            withDuration: 1,
            animations: {
                let transform = CGAffineTransform(rotationAngle: 180 * CGFloat.pi / 180)
                self.rotatingView.transform = transform
        })
    }
    
    @IBAction func scaleView(_ sender: Any) {
        self.scalingView.transform = CGAffineTransform.identity
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.autoreverse],
            animations: {
                let transform = CGAffineTransform(scaleX: 2, y: 2)
                self.scalingView.transform = transform
        })
    }
    
    @IBAction func changeAlpha(_ sender: Any) {
        self.alphaView.alpha = 1
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                UIView.setAnimationRepeatCount(2.5)
                self.alphaView.alpha = 0
        })
    }
    
    @IBAction func changeBackgroundColor(_ sender: Any) {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.backgroundColorView.backgroundColor = UIColor.yellow
        })
    }
}
