//
//  NameTableViewController.swift
//  LoadMore
//
//  Created by Quang Tran on 1/21/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class NameTableViewController: UITableViewController {

    var data = [String]()
    var fetchingPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    private func fetchData() {
        fetchDataAsync { (newData) in
            self.insertNewData(newData: newData)
        }
    }
    
    // Simulate fetch data from services,
    // after completed fetched block will be called and pass new data
    private func fetchDataAsync(fetched: @escaping (_ newData: [String]) -> Void) {
        // Number of items will be returned
        let batches = [3, 3, 0, 3]
        
        // Delay before return new data
        let delays = [2.0, 2.0, 2.0, 2.0]
        
        guard fetchingPosition < batches.count else {
            fetched([])
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delays[fetchingPosition]) {
            var newData = [String]()
            for row in 0..<batches[self.fetchingPosition] {
                let rowContent = "Batch \(self.fetchingPosition) - Row \(row)"
                newData.append(rowContent)
            }
            self.fetchingPosition += 1
            fetched(newData)
        }
    }
    
    // Insert new data into table view
    private func insertNewData(newData: [String]) {
        if (newData.count > 0) {
            var newIndexPaths = [IndexPath]()
            for rowPosition in 0..<newData.count {
                let newIndexPath = IndexPath(row: self.data.count + rowPosition, section: 0)
                newIndexPaths.append(newIndexPath)
            }
            self.data += newData
            self.tableView.insertRows(at: newIndexPaths, with: .automatic)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    // Call fetchData method when last row is about to be presented
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == data.count - 1) {
            fetchData()
        }
    }

}
