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
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    // Controller
    let analyticController = AnalyticsController()
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            let (bestSalesMonth, sortedMonth) = analyticController.getBestSalesMonth()
            for month in sortedMonth {
                print("Month: " + String(month) + " Sales: " + String(bestSalesMonth[month]))
            }
            
        } else {
            let (bestSalesYear, sortedYear) = analyticController.getBestSalesYear()
            for year in sortedYear {
                print("Year: " + String(year) + " Sales: " + String(bestSalesYear[year]))
            }
        }
    }
    
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            
            yVals1.append(ChartDataEntry(value: yValuesLineChart[i], xIndex: i))
            yVals2.append(BarChartDataEntry(value: yValuesBarChart[i] - 1, xIndex: i))
            
        }
        
        let lineChartSet = LineChartDataSet(yVals: yVals1, label: "Line Data")
        let barChartSet: BarChartDataSet = BarChartDataSet(yVals: yVals2, label: "Bar Data")
        
        
        let data: CombinedChartData = CombinedChartData(xVals: xValues)
        data.barData = BarChartData(xVals: xValues, dataSets: [barChartSet])
        data.lineData = LineChartData(xVals: xValues, dataSets: [lineChartSet])
        
        combinedChartView.data = data
        
    }
    
}
