//
//  TrendingViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 9/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment

class TrendingViewController: UIViewController {
    
    // MARK: Properties
    // Segment Control
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    // Label
    @IBOutlet weak var categoryLabel: UILabel!
    
    // Controller
    let analyticController = AnalyticsController()
    let summaryController = SummaryControllerNew()
    
    // Variables
    // Others
    var calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    var shared = ShareData.sharedInstance
    
    // Today's Value
    var todaySales = 0.0
    var todayCOGS = 0.0
    var todayExpenses = 0.0
    var todayProfit = 0.0
    
    // This week's values
    var useless4 = [Double]()
    var useless5 = [Double]()
    var weekSales = ""
    var weekExpenses = ""
    var weekProfit = ""
    
    // This month's values
    var useless6 = [String]()
    var useless7 = [Double]()
    var useless8 = [Double]()
    var monthSales = ""
    var monthExpenses = ""
    var monthProfit = ""
    
    // This year's values
    var useless1 = [String]()
    var useless2 = [Double]()
    var useless3 = [Double]()
    var yearSales = ""
    var yearExpenses = ""
    var yearProfit = ""
    
    // Viewdidload
    override func viewWillAppear(animated: Bool) {
        
        // Current records
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var dateString = dateFormatter.stringFromDate(NSDate())
        (useless1, useless2, useless3, yearSales, yearExpenses, yearProfit) = summaryController.loadRecordsYearly(dateString)
        print(summaryController.loadRecordsYearly(dateString))
        // For day trending
        (todaySales, todayCOGS, todayExpenses, todayProfit) = analyticController.loadTodayRecord()
        
        // For week trending
        (useless4, useless5, weekSales, weekExpenses, weekProfit) = summaryController.loadRecordsWeekly(daysInWeek())
        
        // For month trending
        dateFormatter.dateFormat = "MM/yyyy"
        dateString = dateFormatter.stringFromDate(NSDate())
        (useless6, useless7, useless8, monthSales, monthExpenses, monthProfit) = summaryController.loadRecordsMonthly(NSDate(), dateString: dateString)
    }
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        // Determine what category is chosen
        let selectedSegment = categorySegmentedControl.selectedSegmentIndex
        
        // Define a calendar to use
        let calendar = NSCalendar.currentCalendar()
        
        if (selectedSegment == 0) {
            
            // Format according to what is saved in database.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            // Calculate the number of days to the end of year
            let today = NSDate()
            var components = calendar.components([.Day , .Month , .Year], fromDate: today)
            let yearEnd = dateFormatter.dateFromString("31/12/" + String(components.year))
            let flags = NSCalendarUnit.Day
            components = calendar.components(flags, fromDate: today, toDate: yearEnd!, options: [])
            
            // Category: Day
            if (yearSales[yearSales.startIndex] == "$") {
                yearSales.removeAtIndex(yearSales.startIndex)
            }
            let numOfDays = components.day
            let endOfYearSales = Double(yearSales)! + (todaySales * Double(numOfDays))
            //*******************************************
            // Variables used for graph
            //
            // Num of days: numOfDays
            // Today's sales amount: todaySales
            // Current sales amount: yearSales
            // Trended year end sales: endOfYearSales
            //*******************************************
        } else if (selectedSegment == 1) {
            
            // Format according to what is saved in database.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            // Calculate the number of days to the end of year
            let today = NSDate()
            var components = calendar.components([.Day , .Month , .Year], fromDate: today)
            let yearEnd = dateFormatter.dateFromString("31/12/" + String(components.year))
            let flags = NSCalendarUnit.Day
            components = calendar.components(flags, fromDate: today, toDate: yearEnd!, options: [])
            
            // Category: Week
            if (yearSales[yearSales.startIndex] == "$") {
                yearSales.removeAtIndex(yearSales.startIndex)
            }
            if (weekSales[weekSales.startIndex] == "$") {
                weekSales.removeAtIndex(weekSales.startIndex)
            }
            let numOfWeeks = components.day/7
            let endOfYearSales = Double(yearSales)! + (Double(weekSales)! * (Double(numOfWeeks)))
            //*******************************************
            // Variables used for graph
            //
            // Num of weeks: numOfWeeks
            // This week's sales amount: weekSales
            // Current sales amount: yearSales
            // Trended year end sales: endOfYearSales
            //*******************************************
        } else if (selectedSegment == 2) {
            
            // Format according to what is saved in database.
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            // Calculate the number of days to the end of year
            let today = NSDate()
            var components = calendar.components([.Day , .Month , .Year], fromDate: today)
            let yearEnd = dateFormatter.dateFromString("31/12/" + String(components.year))
            let flags = NSCalendarUnit.Month
            components = calendar.components(flags, fromDate: today, toDate: yearEnd!, options: [])
            
            // Category: Week
            if (yearSales[yearSales.startIndex] == "$") {
                yearSales.removeAtIndex(yearSales.startIndex)
            }
            if (monthSales[monthSales.startIndex] == "$") {
                monthSales.removeAtIndex(monthSales.startIndex)
            }
            let numOfMonths = components.month
            let endOfYearSales = Double(yearSales)! + (Double(monthSales)! * (Double(numOfMonths)))
            //*******************************************
            // Variables used for graph
            //
            // Num of months: numOfMonths
            // This month's sales amount: weekSales
            // Current sales amount: yearSales
            // Trended year end sales: endOfYearSales
            //*******************************************
        } else if (selectedSegment == 3) {
            
            // Category: Year
            print("If every year was like this year:")
        }
    }
    
    func daysInWeek() -> [String] {
        var daysInWeek = [String]()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let periodComponents = NSDateComponents()
        let stringDayOfWeek = moment(NSDate()).weekdayName
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
            toDate: NSDate(),
            options: [])!
        var correctDateString = dateFormatter.stringFromDate(firstDayOfWeek)
        daysInWeek.append(correctDateString)
        
        for i in 1...6 {
            periodComponents.day = +i
            let dayOfWeek = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: firstDayOfWeek,
                options: [])!
            correctDateString = dateFormatter.stringFromDate(dayOfWeek)
            daysInWeek.append(correctDateString)
        }
        
        return daysInWeek
    }
}
