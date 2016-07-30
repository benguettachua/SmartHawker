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

class AnalyticsViewController: UIViewController, ChartViewDelegate {
    
    // MARK: Properties

    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    var months: [String]!
    var monthsInNum: [String]!
    var years = [Int]()
    var beginningYear: Int!
    var sales: [Double]!
    var cogs: [Double]!
    var expenses: [Double]!
    var profits = [Double]()
    var totalMonths = [String]()
    var dollars1 = [Double]()
    var dollars2 = [Double]()
    var dollars3 = [Double]()
    typealias CompletionHandler = (success:Bool) -> Void
    var records = [RecordTable]()
    // Load the Top Bar
    let user = PFUser.currentUser()
    var tempCounter = 0
    
    var datesAndRecords = [String:[RecordTable]]()
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        years.removeAll()
        beginningYear = 2016
        years.append(beginningYear)
        
        //Here I’m creating the calendar instance that we will operate with:
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        //Now asking the calendar what year are we in today’s date:
        let currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: NSDate()))!
        let differenceInYear = currentYearInt - beginningYear
        if differenceInYear > 0{
            for i in 0...differenceInYear {
                years.append(beginningYear+i)
            }
        }

        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        monthsInNum = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        
        //loads data form local database
        loadRecordsFromLocaDatastore({ (success) -> Void in

                for year in self.years{
                    for month in self.monthsInNum{
                        let yearAndMonth = String(month) + "/" + String(year)
                        self.totalMonths.append(yearAndMonth)
                        
                        var salesAmount = 0.0
                        var COGSamount = 0.0
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
                                }
                                //print(subuser)
                            }

                        }
                        
                        self.dollars1.append(salesAmount)
                        self.dollars2.append(expensesAmount)
                        profit = salesAmount - expensesAmount
                        self.profits.append(Double(profit))
                        
                        self.setChartData(self.totalMonths)
            }
                }
            
            })
        
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
        
        
    }
    
    func setChartData(months : [String]) {
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(value: dollars1[i], xIndex: i))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Sales")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.greenColor().colorWithAlphaComponent(0.5))
        set1.setCircleColor(UIColor.greenColor())
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals2.append(ChartDataEntry(value: dollars2[i], xIndex: i))
        }
        
        let set2: LineChartDataSet = LineChartDataSet(yVals: yVals2, label: "Total Expenses")
        set2.axisDependency = .Left // Line will correlate with left axis values
        set2.setColor(UIColor.orangeColor().colorWithAlphaComponent(0.5))
        set2.setCircleColor(UIColor.orangeColor())
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.greenColor()
        set2.highlightColor = UIColor.whiteColor()
        set2.drawCircleHoleEnabled = true

        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        //bar chart
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(value: profits[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Profits")
        
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        
        
        
        let combinedData: CombinedChartData = CombinedChartData(xVals: months)
        //5 - finally set our data
        combinedData.barData = BarChartData(xVals: months, dataSets: [chartDataSet])
        combinedData.lineData = LineChartData(xVals: months, dataSets: dataSets)
        
        
        self.combinedChartView.data = combinedData
        
    }
    
    
    func setMonthChartData(){

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
                        
                        let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
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
    
}