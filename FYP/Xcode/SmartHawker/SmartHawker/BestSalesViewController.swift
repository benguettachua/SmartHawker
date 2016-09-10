//
//  BestSalesViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Charts

class BestSalesViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    
    @IBOutlet weak var combinedChartView: HorizontalBarChartView!
    
    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUNE", "JULY", "AUG", "SEPT", "OCT", "NOV", "DEC"]
    // Controller
    let analyticController = AnalyticsController()
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            var monthsForGraph = [String]()
            var monthlyValuesForGraph = [Double]()
            let (bestSalesMonth, sortedMonth, total) = analyticController.getBestSalesMonth()
            for month in sortedMonth {
                monthsForGraph.append(months[month])
                monthlyValuesForGraph.append(bestSalesMonth[month]!)
                
            }
            
            setChart(monthsForGraph, values: monthlyValuesForGraph)
        } else {
            var yearsForGraph = [String]()
            var yearlyValuesForGraph = [Double]()
            let (bestSalesYear, sortedYear) = analyticController.getBestSalesYear()
            for year in sortedYear {
                yearsForGraph.append(String(year))
                yearlyValuesForGraph.append(bestSalesYear[year]!)
            }
            
            setChart(yearsForGraph, values: yearlyValuesForGraph)
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Sales")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        combinedChartView.data = chartData
        
        combinedChartView.drawGridBackgroundEnabled = false
        combinedChartView.xAxis.drawGridLinesEnabled = true
        combinedChartView.rightAxis.drawGridLinesEnabled = true
        combinedChartView.leftAxis.drawGridLinesEnabled = true
        
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.rightAxis.drawAxisLineEnabled = true
        combinedChartView.leftAxis.drawAxisLineEnabled = true
        
        combinedChartView.xAxis.drawLabelsEnabled = true
        combinedChartView.xAxis.labelPosition = .Bottom
        
        combinedChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.xAxis.drawLimitLinesBehindDataEnabled = true
        combinedChartView.rightAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.descriptionText = ""
    }
    
}
