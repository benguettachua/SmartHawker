//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment
import SwiftChart

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
    var daysInWeek = [String]()
    
    
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
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
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
    
    func loadRecordsWeekly(){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        for record in self.records {
            if daysInWeek.contains(record.date){
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
            daysInWeek.removeAll()
            let periodComponents = NSDateComponents()
            periodComponents.day = -7
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            actualWeekDate = moment(newDate)
            chosenWeekDate = newDate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dayOfWeek = actualWeekDate.weekday
            periodComponents.day = 2 - dayOfWeek
            let firstDayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            print(firstDayOfWeek)
            var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
            daysInWeek.append(correctDateString)
            weekMonthYear.text = String(correctDateString) + " - "
            for i in 1...6 {
                periodComponents.day = +i
                let dayOfWeek = calendar!.dateByAddingComponents(
                    periodComponents,
                    toDate: chosenWeekDate,
                    options: [])!
                print(dayOfWeek)
                correctDateString = dateFormatter.stringFromDate(dayOfWeek)
                daysInWeek.append(correctDateString)
            }

            
            weekMonthYear.text = weekMonthYear.text! + correctDateString
            loadRecordsWeekly()
            
            
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
            daysInWeek.removeAll()
            let periodComponents = NSDateComponents()
            periodComponents.day = +7
            let newDate = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            actualWeekDate = moment(newDate)
            chosenWeekDate = newDate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dayOfWeek = actualWeekDate.weekday
            periodComponents.day = 2 - dayOfWeek
            let firstDayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            print(firstDayOfWeek)
            var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
            daysInWeek.append(correctDateString)
            weekMonthYear.text = String(correctDateString) + " - "
            for i in 1...6 {
                periodComponents.day = +i
                let dayOfWeek = calendar!.dateByAddingComponents(
                    periodComponents,
                    toDate: chosenWeekDate,
                    options: [])!
                print(dayOfWeek)
                correctDateString = dateFormatter.stringFromDate(dayOfWeek)
                daysInWeek.append(correctDateString)
            }
            
            
            weekMonthYear.text = weekMonthYear.text! + correctDateString
            loadRecordsWeekly()
            
            
        }
    }
    
    //to change the category to week/month/year
    @IBAction func week(sender: UIButton) {
        daysInWeek.removeAll()
        summaryType = 0
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let periodComponents = NSDateComponents()
        let dayOfWeek = actualWeekDate.weekday
        periodComponents.day = 2 - dayOfWeek
        let firstDayOfWeek = calendar!.dateByAddingComponents(
            periodComponents,
            toDate: chosenWeekDate,
            options: [])!
        print(firstDayOfWeek)
        var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
        daysInWeek.append(correctDateString)
        weekMonthYear.text = String(correctDateString) + " - "
        for i in 1...6 {
            periodComponents.day = +i
            let dayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            print(dayOfWeek)
            correctDateString = dateFormatter.stringFromDate(dayOfWeek)
            daysInWeek.append(correctDateString)
        }
        
        
        weekMonthYear.text = weekMonthYear.text! + correctDateString
        loadRecordsWeekly()
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        
        
        let underlineAttributedString2 = NSAttributedString(string: "Month", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Year", attributes: underlineAttribute2)
        let underlineAttributedString = NSAttributedString(string: "Week", attributes: underlineAttribute)
        weekButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        monthButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        weekButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
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
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        
        let underlineAttributedString = NSAttributedString(string: "Month", attributes: underlineAttribute)
        let underlineAttributedString2 = NSAttributedString(string: "Week", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Year", attributes: underlineAttribute2)
        
        monthButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        
        weekButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        monthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
        loadRecords()
    }
    
    @IBAction func year(sender: UIButton) {
        
        summaryType = 2
        
        //Here I’m creating the calendar instance that we will operate with:
        weekMonthYear.text = String(actualYearDate.year)
        dateString = String(actualYearDate.year)
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        let underlineAttributedString = NSAttributedString(string: "Year", attributes: underlineAttribute)
        
        let underlineAttribute2 = [NSForegroundColorAttributeName: UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), NSFontAttributeName: UIFont(name: "Avenir-Light", size: 25)!]
        let underlineAttributedString2 = NSAttributedString(string: "Week", attributes: underlineAttribute2)
        let underlineAttributedString3 = NSAttributedString(string: "Month", attributes: underlineAttribute2)
        
        monthButton.setAttributedTitle(underlineAttributedString3, forState: UIControlState.Normal)
        
        weekButton.setAttributedTitle(underlineAttributedString2, forState: UIControlState.Normal)
        yearButton.setAttributedTitle(underlineAttributedString, forState: UIControlState.Normal)
        
        yearButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor(red:0.98, green:0.83, blue:0.72, alpha:1.0), forState: UIControlState.Normal)
        loadRecordsYearly()
    }

}
