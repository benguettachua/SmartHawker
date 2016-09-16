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


class SummaryControllerNew {
    
    // MARK: Properties
    var records = connectionDAO().loadRecords()
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    let user = PFUser.currentUser()

    
    // for loading records monthly
    func loadRecordsMonthly(chosenMonthDate: NSDate, dateString: String) -> ([String], [Double], [Double], [Double], String, String, String, String){
        
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        var totalCOGSAmount = 0.00
        // Swift 2:
        let range = calendar!.rangeOfUnit(.Day, inUnit: .Month, forDate: chosenMonthDate)
        
        let numDays = range.length
        var series1 = [Double]()
        var series2 = [Double]()
        var series3 = [Double]()
        var days = [String]()
        
        for i in 1...numDays{
            
            var salesAmount = 0.00
            var expensesAmount = 0.00
            var COGSAmount = 0.00
            
            var stringToCheck = String(i) + "/" + dateString
            if i < 10 {
                stringToCheck = "0" + stringToCheck
            }
            
            let index = stringToCheck.startIndex..<stringToCheck.endIndex.advancedBy(-5)
            let stringToDisplay = stringToCheck[index]
            
            days.append(stringToDisplay)
            
            for record in self.records {
                let date = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                
                
                if date.containsString(stringToCheck){
                    if (type == 0) {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == 1) {
                        COGSAmount += amount
                        totalCOGSAmount += amount
                    } else if (type == 2) {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                }
                
            }
            
            series1.append(salesAmount)
            series2.append(expensesAmount)
            series3.append(COGSAmount)
        }
        let sales = "$" + String(format: "%.2f", totalSalesAmount)
        let expenses = "$" + String(format: "%.2f", totalExpensesAmount)
        let profit = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount - totalCOGSAmount))
        let COGS = "$" + String(format: "%.2f", totalCOGSAmount)
        
        return (days, series1, series2, series3, sales, expenses, profit, COGS)
    }
    
    // for loading records yearly
    func loadRecordsYearly(dateString: String) -> ([String], [Double], [Double], [Double], String, String, String, String){
        var salesAmount = 0.00
        var expensesAmount = 0.00
        var COGSAmount = 0.00
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        var totalCOGSAmount = 0.00
        var series1 = [Double]()
        var series2 = [Double]()
        var series3 = [Double]()
        
        
        for i in 1...12 {
            salesAmount = 0.00
            expensesAmount = 0.00
            COGSAmount = 0.00
            var text = ""
            if i < 10{
                text = "0" + String(i)
            } else{
                text = String(i)
            }
            let stringOfMonth = text + "/" + dateString
            for record in self.records {
                
                let date = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                
                if date.containsString(stringOfMonth){
                    if (type == 0) {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == 1) {
                        COGSAmount += amount
                        totalCOGSAmount += amount
                    } else if (type == 2) {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    } else if (type == 3) {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                }
                
            }
            
            series1.append(salesAmount)
            series2.append(expensesAmount)
            series3.append(COGSAmount)
        }
        let sales = "$" + String(format: "%.2f", totalSalesAmount)
        let expenses = "$" + String(format: "%.2f", totalExpensesAmount)
        let COGS = "$" + String(format: "%.2f", totalCOGSAmount)
        let profit = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount - totalCOGSAmount))
        
        return (months, series1, series2, series3, sales, expenses, profit, COGS)
    }
    
    //for loading record weekly
    func loadRecordsWeekly(daysInWeek: [String]) -> ([Double], [Double], [Double], String, String, String, String){
        
        var salesAmount = 0.00
        var expensesAmount = 0.00
        var COGSAmount = 0.00
        var series1 = [Double]()
        var series2 = [Double]()
        var series3 = [Double]()
        var totalSalesAmount = 0.00
        var totalExpensesAmount = 0.00
        var totalCOGSAmount = 0.00
        
        for stringToCheck in daysInWeek{
            salesAmount = 0.00
            expensesAmount = 0.00
            COGSAmount = 0.00
            for record in self.records {
                
                let date = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                
                if date.containsString(stringToCheck){
                    if (type == 0) {
                        salesAmount += amount
                        totalSalesAmount += amount
                    } else if (type == 1) {
                        COGSAmount += amount
                        totalCOGSAmount += amount
                    } else if (type == 2) {
                        expensesAmount += amount
                        totalExpensesAmount += amount
                    }
                    
                }
                
            }
            series1.append(salesAmount)
            series2.append(expensesAmount)
            series3.append(COGSAmount)
        }
        let sales = "$" + String(format: "%.2f", totalSalesAmount)
        let expenses = "$" + String(format: "%.2f", totalExpensesAmount)
        let COGS = "$" + String(format: "%.2f", totalCOGSAmount)
        let profit = "$" + String(format: "%.2f", (totalSalesAmount - totalExpensesAmount - totalCOGSAmount))
        return (series1, series2, series3, sales, expenses, profit, COGS)
    }

}
