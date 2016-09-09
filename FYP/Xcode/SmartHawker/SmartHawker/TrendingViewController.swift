//
//  TrendingViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 9/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController {
    
    // MARK: Properties
    // Segment Control
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    // Label
    @IBOutlet weak var categoryLabel: UILabel!
    
    // Controller
    var shared = ShareData.sharedInstance
    let analyticController = AnalyticsController()
    let summaryController = SummaryControllerNew()
    
    // Variables
    // Today's Value
    var todaySales = 0.0
    var todayCOGS = 0.0
    var todayExpenses = 0.0
    var todayProfit = 0.0
    
    // This year's values
    var useless1 = [String]()
    var useless2 = [Double]()
    var useless3 = [Double]()
    var yearSales = ""
    var yearExpenses = ""
    var yearProfit = ""
    
    // Viewdidload
    override func viewDidLoad() {
        (todaySales, todayCOGS, todayExpenses, todayProfit) = analyticController.loadTodayRecord()
    }
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        // Get this years figure so far
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let dateString = dateFormatter.stringFromDate(NSDate())
        (useless1, useless2, useless3, yearSales, yearExpenses, yearProfit) = summaryController.loadRecordsYearly(dateString)
        
        // Determine what category is chosen
        let selectedSegment = categorySegmentedControl.selectedSegmentIndex
        
        if (selectedSegment == 0) {
            
            var calendar: NSCalendar = NSCalendar.currentCalendar()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let today = NSDate()
            let yearEnd = dateFormatter.dateFromString("31/12/2016")
            let flags = NSCalendarUnit.Day
            let components = calendar.components(flags, fromDate: today, toDate: yearEnd!, options: [])
            
            // Category: Day
            print("This year's sales so far: " + yearSales)
            yearSales.removeAtIndex(yearSales.startIndex)
            print("Today's sales is : " + String(todaySales))
            print("Number of days left in this year: " + String(components.day))
            let endOfYearSales = Double(yearSales)! + (todaySales * Double(components.day))
            print("If everyday was like today, my expected sales for 2016 is: " + String(endOfYearSales))
        } else if (selectedSegment == 1) {
            
            // Category: Week
            print("If every week was like this week:")
        } else if (selectedSegment == 2) {
            
            // Category: Month
            print("If every month was like this month:")
        } else if (selectedSegment == 3) {
            
            // Category: Year
            print("If every year was like this year:")
        }
    }
}
