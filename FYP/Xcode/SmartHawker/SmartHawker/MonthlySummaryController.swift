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
    var fixRecords = [RecordTable]()
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
    
    
    @IBOutlet weak var profitText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var salesText: UILabel!
    typealias CompletionHandler = (success:Bool) -> Void

    var colors = ["Select Record Type","Rental","Electrical Bills"]
    var chosen = String()
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
                            } else if (type == "fixMonthlyExpenses"){
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
    
    //for switch
    
    @IBAction func actionTriggered(sender: AnyObject) {
        
        let onState = self.switcher.on
        print(chosen)
        // Write label text depending on UISwitch.
        if onState {
            print("Switch is on")
        }
        else {
            print("Off")
        }
    }


    //for picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return colors[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosen = colors[row]
    }
    
    
    //to record a new record
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
                } else if (type == "fixMonthlyExpenses"){
                    fixRecords.append(record)
                    expensesAmount += amount
                }
                //print(subuser)
            }
            
        }
        
        self.salesText.text = String(salesAmount)
        self.expensesText.text = String(expensesAmount)
        self.profitText.text = String(salesAmount - expensesAmount)
    }
    
    @IBAction func SubmitRecord(sender: UIButton) {
        let expensesToRecord = Int(expensesAmount.text!)
        var didRecord = false
        
        // Get the date to save in DB.
        let dateString2 = "01/" + dateString
        
        let toRecord = PFObject(className: "Record") // save expenses
        toRecord.ACL = PFACL(user: PFUser.currentUser()!)
        
        // Record Expenses, if there is any value entered.
        if (expensesToRecord != nil && expensesToRecord != 0) {
            toRecord["date"] = dateString2
            toRecord["amount"] = expensesToRecord
            toRecord["user"] = PFUser.currentUser()
            toRecord["type"] = 3
            toRecord["subuser"] = PFUser.currentUser()?.username
            toRecord["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord["description"] = String(descriptor.text!)
            // Save to local datastore
            toRecord.pinInBackground()
            didRecord = true
            print(didRecord)
        }
        
        
        if (didRecord == true) {
            // If there is any new record, shows success message, then refresh the view.
            recordSuccessLabel.text = "Recording success, reloading view..."
            recordSuccessLabel.textColor = UIColor.blackColor()
            recordSuccessLabel.hidden = false
            
            let date = toRecord["date"] as! String
            let type = toRecord["type"] as! Int
            let amount = toRecord["amount"] as! Int
            var localIdentifierString = toRecord["subUser"]
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
            
            var description = toRecord["description"]
            
            if (description == nil || description as! String == "") {
                description = "No description"
            }
            
            if (localIdentifierString == nil) {
                localIdentifierString = String(self.tempCounter += 1)
            }
            
            let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
            self.records.append(newRecord)
            loadRecords()
            
            // Reload the view after 2 seconds, updating the records.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.expensesAmount.text = ""
                self.descriptor.text = ""
                
                self.recordSuccessLabel.hidden = true
                //self.viewDidLoad()
            }
        } else {
            // No record or only "0" entered. Shows error message then refresh the view.
            self.recordSuccessLabel.text = "No records submitted."
            self.recordSuccessLabel.textColor = UIColor.redColor()
            self.recordSuccessLabel.hidden = false
            
        }
        
    }
    
    
}
