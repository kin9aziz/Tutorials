//
//  CardTableViewController.swift
//  CardCell
//
//  Created by Quang Tran on 1/22/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell

        return cell
    }
    
}
