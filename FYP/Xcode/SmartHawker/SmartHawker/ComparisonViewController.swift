//
//  ComparisonViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment
import Charts

class ComparisonViewController: UIViewController {
    
    // MARK: Properties
    // Controllers
    let analyticController = AnalyticsController()
    
    // UI Button
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var combinedChartView: BarChartView!
    override func viewDidLoad() {
    
    }
    
    func getPastSixDays(date: NSDate) {
        
        var pastSixDaysRanked = [String]()
        var pastSixDaysValue = [Double]()
        // Get the sales for the past six days, with the date being in String type
        let pastSixDays = analyticController.getPastSixSimilarDays(date)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Create a new Dictionary with Date and Amount, so that the date can be sorted.
        var newPastSixDays = [NSDate : Double]()
        
        // Populate the new dictionary.
        for key in pastSixDays.keys {
            let dateKey = dateFormatter.dateFromString(key)
            newPastSixDays[dateKey!] = pastSixDays[key]
        }
        
        // Sort the new dictionary according to date.
        let sortedKeys = Array(newPastSixDays.keys).sort(<)
        
        // Print the date and sales amount, to be changed to graph.
        for day in sortedKeys {
            let dayString = dateFormatter.stringFromDate(day)
            pastSixDaysRanked.append(dayString)
            pastSixDaysValue.append(newPastSixDays[day]!)
        }
        
        setChart(pastSixDaysRanked, values: pastSixDaysValue)
    }
    
    // Changing Dates of the record
    @IBAction func changeDate(sender: UIButton) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Creating the date picker
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .Date
        let pickerSize : CGSize = picker.sizeThatFits(CGSizeZero)
        
        // Adding date picker to a custom view to be added to the alert.
        let margin:CGFloat = 8.0
        let rect = CGRectMake(margin, margin, alertController.view.bounds.size.width - margin * 4.0, pickerSize.height)
        let customView = UIView(frame: rect)
        picker.frame = CGRectMake(customView.frame.size.width/2 - pickerSize.width/2, margin, pickerSize.width, pickerSize.height/2)
        customView.addSubview(picker)
        alertController.view.addSubview(customView)
        
        let cancelAction = UIAlertAction(title: "Done", style: .Default, handler: { void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.stringFromDate(picker.date)
            let momentDateSelected = moment(picker.date)
            let weekday = momentDateSelected.weekdayName
            self.selectDateButton.setTitle(dateString + ", " + weekday, forState: .Normal)
            self.getPastSixDays(picker.date)
            
        })
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        var dates = [String]()
        let dateFormatter = NSDateFormatter()
        
        for i in 0..<dataPoints.count {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString1 = dateFormatter.dateFromString(dataPoints[i])
            dateFormatter.dateFormat = "dd/MM"
            dates.append(dateFormatter.stringFromDate(dateString1!))
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Sales")
        let chartData = BarChartData(xVals: dates, dataSet: chartDataSet)
        combinedChartView.data = chartData
        
        combinedChartView.drawGridBackgroundEnabled = false
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.rightAxis.drawAxisLineEnabled = false
        combinedChartView.leftAxis.drawAxisLineEnabled = false
        
        combinedChartView.xAxis.drawLabelsEnabled = true
        combinedChartView.xAxis.labelRotatedWidth = 10.0
        combinedChartView.rightAxis.drawLabelsEnabled = false
        combinedChartView.leftAxis.drawLabelsEnabled = false
        combinedChartView.xAxis.labelPosition = .Bottom
        combinedChartView.xAxis.labelFont = UIFont(name: "Avenir-Light", size: 15.0)!
        
        combinedChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.xAxis.drawLimitLinesBehindDataEnabled = true
        combinedChartView.rightAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.descriptionText = ""
    }
}
