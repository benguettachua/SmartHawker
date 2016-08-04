//
//  AnalyticsViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 24/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Parse
import Charts
import SwiftMoment

class AnalyticsViewController: UIViewController, ChartViewDelegate {
    
    // MARK: Properties

    
    @IBOutlet weak var chart: LineChartView!
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthsInNum = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var days = [String]()
    var years = [Int]()
    var beginningYear: Int!
    var sales: [Double]!
    var cogs: [Double]!
    var expenses: [Double]!
    var profits = [Double]()
    var totalMonths = [String]()
    var salesList = [Double]()
    var expensesList = [Double]()
    var salesListForDay = [Double]()
    var expensesListForDay = [Double]()
    var dollars3 = [Double]()
    typealias CompletionHandler = (success:Bool) -> Void
    var records = [RecordTable]()
    // Load the Top Bar
    let user = PFUser.currentUser()
    var tempCounter = 0
    var maxProfit = 0.0
    var maxProfitMonth = ""
    var maxProfitForDay = 0.0
    var maxProfitDay = ""
    var datesAndRecords = [String:[RecordTable]]()
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var today = moment(NSDate())
            let array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
        print(array)
        //Here I’m creating the calendar instance that we will operate with:
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        //Now asking the calendar what year are we in today’s date:
        //how many days back
        let periodComponents = NSDateComponents()
        //periodComponents.day = -30
        let then = calendar!.dateByAddingComponents(
            periodComponents,
            toDate: NSDate(),
            options: [])!
        print(then)
        
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: then)
        let numDays = range.length //days for the month
        
        var stringOfDayMonthYear = ""
        if today.month < 10{
            stringOfDayMonthYear = "0" + String(today.month) + "/" + String(today.year)
        }else{
            stringOfDayMonthYear = String(today.month) + "/" + String(today.year)
        }
        //loads data form local database
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            var i = 0
            var totalProfitForYear = 0.0
            var totalProfitForMonth = 0.0
            for month in self.monthsInNum{
                
                let yearAndMonth = String(month) + "/" + String(today.year)
                var yearMonthDay = ""
                
                var salesAmount = 0.0
                var expensesAmount = 0.0
                var profit = 0.0
                
                for record in self.records {
                    if record.date.containsString(yearAndMonth){
                        let type = record.type
                        let amount = Double(record.amount)
                        //let subuser = object["subuser"] as? String
                        if (type == "Sales") {
                            salesAmount += amount
                        } else if (type == "COGS") {
                            expensesAmount += amount
                        } else if (type == "Expenses") {
                            expensesAmount += amount
                        } else if (type == "Recurring Expenses"){
                            expensesAmount += amount
                        }
                    }
                    
                }
                

                if stringOfDayMonthYear == yearAndMonth{
                    for day in 1...numDays{
                        var salesAmountForDay = 0.0
                        var expensesAmountForDay = 0.0
                        var profitForDay = 0.0
                        
                        if day < 10 {
                            yearMonthDay = "0" + String(day) + "/" + yearAndMonth
                        }else{
                            yearMonthDay = String(day) + "/" + yearAndMonth
                        }
                        self.days.append(yearMonthDay)
                        for record in self.records {
                            if record.date.containsString(yearMonthDay){
                                let type = record.type
                                let amount = Double(record.amount)
                                //let subuser = object["subuser"] as? String
                                if (type == "Sales") {
                                    salesAmountForDay += amount
                                } else if (type == "COGS") {
                                    expensesAmountForDay += amount
                                } else if (type == "Expenses") {
                                    expensesAmountForDay += amount
                                } else if (type == "Recurring Expenses"){
                                    expensesAmountForDay += amount
                                }
                            }
                            
                        }
                        //for month
                        self.salesListForDay.append(salesAmountForDay)
                        self.expensesListForDay.append(expensesAmountForDay)
                        profitForDay = salesAmountForDay - expensesAmountForDay
                        totalProfitForMonth += profitForDay
                        if profitForDay > self.maxProfitForDay{
                            self.maxProfitForDay = profitForDay
                            self.maxProfitDay = yearMonthDay
                        }
                        self.profits.append(Double(profit))
                    }
                }

                
                
                //for year
                self.salesList.append(salesAmount)
                self.expensesList.append(expensesAmount)
                profit = salesAmount - expensesAmount
                totalProfitForYear += profit
                if profit > self.maxProfit{
                    self.maxProfit = profit
                    self.maxProfitMonth = self.months[i]
                }
                self.profits.append(Double(profit))
                
                
                
                i += 1
            }
            
            print(totalProfitForYear / Double(today.month))
            print(self.days.count)
            print("for max profit day")
            print(self.maxProfitForDay)
            print(self.maxProfitDay)
            print("for max profit month")
            print(self.maxProfit)
            print(self.maxProfitMonth)
            //for monthly
            self.setData(self.days, values1: self.salesListForDay, values2: self.expensesListForDay)
            //for yearly
            //self.setData(self.months, values1: self.salesList, values2: self.expensesList)
            
        })
        
        /*
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        
        let day = components.day
        let month = components.month
        let year = components.year
        
        //how many days back
        let periodComponents = NSDateComponents()
        periodComponents.day = -30
        let then = calendar!.dateByAddingComponents(
            periodComponents,
            toDate: NSDate(),
            options: [])!
        print(then)
        
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: then)
        let numDays = range.length //days for the month
        */
        
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
                        let dateString = object["date"] as! String
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
                        } else if (type == 3) {
                            typeString = "Recurring Expenses"
                        }
                        
                        var description = object["description"]
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
                        self.records.append(newRecord)
                        if self.datesAndRecords[dateString] == nil {
                            var arrayForRecords = [RecordTable]()
                            arrayForRecords.append(newRecord)
                            self.datesAndRecords[dateString] = arrayForRecords
                        }else{
                            self.datesAndRecords[dateString]?.append(newRecord)
                        }
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
        chart.leftAxis.axisMinValue = 1
    }
    
}