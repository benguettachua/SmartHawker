//
//  RecordTableViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

protocol MyCustomerCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}

import UIKit

class RecordTableViewController: UITableViewController, MyCustomerCellDelegator {
    
    // MARK: Properties
    var records = [RecordTable]()
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records = shared.records
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any recourses that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        // Fetches the appropriate record for the data source layout.
        let record = records[indexPath.row]
        
        cell.dateLabel.text = record.date
        cell.typeLabel.text = record.type
        cell.amountLabel.text = String(record.amount)
        cell.rowSelected = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegueWithIdentifier("updateRecord", sender:dataobject )
        
    }
}
