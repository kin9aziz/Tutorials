//
//  NameTableViewController.swift
//  LoadMore
//
//  Created by Quang Tran on 1/21/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class NameTableViewController: UITableViewController {

    @IBOutlet weak var loadMoreDataView: UIView!
    @IBOutlet weak var noMoreDataView: UIView!
    
    var data = [String]()
    var fetchingPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // Fetch data again when Try Again button has been pressed
    @IBAction func tryLoadMoreDataAgain(_ sender: UIButton) {
        fetchData()
    }
    
    private func showLoadMoreDataView(_ show: Bool) {
        loadMoreDataView.isHidden = show ? false : true
        noMoreDataView.isHidden = show ? true : false
    }
    
    private func showLoadMoreDataView() {
        showLoadMoreDataView(true)
    }
    
    private func showNoMoreDataView() {
        showLoadMoreDataView(false)
    }
    
    // Handle show load more data view or no more data view when fetch data
    private func fetchData() {
        showLoadMoreDataView()
        fetchDataAsync { (newData) in
            if (newData.count == 0) {
                self.showNoMoreDataView()
            }
            else {
                self.insertNewData(newData: newData)
            }
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
