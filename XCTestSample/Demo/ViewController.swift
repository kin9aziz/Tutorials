//
//  ViewController.swift
//  Demo
//
//  Created by Quang Tran on 2/20/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    public func sum2Numbers(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    @IBAction func showMessage(_ sender: Any) {
        messageLabel.text = "Hello World"
    }
}

