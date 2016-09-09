//
//  AnalyticsController.swift
//  SmartHawker
//
//  Created by Ben Chua Weilun on 19/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import SwiftMoment

class AnalyticsController{
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var monthsInNum = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var records = [PFObject]()
    var today = moment(NSDate())
    
    func loadRecords(){
        
        records = connectionDAO().loadRecords()
        
    }
    
    func yearlyCalculation(year: String) -> ([Double]! , [Double]!, [Double]!){
        
        
        var i = 0
        var salesList = [Double]()
        var expensesList = [Double]()
        var profitsMonthly = [Double]()
        var stringMonths = [String]()
        
        for month in self.monthsInNum{
            
            let yearAndMonth = String(month) + "/" + String(year)
            var salesAmount = 0.0
            var expensesAmount = 0.0
            var profit = 0.0
            stringMonths.append(yearAndMonth)
            for record in self.records {
                
                let dateString = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                
                if dateString.containsString(yearAndMonth){
                    //let subuser = object["subuser"] as? String
                    if (type == 0) {
                        salesAmount += amount
                    } else if (type == 1) {
                        expensesAmount += amount
                    } else if (type == 2) {
                        expensesAmount += amount
                    } else if (type == 3){
                        expensesAmount += amount
                    }
                }
                
            }
            
            //for year
            salesList.append(salesAmount)
            expensesList.append(expensesAmount)
            profit = salesAmount - expensesAmount

            profitsMonthly.append(Double(profit))
            
            
            
            i += 1
        }
        return (salesList, expensesList, profitsMonthly)
    }
    
    
    
    
    func monthlyCalculation(numDays: Int) -> ([Double]! , [Double]!, [String]!) {
        
        var salesListForDay = [Double]()
        var expensesListForDay = [Double]()
        var profitDaily = [Double]()
        var days = [String]()
        
        var stringOfDayMonthYear = ""
        if today.month < 10{
            stringOfDayMonthYear = "0" + String(today.month) + "/" + String(today.year)
        }else{
            stringOfDayMonthYear = String(today.month) + "/" + String(today.year)
        }
        for day in 1...numDays{
            var salesAmountForDay = 0.0
            var expensesAmountForDay = 0.0
            var profitForDay = 0.0
            var yearMonthDay = ""
            if day < 10 {
                yearMonthDay = "0" + String(day) + "/" + stringOfDayMonthYear
            }else{
                yearMonthDay = String(day) + "/" + stringOfDayMonthYear
            }
            days.append(yearMonthDay)
            for record in self.records {
                
                let dateString = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
            
                if dateString.containsString(yearMonthDay){
                    //let subuser = object["subuser"] as? String
                    if (type == 0) {
                        salesAmountForDay += amount
                    } else if (type == 1) {
                        expensesAmountForDay += amount
                    } else if (type == 2) {
                        expensesAmountForDay += amount
                    } else if (type == 3){
                        expensesAmountForDay += amount
                    }
                }
                
            }
            //for month
            salesListForDay.append(salesAmountForDay)
            expensesListForDay.append(expensesAmountForDay)
            profitForDay = salesAmountForDay - expensesAmountForDay
            profitDaily.append(Double(profitForDay))
        }
        
        
        
        return (salesListForDay, expensesListForDay, days)
    }
    
    // Load the values of the day.
    func loadTodayRecord() -> (Double, Double, Double, Double) {
        
        // Load the records
        loadRecords()
        
        // Variables to return
        var sales = 0.0
        var COGS = 0.0
        var expenses = 0.0
        var profit = 0.0
        
        // Convert today's date to usable format.
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.stringFromDate(date)
        
        // Loop through all records to pick out relavant records.
        for record in self.records {
            let recordDate = record["date"] as! String
            if (recordDate == dateString) {
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                if (type == 0) {
                    sales += amount
                } else if (type == 1) {
                    COGS += amount
                } else if (type == 2) {
                    expenses += amount
                }
            }
        }
        profit = sales - COGS - expenses
        return (sales, COGS, expenses, profit)
    }
    
}