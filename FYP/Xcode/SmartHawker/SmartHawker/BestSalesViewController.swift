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
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
    // Controller
    let analyticController = AnalyticsController()
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        populateBestSales()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        categorySegmentControl.setTitle("Month".localized(), forSegmentAtIndex: 0)
        categorySegmentControl.setTitle("Year".localized(), forSegmentAtIndex: 1)
        
        
        populateBestSales()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        if values.isEmpty == false{
            let valueMax = values[values.count-1]
            combinedChartView.leftAxis.axisMaxValue = 1.15*valueMax
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Sales".localized())
        chartDataSet.colors = ChartColorTemplates.joyful()
        chartDataSet.valueFont = UIFont.systemFontOfSize(10)
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        combinedChartView.data = chartData
        
        combinedChartView.drawGridBackgroundEnabled = false
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = true
        
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.rightAxis.drawAxisLineEnabled = true
        combinedChartView.leftAxis.drawAxisLineEnabled = true
        
        combinedChartView.xAxis.labelFont = UIFont.systemFontOfSize(12)
        combinedChartView.xAxis.drawLabelsEnabled = true
        combinedChartView.rightAxis.drawLabelsEnabled = false
        combinedChartView.leftAxis.drawLabelsEnabled = true
        combinedChartView.xAxis.labelPosition = .Bottom
        
        combinedChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.xAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.rightAxis.drawLimitLinesBehindDataEnabled = false
        combinedChartView.descriptionText = ""
        combinedChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    func populateBestSales() {
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            var monthsForGraph = [String]()
            var monthlyValuesForGraph = [Double]()
            let (bestSalesMonth, sortedMonth, total) = analyticController.getBestSalesMonth()
            for month in sortedMonth {
                monthsForGraph.append(months[month].localized())
                monthlyValuesForGraph.append(bestSalesMonth[month]!)
                
            }
            if monthlyValuesForGraph.isEmpty == false{
                setChart(monthsForGraph, values: monthlyValuesForGraph)
            }else{
                combinedChartView.noDataText = "Please make some records.".localized()
            }
        } else {
            var yearsForGraph = [String]()
            var yearlyValuesForGraph = [Double]()
            let (bestSalesYear, sortedYear) = analyticController.getBestSalesYear()
            for year in sortedYear {
                yearsForGraph.append(String(year))
                yearlyValuesForGraph.append(bestSalesYear[year]!)
            }
            
            if yearlyValuesForGraph.isEmpty == false{
                setChart(yearsForGraph, values: yearlyValuesForGraph)
            }else{
                combinedChartView.noDataText = "Please make some records.".localized()
            }
        }
    }
}
