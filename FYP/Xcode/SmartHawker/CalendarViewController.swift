//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment

class CalendarViewcontroller: UIViewController{
    
    // Mark: Properties
    // Top Bar
    @IBOutlet weak var todayRecordView: UIView!
    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var profitText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var salesText: UILabel!
    @IBOutlet weak var navBarLogoutButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    var day: String!
    var actualMonthDate = moment(NSDate())
    var chosenMonthDate = NSDate()
    var calendarForChangeMonth = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    var tempCounter = 0
    var records = [RecordTable]()
    
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()

    @IBOutlet var MonthAndYear: UILabel!
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var date: Moment! {
        didSet {
            // title = date.format("MMMM d, yyyy")
        }
    }//for calendar
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Formatting to format as saved in DB.
        var correctDateString = ""
        if toShare.storeDate == nil{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
            correctDateString = dateFormatter.stringFromDate(NSDate())
        }else{
            correctDateString = toShare.dateString
        }
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            self.loadRecords(correctDateString)
            
            
        })
        
        
    }
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Formatting to format as saved in DB.
        var correctDateString = ""
        if toShare.dateString == nil{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            correctDateString = dateFormatter.stringFromDate(NSDate())
        }else{
            correctDateString = toShare.dateString
        }
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            self.loadRecords(correctDateString)
            
            
        })
        
        let isSubuser = toShare.isSubUser
        if (isSubuser) {
            self.logoutButton.hidden = false
        }
        
        
        calendar.delegate = self
        calendar.backgroundColor = UIColor.clearColor()
        if toShare.dateString != nil {
            calendar.selectDate(toShare.storeDate)
            self.MonthAndYear.text = self.toShare.storeDate.monthName.localized() + " / " + String(self.toShare.storeDate.year)
            loadRecords(toShare.dateString)
        }else{
            calendar.selectDate(moment(NSDate()))
        }
        todayRecordView.backgroundColor = UIColor(white: 1, alpha: 0.3)

    }
    
    @IBAction func nextMonth(sender: UIBarButtonItem) {
        
        let periodComponents = NSDateComponents()
        periodComponents.month = +1
        let newDate = calendarForChangeMonth!.dateByAddingComponents(
            periodComponents,
            toDate: chosenMonthDate,
            options: [])!
        actualMonthDate = moment(newDate)
        chosenMonthDate = newDate
        
        calendar.selectDate(actualMonthDate)
        MonthAndYear.text = actualMonthDate.monthName + " / " + String(actualMonthDate.year)
    }
    
    @IBAction func previousMonth(sender: UIBarButtonItem) {
        
        let periodComponents = NSDateComponents()
        periodComponents.month = -1
        let newDate = calendarForChangeMonth!.dateByAddingComponents(
            periodComponents,
            toDate: chosenMonthDate,
            options: [])!
        actualMonthDate = moment(newDate)
        chosenMonthDate = newDate
        
        calendar.selectDate(actualMonthDate)
        MonthAndYear.text = actualMonthDate.monthName + " / " + String(actualMonthDate.year)
    }
    @IBAction func logout(sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Once logged out, you will have to log in again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            PFUser.logOut()
            self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadRecords(correctDateString: String){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        var dates = [String]()
        for record in self.records {
            dates.append(record.date)
            if record.date.containsString(correctDateString){
                let type = record.type
                let amount = Double(record.amount)
                if (type == "Sales") {
                    salesAmount += amount
                } else if (type == "COGS") {
                    expensesAmount += amount
                } else if (type == "Expenses") {
                    expensesAmount += amount
                }
            }
            
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dates, forKey: "SavedDateArray")
        // Sales Label
        let salesString2dp = "$" + String(format:"%.2f", salesAmount)
        self.salesText.text = salesString2dp
        self.salesText.font = UIFont(name: salesText.font.fontName, size: 24)
        
        // Expenses Label
        let expensesString2dp = "$" + String(format:"%.2f", expensesAmount)
        self.expensesText.text = expensesString2dp
        self.expensesText.font = UIFont(name: expensesText.font.fontName, size: 24)
        
        // Profit Label
        let profitString2dp = "$" + String(format:"%.2f", (salesAmount-expensesAmount))
        self.profitText.text = profitString2dp
        self.profitText.font = UIFont(name: profitText.font.fontName, size: 24)
    }
    
        func loggedOut() {
            PFUser.logOut()
            self.performSegueWithIdentifier("logout", sender: self)
    }
    
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Load from local datastore into UI.
        self.records.removeAll()
        let query = PFQuery(className: "Record")
        let isSubUser = toShare.isSubUser
        if (isSubUser) {
            query.whereKey("subuser", equalTo: toShare.subuser)
        }
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
                        let amount = object["amount"] as! Double
                        var localIdentifierString = object["subUser"]
                        var recordedBy = object["subuser"]
                        if (recordedBy == nil) {
                            recordedBy = ""
                        }
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
                        
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
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
    
    @IBAction func Record(sender: UIBarButtonItem) {
        
        if toShare.dateString == nil{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(NSDate())
            
            if date.day == 1 || date.day == 21{
                self.day = String(date.day) + "st".localized()
                
            }else if date.day == 2 || date.day == 22{
                self.day = String(date.day) + "nd".localized()
                
            }else if date.day == 3 || date.day == 23{
                self.day = String(date.day) + "rd".localized()
                
            }else{
                self.day = String(date.day) + "th".localized()
            }
            
            var toDisplayDate = ""
            if lang == "zh-Hans" {
                toDisplayDate = date.monthName.localized() + " \(self.day) " + " \(date.year) 年, "+(date.weekdayName).localized()
            }else{
                toDisplayDate = self.day + " " + date.monthName + " " + String(date.year) + " , " + date.weekdayName
            }
            toShare.storeDate = date
            toShare.dateString = correctDateString
            toShare.toDisplayDate = toDisplayDate
            toShare.dateString = correctDateString
        }
        // Move to Record Page.
        self.performSegueWithIdentifier("dayRecord", sender: self)
        
        
    }
    
}


extension CalendarViewcontroller: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.date = date
        
        // Adding 8 hours due to timezone
        let duration = 8.hours
        let dateInNSDate = date.add(duration).date

        
        // Formatting to format as saved in DB.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(dateInNSDate)
        
        //for displaying date
        if date.day == 1 || date.day == 21{
            self.day = String(date.day) + "st".localized()
            
        }else if date.day == 2 || date.day == 22{
            self.day = String(date.day) + "nd".localized()
            
        }else if date.day == 3 || date.day == 23{
            self.day = String(date.day) + "rd".localized()
            
        }else{
            self.day = String(date.day) + "th".localized()
        }

        var toDisplayDate = ""
        if lang == "zh-Hans" {
            toDisplayDate = date.monthName.localized() + " \(self.day) " + " \(date.year) 年, "+(date.weekdayName).localized()
        }else{
            toDisplayDate = self.day + " " + date.monthName + " " + String(date.year) + " , " + date.weekdayName
        }
        toShare.storeDate = date
        toShare.dateString = correctDateString
        toShare.toDisplayDate = toDisplayDate
        loadRecords(correctDateString)
    }
    
    func calendarDidPageToDate(date: Moment) {

        self.date = date
        if toShare.storeDate == nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.MonthAndYear.text = date.monthName.localized() + " / " + String    (date.year)
            })
        } else {
            self.MonthAndYear.text = self.toShare.storeDate.monthName.localized() + " / " + String(self.toShare.storeDate.year)


        }

        
    }
    
    
    
}
