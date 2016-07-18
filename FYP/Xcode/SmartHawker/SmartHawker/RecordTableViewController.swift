//
//  RecordTableViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

protocol MyCustomerCellDelegator {
    func callSegueFromCell (myData dataobject: AnyObject)
    func backToRecordFromCell()
    func unableToDeleteOrEdit()
}

import UIKit

class RecordTableViewController: UITableViewController, MyCustomerCellDelegator {
    
    // MARK: Properties
    var records = [RecordTable]()
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records = shared.records
        records.sortInPlace({$0.amount > $1.amount}) // Sort the records in descending order of amount.
        navBarTitle.title = "Records for " + shared.dateString
        navBar.frame = CGRectMake(0, 0, 320, 64)
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        // Fetches the appropriate record for the data source layout.
        let record = records[indexPath.row]
        print(record.toString())
        cell.dateLabel.text = record.date
        cell.typeLabel.text = record.type
        cell.descriptionLabel.text = record.description
        if record.type == "Sales"{
            cell.typeLabel.textColor = UIColor.greenColor()
            cell.amountLabel.textColor = UIColor.greenColor()
        }else{
            cell.typeLabel.textColor = UIColor.redColor()
            cell.amountLabel.textColor = UIColor.redColor()
        }
        if (record.amount > 0) {
            cell.amountLabel.text = String(record.amount)
        } else {
            cell.amountLabel.text = "Deleted"
        }
        
        // Alternate colour
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.grayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        //setting color for the amount
        cell.rowSelected = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegueWithIdentifier("updateRecord", sender: dataobject )
        
    }
    
    func backToRecordFromCell() {
        
        // Moves back to Record Table View Controller
        self.performSegueWithIdentifier("backToRecord", sender: self)
    }
    
    func unableToDeleteOrEdit() {
        let alertController = UIAlertController(title: "Unable to edit/delete", message: "Record is not saved. Please check your network connection and try again.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
