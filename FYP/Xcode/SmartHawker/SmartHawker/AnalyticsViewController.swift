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

class AnalyticsViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {
    
    // MARK: Properties

    
    @IBOutlet weak var monthChart: LineChartView!
    @IBOutlet weak var yearChart: LineChartView!
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthsInNum = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var days = [String]()
    var monthsString: [String]!
    var years = [Int]()
    var beginningYear: Int!
    var sales: [Double]!
    var cogs: [Double]!
    var expenses: [Double]!
    var profitsMonthly: [Double]!
    var profitDaily: [Double]!
    var salesDaily: [Double]!
    var totalMonths: [String]!
    var salesList: [Double]!
    var expensesList: [Double]!
    var salesListForDay: [Double]!
    var expensesListForDay: [Double]!
    typealias CompletionHandler = (success:Bool) -> Void
    var records = [PFObject]()
    // Load the Top Bar
    let user = PFUser.currentUser()
    var tempCounter = 0
    var maxProfit = 0.0
    var maxProfitMonth = ""
    var maxProfitForDay = 0.0
    var maxProfitDay = ""
    var today = moment(NSDate())
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: then)
        let numDays = range.length //days for the month

        
        //loads data form local database
            
            let (salesList, expensesList, profitsMonthly) = AnalyticsController().yearlyCalculation(String(self.today.year))
            let (salesListForDay, expensesListForDay, days) = AnalyticsController().monthlyCalculation(numDays)
            //let totalProfitForMonth = self.monthlyCalculation(numDays, month: String(self.today.month), year: String(self.today.year))
            //for average profit per day
            
            //for average profit per month
        
            //for monthly
            self.setData(days, values1: salesListForDay, values2: expensesListForDay, values3: [], chart: self.monthChart)
            //for yearly
            self.setData(self.months, values1: salesList, values2: expensesList, values3: profitsMonthly, chart: self.yearChart)
            
        

        
    }

    
    func setData(dataPoints : [String], values1 : [Double], values2 : [Double], values3: [Double], chart: LineChartView!) {
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        var stringData : [String] = [String]()
        
        var dataEntries1: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            stringData.append(dataPoints[i])
        }
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: (Double)(values1[i] as NSNumber), xIndex: i)
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
        dataSets.append(lineChartDataSet1)
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: (Double)(values2[i] as NSNumber), xIndex: i)
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
        dataSets.append(lineChartDataSet2)
        
        if values3.count != 0{
            var dataEntries3: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: (Double)(values3[i] as NSNumber), xIndex: i)
                dataEntries3.append(dataEntry)
            }
            
            let lineChartDataSet3 = LineChartDataSet(yVals: dataEntries3, label: "Profit")
            lineChartDataSet3.axisDependency = .Left // Line will correlate with left axis values
            lineChartDataSet3.setColor(UIColor.purpleColor())
            lineChartDataSet3.highlightColor = UIColor.clearColor()
            lineChartDataSet3.lineWidth = 2
            lineChartDataSet3.drawCircleHoleEnabled = false
            lineChartDataSet3.circleRadius = 0
            lineChartDataSet3.drawValuesEnabled = false
            lineChartDataSet3.mode = .HorizontalBezier
            
            lineChartDataSet3.fill = ChartFill.fillWithColor(UIColor.purpleColor())
            lineChartDataSet3.drawFilledEnabled = true
            dataSets.append(lineChartDataSet3)
        }
        //3 - create an array to store our LineChartDataSets
        
        
        
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: stringData, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        chart.data = data
        chart.leftAxis.axisMinValue = 1
    }

    
    
}