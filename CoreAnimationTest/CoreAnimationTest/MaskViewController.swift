//
//  MaskViewController.swift
//  CoreAnimationTest
//
//  Created by Quang Tran on 1/29/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        myView.layer.contents = UIImage(named: "bird")?.cgImage
        
        let mask = CALayer()
        mask.contents = UIImage(named: "mask")?.cgImage
        mask.frame = myView.bounds
        
        myView.layer.mask = mask        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}
