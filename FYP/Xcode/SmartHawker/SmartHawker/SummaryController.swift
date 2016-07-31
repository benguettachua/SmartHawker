//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment

class SummaryController: UIViewController {
    
    
    // MARK: Properties
    @IBOutlet weak var weekMonthYear: UILabel!
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
    var fixRecords = [RecordTable]()
    var years = [Int]()
    var year = Int()
    var actualMonthDate = moment(NSDate())
    var chosenMonthDate = NSDate()
    var actualYearDate = moment(NSDate())
    var chosenYearDate = NSDate()
    var actualWeekDate = moment(NSDate())
    var chosenWeekDate = NSDate()
    var daysInWeek = [NSDate()]
    
    
    //1 = monthly, 2 = yearly, 0 = weekly
    var summaryType = 1
    
    
    var calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    let user = PFUser.currentUser()
    @IBOutlet weak var recurringLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var expensesAmount: UITextField!
    @IBOutlet weak var descriptor: UITextField!
    @IBOutlet weak var descriptorLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var recordSuccessLabel: UILabel!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    
    @IBOutlet weak var summarytitle: UILabel!
    
    @IBOutlet weak var profitText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var salesText: UILabel!
    typealias CompletionHandler = (success:Bool) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "Avenir-BlackOblique", size: 22)!]
        let underlineAttributedString = NSAttributedString(string: "Month", attributes: underlineAttribute)
        
        
        monthButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        
        //Here I’m creating the calendar instance that we will operate with:
        
        weekMonthYear.text = actualMonthDate.monthName + " " + String(actualMonthDate.year)
        
        //Now asking the calendar what month are we in today’s date:
        
        if actualMonthDate.month < 10 {
            currentMonthString = "0" + String(actualMonthDate.month)
        }else{
            currentMonthString = String(actualMonthDate.month)
        }
        dateString = currentMonthString + "/" + String(actualMonthDate.year)
        
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            
            
            var salesAmount = 0.0
            var expensesAmount = 0.0
            for record in self.records {
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
    
    func loadRecords(){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        for record in self.records {
            
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
    
    
    func loadRecordsYearly(){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        for record in self.records {
            
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
    
    
    
    
    //to chnage the week/month/year
    @IBAction func previous(sender: UIButton) {
        if summaryType == 1 {
            let periodComponents = NSDateComponents()
            periodComponents.month = -1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenMonthDate,
                options: [])!
            actualMonthDate = moment(newDate)
            chosenMonthDate = newDate
            
            weekMonthYear.text = actualMonthDate.monthName + " " + String(actualMonthDate.year)
            
            if actualMonthDate.month < 10 {
                currentMonthString = "0" + String(actualMonthDate.month)
            }else{
                currentMonthString = String(actualMonthDate.month)
            }
            
            dateString = currentMonthString + "/" + String(actualMonthDate.year)
            loadRecords()
        }else if summaryType == 2 {
            let periodComponents = NSDateComponents()
            periodComponents.year = -1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenYearDate,
                options: [])!
            actualYearDate = moment(newDate)
            chosenYearDate = newDate
            
            weekMonthYear.text = String(actualYearDate.year)
            
            dateString = String(actualYearDate.year)
            loadRecordsYearly()
            
            
        }else if summaryType == 0 {
            let periodComponents = NSDateComponents()
            periodComponents.weekOfMonth = -1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenYearDate,
                options: [])!
            actualYearDate = moment(newDate)
            chosenYearDate = newDate
            
            weekMonthYear.text = String(actualYearDate.year)
            
            dateString = String(actualYearDate.year)
            loadRecordsYearly()
            
            
        }
        
    }
    @IBAction func next(sender: UIButton) {
        if summaryType == 1 {
            let periodComponents = NSDateComponents()
            periodComponents.month = +1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenMonthDate,
                options: [])!
            actualMonthDate = moment(newDate)
            chosenMonthDate = newDate
            
            weekMonthYear.text = actualMonthDate.monthName + " " + String(actualMonthDate.year)
            
            if actualMonthDate.month < 10 {
                currentMonthString = "0"+String(actualMonthDate.month)
            }else{
                currentMonthString = String(actualMonthDate.month)
            }
            
            dateString = currentMonthString + "/" + String(actualMonthDate.year)
            
            loadRecords()
        }else if summaryType == 2 {
            let periodComponents = NSDateComponents()
            periodComponents.year = +1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenYearDate,
                options: [])!
            actualYearDate = moment(newDate)
            chosenYearDate = newDate
            
            weekMonthYear.text = String(actualYearDate.year)
            
            dateString = String(actualYearDate.year)
            loadRecordsYearly()
            
            
        }else if summaryType == 0 {
            let periodComponents = NSDateComponents()
            periodComponents.weekOfMonth = +1
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenYearDate,
                options: [])!
            actualYearDate = moment(newDate)
            chosenYearDate = newDate
            
            weekMonthYear.text = String(actualYearDate.year)
            
            dateString = String(actualYearDate.year)
            loadRecordsYearly()
            
            
        }
    }
    
    //to change the category to week/month/year
    @IBAction func week(sender: UIButton) {
        
        summaryType = 0

        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "Avenir-BlackOblique", size: 22)!]
        
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 15)!]
        
        
        let underlineAttributedString2 = NSAttributedString(string: "Month", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Year", attributes: underlineAttribute2)
        let underlineAttributedString = NSAttributedString(string: "Week", attributes: underlineAttribute)
        weekButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        monthButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        weekButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        summarytitle.text = "Weekly Summary"
        loadRecords()
    }
    
    @IBAction func month(sender: UIButton) {
        
        summaryType = 1
        
        //Here I’m creating the calendar instance that we will operate with:
        weekMonthYear.text = actualMonthDate.monthName + " " + String(actualMonthDate.year)
        //Now asking the calendar what month are we in today’s date:
        if actualMonthDate.month < 10 {
            currentMonthString = "0" + String(actualMonthDate.month)
        }else{
            currentMonthString = String(actualMonthDate.month)
        }
        dateString = currentMonthString + "/" + String(actualMonthDate.year)
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "Avenir-BlackOblique", size: 22)!]
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 15)!]
        
        let underlineAttributedString = NSAttributedString(string: "Month", attributes: underlineAttribute)
        let underlineAttributedString2 = NSAttributedString(string: "Week", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Year", attributes: underlineAttribute2)
        
        monthButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        
        weekButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        monthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        summarytitle.text = "Monthly Summary"
        loadRecords()
    }
    
    @IBAction func year(sender: UIButton) {
        
        summaryType = 2
        
        //Here I’m creating the calendar instance that we will operate with:
        weekMonthYear.text = String(actualYearDate.year)
        dateString = String(actualYearDate.year)
        summarytitle.text = "Yearly Summary"
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "Avenir-BlackOblique", size: 22)!]
        let underlineAttributedString = NSAttributedString(string: "Year", attributes: underlineAttribute)
        
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 15)!]
        let underlineAttributedString2 = NSAttributedString(string: "Week", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Month", attributes: underlineAttribute2)
        
        monthButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        weekButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        
        yearButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        loadRecordsYearly()
    }
    
    /*
    //to get the years with records
    func getYearsWithRecords(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = ("dd/MM/yyyy")
        
        let array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
        for dateInString in array {
            let date = dateFormatter.dateFromString(dateInString)
            print(date)
            //Here I’m creating the calendar instance that we will operate with:
            let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
            //Now asking the calendar what year are we in today’s date:
            let currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: date!))
            if years.contains(currentYearInt!) == false {
                years.append(currentYearInt!)
            }
        }
        years = years.sort { $0 < $1 }
    }
 */
}
