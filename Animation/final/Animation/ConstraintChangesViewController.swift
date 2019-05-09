//
//  ConstraintChangesViewController.swift
//  Animation
//
//  Created by Quang Tran on 1/26/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ConstraintChangesViewController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func moveView(_ sender: Any) {
        UIView.animate(withDuration: 2, delay: 1, animations: {
            self.topConstraint.constant = 400
            self.view.layoutIfNeeded()
        })
    }
}
