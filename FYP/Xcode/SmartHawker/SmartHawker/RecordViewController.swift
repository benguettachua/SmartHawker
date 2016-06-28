//
//  RecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 27/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var COGS: UILabel!
    @IBOutlet weak var expenses: UILabel!
    
    @IBOutlet weak var dateSelectedLabel: UILabel!
    var shared = ShareData.sharedInstance // This is the date selected from Main Calendar.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the date selected
        let dateSelected = self.shared.dateSelected
        dateSelectedLabel.text = dateSelected
        
        let date = self.shared.date
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        
        let user = PFUser.currentUser()
        
        // Query to extract sales
        var query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("type", equalTo: 0)
        query.whereKey("date", equalTo: dateString)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Query Success
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    var totalSales = 0
                    for object in objects {
                        totalSales += object["amount"] as! Int
                    }
                    self.sales.text = String(totalSales)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
}
