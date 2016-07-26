//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class MonthlySummaryController: UIViewController {
    
    
        // MARK: Properties
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var next: UIButton!
    var currentMonthInt = Int()
    var currentYearInt = Int()
    var currentMonthString = String()
    var currentYearString = String()
    var monthAndYear = String()
    var dateString = String()
    var tempCounter = 0
    var records = [RecordTable]()
    let user = PFUser.currentUser()
    
    @IBOutlet weak var profitText: UITextField!
    @IBOutlet weak var expensesText: UITextField!
    @IBOutlet weak var salesText: UITextField!
    typealias CompletionHandler = (success:Bool) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Here I’m creating the calendar instance that we will operate with:
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        //Now asking the calendar what month are we in today’s date:
        currentMonthInt = (calendar?.component(NSCalendarUnit.Month, fromDate: NSDate()))!
        currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: NSDate()))!
        setMonth()
        currentMonthString = String(currentMonthInt)
        currentYearString = String(currentYearInt)
        if currentMonthInt < 10 {
            currentMonthString = "0"+currentMonthString
        }
        dateString = currentMonthString + "/" + currentYearString

        loadRecordsFromLocaDatastore({ (success) -> Void in
            

                    
                    var salesAmount = 0.0
                    var expensesAmount = 0.0
                    for record in self.records {
                        print(record.date.containsString(self.dateString))
                        print(record.date)
                        print(self.dateString)
                        if record.date.containsString(self.dateString){
                            let type = record.type
                            let amount = Double(record.amount)
                            //let subuser = object["subuser"] as? String
                            if (type == "Sales") {
                                salesAmount += amount
                            } else if (type == "COGS") {
                                expensesAmount += amount
                            } else if (type == "Expenses") {
                                expensesAmount += amount
                            }
                            //print(subuser)
                        }
                        
                    }
                    
                    self.salesText.text = String(salesAmount)
                    self.expensesText.text = String(expensesAmount)
                    self.profitText.text = String(salesAmount - expensesAmount)

            
            
            
        })
    }
    
    @IBAction func previousMonth(sender: UIButton) {
        // Logs the user out if they are click Cancel
        if currentMonthInt > 1{
            currentMonthInt -= 1
        }
        setMonth()
        currentMonthString = String(currentMonthInt)
        currentYearString = String(currentYearInt)
        if currentMonthInt < 10 {
            currentMonthString = "0"+currentMonthString
        }
        dateString = currentMonthString + "/" + currentYearString
        
        loadRecords()
    }
    @IBAction func nextMonth(sender: UIButton) {
        // Logs the user out if they are click Cancel
        if currentMonthInt < 12{
            currentMonthInt += 1
        }
        setMonth()
        currentMonthString = String(currentMonthInt)
        currentYearString = String(currentYearInt)
        if currentMonthInt < 10 {
            currentMonthString = "0"+currentMonthString
        }
        dateString = currentMonthString + "/" + currentYearString
        
        loadRecords()
    }
    
    func setMonth(){
        if currentMonthInt == 1{
            month.text = "January"
        }else if currentMonthInt == 2{
            month.text = "February"
        }else if currentMonthInt == 3{
            month.text = "March"
        }else if currentMonthInt == 4{
            month.text = "April"
        }else if currentMonthInt == 5{
            month.text = "May"
        }else if currentMonthInt == 6{
            month.text = "June"
        }else if currentMonthInt == 7{
            month.text = "July"
        }else if currentMonthInt == 8{
            month.text = "August"
        }else if currentMonthInt == 9{
            month.text = "September"
        }else if currentMonthInt == 10{
            month.text = "October"
        }else if currentMonthInt == 11{
            month.text = "November"
        }else{
            month.text = "December"
        }
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
    
    func loadRecords(){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        for record in self.records {
            print(record.date.containsString(self.dateString))
            print(record.date)
            print(self.dateString)
            if record.date.containsString(self.dateString){
                let type = record.type
                let amount = Double(record.amount)
                //let subuser = object["subuser"] as? String
                if (type == "Sales") {
                    salesAmount += amount
                } else if (type == "COGS") {
                    expensesAmount += amount
                } else if (type == "Expenses") {
                    expensesAmount += amount
                }
                //print(subuser)
            }
            
        }
        
        self.salesText.text = String(salesAmount)
        self.expensesText.text = String(expensesAmount)
        self.profitText.text = String(salesAmount - expensesAmount)
    }
    
    
}
