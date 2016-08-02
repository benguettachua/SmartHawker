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
        
        // Swift 2:
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: chosenMonthDate)
        
        let numDays = range.length
        var dataPoints = [Int]()
        var values = [Double]()
        for i in 1...numDays {
            dataPoints.append(i)
        }
        
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
        var totalSalesAmount = 0.0
        var totalExpensesAmount = 0.0
        var series1 = [0.0]
        var series2 = [0.0]
        for i in 1...12 {
            salesAmount = 0.0
            expensesAmount = 0.0
            var text = ""
            if i == 1{
                text = "0" + String(i)
            }else if i == 2 {
                text = "0" + String(i)
            }else{
                text = String(i)
            }
            let stringOfMonth = text + "/" + self.dateString
            print(stringOfMonth)
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
                    //print(subuser)
                }
                
            }
            
            series1.append(salesAmount)
            series2.append(expensesAmount)
        }
        series1.append(0)
        series2.append(0)
        let series3 = [0.0,19,13,10,9,4,11,13,14,15,16,17,18,0]
        let series4 = [0.0,1,2,3,4,5,6,7,8,9,10,11,12,0]
        setYearlyData(months, values1: series1, values2: series2)
        self.salesText.text = String(totalSalesAmount)
        self.expensesText.text = String(totalExpensesAmount)
        self.profitText.text = String(totalSalesAmount - totalExpensesAmount)
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
    
    func setYearlyData(dataPoints : [String], values1 : [Double], values2 : [Double]) {
        
        var dataEntries1: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values1[i], xIndex: i)
            dataEntries1.append(dataEntry)
        }
        
        let lineChartDataSet1 = LineChartDataSet(yVals: dataEntries1, label: "Sales")
        lineChartDataSet1.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet1.setColor(UIColor.greenColor())
        lineChartDataSet1.highlightColor = UIColor.clearColor()
        lineChartDataSet1.lineWidth = 5
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.drawCircleHoleEnabled = false
        lineChartDataSet1.circleRadius = 0
        lineChartDataSet1.drawValuesEnabled = false
        lineChartDataSet1.drawCubicEnabled = true
        
        let gradientColors = [UIColor.greenColor().CGColor, UIColor.clearColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.1, 0.0] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        lineChartDataSet1.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet1.drawFilledEnabled = true // Draw the Gradient
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values2[i], xIndex: i)
            dataEntries2.append(dataEntry)
        }
        
        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "Expenses")
        lineChartDataSet2.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet2.setColor(UIColor.redColor())
        lineChartDataSet2.highlightColor = UIColor.clearColor()
        lineChartDataSet2.lineWidth = 5
        lineChartDataSet2.drawFilledEnabled = true
        lineChartDataSet2.drawCircleHoleEnabled = false
        lineChartDataSet2.circleRadius = 0
        lineChartDataSet2.drawValuesEnabled = false
        lineChartDataSet2.drawCubicEnabled = true
        
        let gradientColors2 = [UIColor.redColor().CGColor, UIColor.clearColor().CGColor] // Colors of the gradient
        let colorLocations2:[CGFloat] = [0.1, 0.0] // Positioning of the gradient
        let gradient2 = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors2, colorLocations2) // Gradient Object
        lineChartDataSet2.fill = ChartFill.fillWithLinearGradient(gradient2!, angle: 90.0) // Set the Gradient
        lineChartDataSet2.drawFilledEnabled = true // Draw the Gradient
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(lineChartDataSet1)
        dataSets.append(lineChartDataSet2)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.chart.data = data
        
        chart.backgroundColor = UIColor.clearColor()
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.drawGridLinesEnabled = true
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        
        chart.xAxis.drawAxisLineEnabled = true
        chart.rightAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        
        chart.xAxis.drawLabelsEnabled = true
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        
        chart.leftAxis.drawLimitLinesBehindDataEnabled = false
        chart.xAxis.drawLimitLinesBehindDataEnabled = false
        chart.rightAxis.drawLimitLinesBehindDataEnabled = false
        chart.leftAxis.axisMinValue = 0;
        chart.descriptionText = ""
        
        chart.legend.enabled = false
    }
    
    func setMonthlyData(dataPoints: [String], values : [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Sales")
        lineChartDataSet.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet.setColor(UIColor.greenColor())
        lineChartDataSet.highlightColor = UIColor.whiteColor()
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = UIColor.greenColor()
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleRadius = 0
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: months, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.chart.data = data
        
        chart.backgroundColor = UIColor.clearColor()
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        
        chart.xAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        
        chart.xAxis.drawLabelsEnabled = true
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        
        chart.leftAxis.drawLimitLinesBehindDataEnabled = false
        chart.xAxis.drawLimitLinesBehindDataEnabled = false
        chart.rightAxis.drawLimitLinesBehindDataEnabled = false
        chart.sizeToFit()
    }

}
