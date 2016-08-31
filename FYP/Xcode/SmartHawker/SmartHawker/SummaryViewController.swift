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

class SummaryViewController: UIViewController {
    
    
    // MARK: Properties
    var currentMonthInt = Int()
    var currentYearInt = Int()
    var currentMonthString = String()
    var currentYearString = String()
    var monthAndYear = String()
    var dateString = String()
    var tempCounter = 0
    var records = [PFObject]()
    var fixRecords = [PFObject]()
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
    @IBOutlet weak var weekMonthYear: UILabel!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var profitText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var salesText: UILabel!
    @IBOutlet weak var totalSales: UILabel!
    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var netProfit: UILabel!
    @IBOutlet weak var incomeTax: UIButton!
    
    @IBOutlet weak var report: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    typealias CompletionHandler = (success:Bool) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekMonthYear.text = "Choose Category".localized()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Here I’m creating the calendar instance that we will operate with:
        
        
        
        weekButton.setTitle("Week".localized(), forState: UIControlState.Normal)
        monthButton.setTitle("Month".localized(), forState: UIControlState.Normal)
        yearButton.setTitle("Year".localized(), forState: UIControlState.Normal)
        incomeTax.setTitle("Income Tax".localized(), forState: UIControlState.Normal)
        totalSales.text = "Total Sales ($):".localized()
        totalExpenses.text = "Total Expenses ($):".localized()
        netProfit.text = "Net Profit ($):".localized()
        //Now asking the calendar what month are we in today’s date:
        
        if actualMonthDate.month < 10 {
            currentMonthString = "0" + String(actualMonthDate.month)
        }else{
            currentMonthString = String(actualMonthDate.month)
        }
        dateString = currentMonthString + "/" + String(actualMonthDate.year)
        

        
    }
    
    func loadRecordsMonthly(){
        let loadedData = SummaryControllerNew().loadRecordsMonthly(chosenMonthDate, dateString: dateString)
        setData(loadedData.0, values1: loadedData.1, values2: loadedData.2)
        self.salesText.text = loadedData.3
        self.expensesText.text = loadedData.4
        self.profitText.text = loadedData.5
    }
    func loadRecordsYearly(){
        let loadedData = SummaryControllerNew().loadRecordsYearly(dateString)
        
        setData(loadedData.0, values1: loadedData.1, values2: loadedData.2)
        self.salesText.text = loadedData.3
        self.expensesText.text = loadedData.4
        self.profitText.text = loadedData.5
    }
    
    func loadRecordsWeekly(){
        let loadedData = SummaryControllerNew().loadRecordsWeekly(daysInWeek)
        
        setData(daysInWeek, values1: loadedData.0, values2: loadedData.1)
        self.salesText.text = loadedData.2
        self.expensesText.text = loadedData.3
        self.profitText.text = loadedData.4
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
            
            weekMonthYear.text = actualMonthDate.monthName.localized() + " " + String(actualMonthDate.year)
            
            if actualMonthDate.month < 10 {
                currentMonthString = "0" + String(actualMonthDate.month)
            }else{
                currentMonthString = String(actualMonthDate.month)
            }
            
            dateString = currentMonthString + "/" + String(actualMonthDate.year)
            
            loadRecordsMonthly()
            
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
            
            weekMonthYear.text = actualMonthDate.monthName.localized() + " " + String(actualMonthDate.year)
            
            if actualMonthDate.month < 10 {
                currentMonthString = "0"+String(actualMonthDate.month)
            }else{
                currentMonthString = String(actualMonthDate.month)
            }
            
            dateString = currentMonthString + "/" + String(actualMonthDate.year)
            
            loadRecordsMonthly()
            
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
            
            let loadedData = SummaryControllerNew().loadRecordsYearly(dateString)
            
            setData(loadedData.0, values1: loadedData.1, values2: loadedData.2)
            self.salesText.text = loadedData.3
            self.expensesText.text = loadedData.4
            self.profitText.text = loadedData.5
            
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
            
            let loadedData = SummaryControllerNew().loadRecordsWeekly(daysInWeek)
            
            setData(daysInWeek, values1: loadedData.0, values2: loadedData.1)
            self.salesText.text = loadedData.2
            self.expensesText.text = loadedData.3
            self.profitText.text = loadedData.4
            
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

        weekButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        loadRecordsWeekly()
    }
    
    
    @IBAction func month(sender: UIButton) {
        
        summaryType = 1
        
        //Here I’m creating the calendar instance that we will operate with:
        weekMonthYear.text = actualMonthDate.monthName.localized() + " " + String(actualMonthDate.year)
        //Now asking the calendar what month are we in today’s date:
        if actualMonthDate.month < 10 {
            currentMonthString = "0" + String(actualMonthDate.month)
        }else{
            currentMonthString = String(actualMonthDate.month)
        }
        dateString = currentMonthString + "/" + String(actualMonthDate.year)

        
        monthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        yearButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        loadRecordsMonthly()
    }
    
    @IBAction func year(sender: UIButton) {
        
        summaryType = 2
        
        //Here I’m creating the calendar instance that we will operate with:
        weekMonthYear.text = String(actualYearDate.year)
        dateString = String(actualYearDate.year)

        
        yearButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        monthButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        weekButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        loadRecordsYearly()
    }
    
    func setData(dataPoints : [String], values1 : [Double], values2 : [Double]) {
        
        var dataEntries1: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values1[i], xIndex: i)
            dataEntries1.append(dataEntry)
        }
        
        let lineChartDataSet1 = LineChartDataSet(yVals: dataEntries1, label: "Sales".localized())
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
        
        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "Expenses".localized())
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
        
        chart.legend.enabled = true
    }
    
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
