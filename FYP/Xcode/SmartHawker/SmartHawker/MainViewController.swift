//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import SwiftMoment

class MainViewcontroller: UIViewController{
    
    // Mark: Properties
    var tempCounter = 0
    var records = [RecordTable]()
    var day: String!
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    
    //for highest , lowest and average
    @IBOutlet weak var lowestSales: UILabel!
    @IBOutlet weak var highestSales: UILabel!
    @IBOutlet weak var averageSales: UILabel!
    @IBOutlet weak var lowestSalesDay: UILabel!
    @IBOutlet weak var highestSalesDay: UILabel!
    
    @IBOutlet weak var lowestProfit: UILabel!
    @IBOutlet weak var highestProfit: UILabel!
    @IBOutlet weak var averageProfit: UILabel!
    @IBOutlet weak var lowestProfitDay: UILabel!
    @IBOutlet weak var highestProfitDay: UILabel!
    
    @IBOutlet weak var otherExpensesAmount: UILabel!
    @IBOutlet weak var COGSAmount: UILabel!
    @IBOutlet weak var salesAmount: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.

    
    override func viewDidLoad() {
        super.viewDidLoad()

        var toDisplayDate = "Overview as of "
        let date = moment(NSDate())
        var dayString = ""
        if date.day == 1 || date.day == 21{
            dayString = String(date.day) + "st".localized()
            
        }else if date.day == 2 || date.day == 22{
            dayString = String(date.day) + "nd".localized()
            
        }else if date.day == 3 || date.day == 23{
            dayString = String(date.day) + "rd".localized()
            
        }else{
            dayString = String(date.day) + "th".localized()
        }
        if lang == "zh-Hans" {
            toDisplayDate += date.monthName.localized() + " \(self.day) " + " \(date.year) 年"
        }else{
            toDisplayDate += dayString + " " + date.monthName + " " + String(date.year)
        }
        overviewLabel.text = toDisplayDate
        
        // Formatting to format as saved in DB.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(NSDate())
        
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            var totalSales = 0.0
            var totalDays = 0.0
            var highSales: Double!
            var highSalesDay: String!
            var highProfit: Double!
            var highProfitDay: String!
            var lowSales: Double!
            var lowSalesDay: String!
            var lowProfit: Double!
            var lowProfitDay: String!
            var totalProfit = 0.0
            var COGS = 0.0
            var expenses = 0.0
            for record in self.records {
                
                var profit = 0.0
                let recordDate = dateFormatter.dateFromString(record.date)
                let earlier = recordDate!.earlierDate(NSDate()).isEqualToDate(recordDate!) && record.date.containsString(correctDateString)
                let same = recordDate!.isEqualToDate(NSDate())
                
                if earlier || same {
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        totalProfit += amount
                        totalSales += amount
                        profit += amount
                        //to get max and min sales
                        if highSales == nil{
                            highSales = amount
                            highSalesDay = record.date
                        }else if amount > highSales{
                            highSales = amount
                            highSalesDay = record.date
                        }
                        
                        if lowSales == nil{
                            lowSales = amount
                            lowSalesDay = record.date
                        }else if amount < lowSales{
                            lowSales = amount
                            lowSalesDay = record.date
                        }
                        
                        
                    } else if (type == "COGS") {
                        COGS += amount
                        profit -= amount
                        totalProfit -= amount
                    } else if (type == "Expenses") {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    }
                    print(profit)
                    if highProfit == nil{
                        highProfit = profit
                        highProfitDay = record.date
                    }else if profit > highProfit{
                        highProfit = profit
                        highProfitDay = record.date
                    }
                    
                    if lowProfit == nil{
                        lowProfit = profit
                        lowProfitDay = record.date
                    }else if profit < lowProfit{
                        lowProfit = profit
                        lowProfitDay = record.date
                    }
                    
                    totalDays += 1.0
                }
                
            }
            if totalDays == 0.0 {
                highSales = 0.0
                highProfit = 0.0
                lowSales = 0.0
                lowProfit = 0.0
                highProfitDay = "None"
                lowProfitDay = "None"
                highSalesDay = "None"
                lowSalesDay = "None"
            }
            self.salesAmount.text = String(totalSales)
            self.COGSAmount.text = String(COGS)
            self.otherExpensesAmount.text = String(expenses)
            self.highestProfit.text = String(highProfit)
            self.lowestProfit.text = String(lowProfit)
            self.averageProfit.text = String((totalProfit/totalDays))
            self.highestSales.text = String(highSales)
            self.lowestSales.text = String(lowSales)
            self.averageSales.text = String((totalSales/totalDays))
            self.highestProfitDay.text = highProfitDay
            self.lowestProfitDay.text = lowProfitDay
            self.highestSalesDay.text = highSalesDay
            self.lowestSalesDay.text = lowSalesDay
            
        })
        
    }

    
    @IBAction func Logout(sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.loggedOut()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }

    
    func loggedOut() {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Load from local datastore into UI.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let date = object["date"] as! String
                        let type = object["type"] as! Int
                        let amount = object["amount"] as! Int
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        } else if (type == 3){
                            typeString = "fixMonthlyExpenses"
                        }
                        
                        var description = object["description"]
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        self.records.append(newRecord)
                    }
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
 
    
    
}
