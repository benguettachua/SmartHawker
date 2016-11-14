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
    @IBOutlet weak var workingDayPerWeekLabel: UILabel!
    @IBOutlet weak var workingDayNumberLabel: UILabel!
    @IBOutlet weak var salesSoFarLabel: UILabel!
    @IBOutlet weak var salesSoFarAmountLabel: UILabel!
    @IBOutlet weak var salesCategoryLabel: UILabel!
    @IBOutlet weak var salesCategoryAmountLabel: UILabel!
    @IBOutlet weak var categoryLeft: UILabel!
    @IBOutlet weak var categoryLeftAmount: UILabel!
    @IBOutlet weak var ifEveryCategoryLabel: UILabel!
    @IBOutlet weak var endOfYearTrendedAmountLabel: UILabel!
    
    // UIButton
    @IBOutlet weak var changeWorkingDayButton: UIButton!
    
    // Controller
    let analyticController = AnalyticsController()
    let formatter = NSNumberFormatter()
    
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
    var useless11 = [Double]()
    var weekSales = ""
    var weekExpenses = ""
    var weekProfit = ""
    var weekCOGS = ""
    
    // This month's values
    var useless6 = [String]()
    var useless7 = [Double]()
    var useless8 = [Double]()
    var useless9 = [Double]()
    var monthSales = ""
    var monthExpenses = ""
    var monthProfit = ""
    var monthCOGS = ""
    
    // This year's values
    var useless1 = [String]()
    var useless2 = [Double]()
    var useless3 = [Double]()
    var useless10 = [Double]()
    var useless = [Double]()
    var yearSales = ""
    var yearExpenses = ""
    var yearProfit = ""
    var yearCOGS = ""
    
    // Viewdidload
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        categorySegmentedControl.setTitle("Day".localized(), forSegmentAtIndex: 0)
        categorySegmentedControl.setTitle("Week".localized(), forSegmentAtIndex: 1)
        categorySegmentedControl.setTitle("Month".localized(), forSegmentAtIndex: 2)
        changeWorkingDayButton.setTitle("Change".localized(), forState: UIControlState.Normal)
        workingDayPerWeekLabel.text = "Working days per week:".localized()
        
        // Current records
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var dateString = dateFormatter.stringFromDate(NSDate())
        (useless1, useless2, useless3, useless10, yearSales, yearExpenses, yearProfit, yearCOGS, useless) = SummaryControllerNew().loadRecordsYearly(dateString)
        // For day trending
        (todaySales, todayCOGS, todayExpenses, todayProfit) = analyticController.loadTodayRecord()
        
        // For week trending
        (useless4, useless5, useless11, weekSales, weekExpenses, weekProfit, weekCOGS, useless) = SummaryControllerNew().loadRecordsWeekly(daysInWeek())
        
        // For month trending
        dateFormatter.dateFormat = "MM/yyyy"
        dateString = dateFormatter.stringFromDate(NSDate())
        (useless6, useless7, useless8, useless9, monthSales, monthExpenses, monthProfit, monthCOGS, useless) = SummaryControllerNew().loadRecordsMonthly(NSDate(), dateString: dateString)
        trend()
    }
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        trend()
    }
    
    @IBAction func changeWorkingDaysPerWeek(sender: UIButton) {
        let alert = UIAlertController(title: "Working days per week".localized(), message: nil, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "1", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "1"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "2", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "2"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "3", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "3"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "4", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "4"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "5", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "5"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "6", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "6"
            self.trend()
        }))
        
        alert.addAction(UIAlertAction(title: "7", style: .Default, handler: { void in
            self.workingDayNumberLabel.text = "7"
            self.trend()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
    
    // Show working days only if category is "Daily"
    func showWorkingDay() {
        if (categorySegmentedControl.selectedSegmentIndex == 0) {
            workingDayNumberLabel.hidden = false
            workingDayPerWeekLabel.hidden = false
            changeWorkingDayButton.hidden = false
        } else {
            workingDayNumberLabel.hidden = true
            workingDayPerWeekLabel.hidden = true
            changeWorkingDayButton.hidden = true
        }
    }
    
    func trend() {
        showWorkingDay()
        // Determine what category is chosen
        let selectedSegment = categorySegmentedControl.selectedSegmentIndex
        
        // Define a calendar to use
        let calendar = NSCalendar.currentCalendar()
        
        if (selectedSegment == 0) {
            
            // Find out the number of working days per week.
            let workingDayPerWeek = Int(workingDayNumberLabel.text!)
            
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
            let numOfWeeks = components.day/7
            var spewOverDays = numOfDays - (numOfWeeks * 7)
            
            if spewOverDays > workingDayPerWeek{
                spewOverDays = workingDayPerWeek!
            }
            
            let extrapolatedSales = (todaySales * (Double(numOfWeeks) * Double(workingDayPerWeek!) + Double(spewOverDays)))
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            let endOfYearSales = Double(formatter.numberFromString(yearSales)!) + extrapolatedSales
            
            // Populating the UI with necessary information
            salesSoFarAmountLabel.text = "$" + yearSales
            salesCategoryAmountLabel.text = "$" + String(formatter.stringFromNumber(todaySales)!)
            categoryLeftAmount.text = String(numOfDays)
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            endOfYearTrendedAmountLabel.text = formatter.stringFromNumber(endOfYearSales)
            
            // Changing the Labels
            salesSoFarLabel.text = "This year's sales so far:".localized()
            salesCategoryLabel.text = "Today's sales:".localized()
            categoryLeft.text = "Days left this year:".localized()
            ifEveryCategoryLabel.text = "If every day was like today, \nend of this year, you will have earned:".localized()
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
            
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            let endOfYearSales = Double(formatter.numberFromString(yearSales)!) + Double(formatter.numberFromString(weekSales)!) * (Double(numOfWeeks))
            
            // Populating the UI with necessary information
            salesSoFarAmountLabel.text = "$" + yearSales
            salesCategoryAmountLabel.text = "$" + weekSales
            categoryLeftAmount.text = String(numOfWeeks)
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            endOfYearTrendedAmountLabel.text = formatter.stringFromNumber(endOfYearSales)
            
            // Changing the Labels
            salesSoFarLabel.text = "This year's sales so far:".localized()
            salesCategoryLabel.text = "This week's sales:".localized()
            categoryLeft.text = "Weeks left this year:".localized()
            ifEveryCategoryLabel.text = "If every week was like this week, end of this year, you will have earned:".localized()
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
            
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            
            let endOfYearSales = Double(formatter.numberFromString(yearSales)!) + Double(formatter.numberFromString(monthSales)!) * (Double(numOfMonths))
            
            // Populating the UI with necessary information
            salesSoFarAmountLabel.text = "$" + yearSales
            salesCategoryAmountLabel.text = "$" + monthSales
            categoryLeftAmount.text = String(numOfMonths)
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            endOfYearTrendedAmountLabel.text = formatter.stringFromNumber(endOfYearSales)
            
            // Changing the Labels
            salesSoFarLabel.text = "This year's sales so far:".localized()
            salesCategoryLabel.text = "This month's sales:".localized()
            categoryLeft.text = "Months left this year:".localized()
            ifEveryCategoryLabel.text = "If every month was like this month, end of this year, you will have earned:".localized()
        }
    }
}
