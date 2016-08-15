//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment
import Charts

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
    var months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""]
    
    @IBOutlet weak var chart: LineChartView!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            

            self.loadRecords()


        })

    }
    
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Load from local datastore into UI.
        self.records.removeAll()
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
                            typeString = "Expenses"
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
    
    func loadRecords(){
        
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        // Swift 2:
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: chosenMonthDate)
        
        let numDays = range.length
        var series1 = [0.00]
        var series2 = [0.00]
        var days = [""]

        for i in 1...numDays{
            
            var salesAmount = 0.00
            var expensesAmount = 0.00
            
            var stringToCheck = String(i) + "/" + self.dateString
            if i < 10 {
                stringToCheck = "0" + stringToCheck
            }
            days.append(stringToCheck)
            for record in self.records {
                
                if record.date.containsString(stringToCheck){
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == "COGS") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    } else if (type == "Expenses") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                }
                
            }
            series1.append(salesAmount)
            series2.append(expensesAmount)
        }
        days.append("")
        series1.append(0.00)
        series2.append(0.00)
        setData(days, values1: series1, values2: series2)
        self.salesText.text = "$" + String(format: "%.2f", totalSalesAmount)
        self.expensesText.text = "$" + String(format: "%.2f", totalExpensesAmount)
        self.profitText.text = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount))
    }
    
    
    func loadRecordsYearly(){
        var salesAmount = 0.00
        var expensesAmount = 0.00
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        var series1 = [0.00]
        var series2 = [0.00]
        for i in 1...12 {
            salesAmount = 0.00
            expensesAmount = 0.00
            var text = ""
            if i == 1{
                text = "0" + String(i)
            }else if i == 2 {
                text = "0" + String(i)
            }else{
                text = String(i)
            }
            let stringOfMonth = text + "/" + self.dateString
            for record in self.records {
                
                if record.date.containsString(stringOfMonth){
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == "COGS") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    } else if (type == "Expenses") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                }
                
            }
            
            series1.append(salesAmount)
            series2.append(expensesAmount)
        }
        series1.append(0)
        series2.append(0)
        setData(months, values1: series1, values2: series2)
        self.salesText.text = "$" + String(format: "%.2f", totalSalesAmount)
        self.expensesText.text = "$" + String(format: "%.2f", totalExpensesAmount)
        self.profitText.text = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount))
    }
    
    func loadRecordsWeekly(){
        
        var series1 = [0.00]
        var series2 = [0.00]
        var dataPoints = [""]
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        for stringToCheck in daysInWeek{
            var salesAmount = 0.00
            var expensesAmount = 0.00
            dataPoints.append(stringToCheck)
            for record in self.records {
                if record.date.containsString(stringToCheck){
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == "COGS") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    } else if (type == "Expenses") {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                    
                }
                
            }
            series1.append(salesAmount)
            series2.append(expensesAmount)
        }
        series1.append(0.00)
        series2.append(0.00)
        dataPoints.append("")
        setData(dataPoints, values1: series1, values2: series2)
        self.salesText.text = "$" + String(format: "%.2f", totalSalesAmount)
        self.expensesText.text = "$" + String(format: "%.2f", totalExpensesAmount)
        self.profitText.text = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount))
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
            
            let stringDayOfWeek = actualWeekDate.weekdayName
            var dayOfWeek = 0
            if stringDayOfWeek.containsString("Sunday"){
                dayOfWeek = 7
            }else if stringDayOfWeek.containsString("Monday"){
                dayOfWeek = 1
            }else if stringDayOfWeek.containsString("Tuesday"){
                dayOfWeek = 2
            }else if stringDayOfWeek.containsString("Wednesday"){
                dayOfWeek = 3
            }else if stringDayOfWeek.containsString("Thursday"){
                dayOfWeek = 4
            }else if stringDayOfWeek.containsString("Friday"){
                dayOfWeek = 5
            }else if stringDayOfWeek.containsString("Saturday"){
                dayOfWeek = 6
            }
            periodComponents.day = 1 - dayOfWeek
            let firstDayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
            daysInWeek.append(correctDateString)
            weekMonthYear.text = String(correctDateString) + " - "
            for i in 1...6 {
                periodComponents.day = +i
                let dayOfWeek = calendar!.dateByAddingComponents(
                    periodComponents,
                    toDate: firstDayOfWeek,
                    options: [])!
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
            
            let stringDayOfWeek = actualWeekDate.weekdayName
            var dayOfWeek = 0
            if stringDayOfWeek.containsString("Sunday"){
                dayOfWeek = 7
            }else if stringDayOfWeek.containsString("Monday"){
                dayOfWeek = 1
            }else if stringDayOfWeek.containsString("Tuesday"){
                dayOfWeek = 2
            }else if stringDayOfWeek.containsString("Wednesday"){
                dayOfWeek = 3
            }else if stringDayOfWeek.containsString("Thursday"){
                dayOfWeek = 4
            }else if stringDayOfWeek.containsString("Friday"){
                dayOfWeek = 5
            }else if stringDayOfWeek.containsString("Saturday"){
                dayOfWeek = 6
            }
            periodComponents.day = 1 - dayOfWeek
            let firstDayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: chosenWeekDate,
                options: [])!
            var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
            daysInWeek.append(correctDateString)
            weekMonthYear.text = String(correctDateString) + " - "
            for i in 1...6 {
                periodComponents.day = +i
                let dayOfWeek = calendar!.dateByAddingComponents(
                    periodComponents,
                    toDate: firstDayOfWeek,
                    options: [])!
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
        let stringDayOfWeek = actualWeekDate.weekdayName
        var dayOfWeek = 0
        if stringDayOfWeek.containsString("Sunday"){
            dayOfWeek = 7
        }else if stringDayOfWeek.containsString("Monday"){
            dayOfWeek = 1
        }else if stringDayOfWeek.containsString("Tuesday"){
            dayOfWeek = 2
        }else if stringDayOfWeek.containsString("Wednesday"){
            dayOfWeek = 3
        }else if stringDayOfWeek.containsString("Thursday"){
            dayOfWeek = 4
        }else if stringDayOfWeek.containsString("Friday"){
            dayOfWeek = 5
        }else if stringDayOfWeek.containsString("Saturday"){
            dayOfWeek = 6
        }
        periodComponents.day = 1 - dayOfWeek
        print(1 - dayOfWeek)
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
                toDate: firstDayOfWeek,
                options: [])!
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
        loadRecordsWeekly()
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
    
    func setData(dataPoints : [String], values1 : [Double], values2 : [Double]) {
        
        var dataEntries1: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values1[i], xIndex: i)
            dataEntries1.append(dataEntry)
        }
        
        let lineChartDataSet1 = LineChartDataSet(yVals: dataEntries1, label: "Sales")
        lineChartDataSet1.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet1.setColor(UIColor.greenColor())
        lineChartDataSet1.highlightColor = UIColor.clearColor()
        lineChartDataSet1.lineWidth = 4
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.drawCircleHoleEnabled = false
        lineChartDataSet1.circleRadius = 0
        lineChartDataSet1.drawValuesEnabled = false
        lineChartDataSet1.mode = .HorizontalBezier

        lineChartDataSet1.fill = ChartFill.fillWithColor(UIColor.greenColor())
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values2[i], xIndex: i)
            dataEntries2.append(dataEntry)
        }
        
        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "Expenses")
        lineChartDataSet2.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet2.setColor(UIColor.redColor())
        lineChartDataSet2.highlightColor = UIColor.clearColor()
        lineChartDataSet2.lineWidth = 2
        lineChartDataSet2.drawCircleHoleEnabled = false
        lineChartDataSet2.circleRadius = 0
        lineChartDataSet2.drawValuesEnabled = false
        lineChartDataSet2.mode = .HorizontalBezier

        lineChartDataSet2.fill = ChartFill.fillWithColor(UIColor.redColor())
        lineChartDataSet2.drawFilledEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(lineChartDataSet1)
        dataSets.append(lineChartDataSet2)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: dataPoints, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.chart.data = data
        
        chart.backgroundColor = UIColor.clearColor()
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.drawGridLinesEnabled = true
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        
        chart.xAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        
        chart.xAxis.drawLabelsEnabled = true
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        
        chart.leftAxis.drawLimitLinesBehindDataEnabled = false
        chart.xAxis.drawLimitLinesBehindDataEnabled = true
        chart.rightAxis.drawLimitLinesBehindDataEnabled = false
        chart.leftAxis.axisMinValue = 1
        chart.descriptionText = ""
        
        chart.legend.enabled = false
    }

}

//extension Double {
//    func format(f: String) -> String {
//        return String(format: "%\(f)f", self)
//    }
//}
