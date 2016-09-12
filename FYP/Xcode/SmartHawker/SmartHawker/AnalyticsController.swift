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
    
    // Return an array of sales amount based on their best sales
    func getBestSalesMonth() -> ([Int : Double], [Int], Double){
        
        var bestSalesMonth = [Int : Double] ()
        var total = 0.0
        // Get the year.
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = Int(dateFormatter.stringFromDate(date))
        // Load records
        loadRecords()
        
        // Loop through all records and save them according to their month.
        for record in self.records {
            
            // Check the year of the record, only work with the current year records.
            let recordDateString = record["date"] as! String
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let recordDate = dateFormatter.dateFromString(recordDateString)
            
            // Get the year of this record.
            dateFormatter.dateFormat = "yyyy"
            let recordYear = Int(dateFormatter.stringFromDate(recordDate!))
            if (recordYear == year) {
                
                // Get the type of the record, only work with type "Sales".
                let type = record["type"] as! Int
                if (type == 0) {
                    
                    // Get the month of this record.
                    dateFormatter.dateFormat = "MM"
                    let recordMonth = Int(dateFormatter.stringFromDate(recordDate!))
                    
                    // Get the amount of this record.
                    let amount = record["amount"] as! Double
                    
                    // Add this record's amount to its month's total sales
                    var monthAmount = bestSalesMonth[recordMonth!]
                    if (monthAmount == nil) {
                        monthAmount = 0.0
                    }
                    let newMonthAmount = monthAmount! + amount
                    bestSalesMonth[recordMonth!] = newMonthAmount
                    total += amount
                }
            }
        }
        let sortedKeys = Array(bestSalesMonth.keys).sort({bestSalesMonth[$0] < bestSalesMonth[$1]})
        return (bestSalesMonth, sortedKeys, total)
    }
    
    // Return an array of sales amount based on their best sales
    func getBestSalesYear() -> ([Int : Double], [Int]){
        
        var bestSalesYear = [Int : Double] ()
        
        // Initialize Date Formatter to use
        let dateFormatter = NSDateFormatter()
        
        // Load records
        loadRecords()
        
        // Loop through all records and save them according to their year.
        for record in self.records {
            
            // Check the year of the record, only work with the current year records.
            let recordDateString = record["date"] as! String
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let recordDate = dateFormatter.dateFromString(recordDateString)
            
            // Get the year of this record.
            dateFormatter.dateFormat = "yyyy"
            let recordYear = Int(dateFormatter.stringFromDate(recordDate!))
            
            // Get the type of the record, only work with type "Sales".
            let type = record["type"] as! Int
            if (type == 0) {
                
                // Get the amount of this record.
                let amount = record["amount"] as! Double
                
                // Add this record's amount to its year total sales
                var yearAmount = bestSalesYear[recordYear!]
                if (yearAmount == nil) {
                    yearAmount = 0.0
                }
                let newYearAmount = yearAmount! + amount
                bestSalesYear[recordYear!] = newYearAmount
            }
            
        }
        let sortedKeys = Array(bestSalesYear.keys).sort({bestSalesYear[$0] < bestSalesYear[$1]})
        return (bestSalesYear, sortedKeys)
    }
    
    // Return an array of the past six similar days
    func getPastSixSimilarDays(date: NSDate) -> [String : Double] {
        
        // Initialise NSDateFormatter to work with it.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Set an NSDictionary to store all 6 days.
        var pastSixDays = [String : Double]()
        let chosenDateString = dateFormatter.stringFromDate(date)
        pastSixDays[chosenDateString] = 0.0
        
        // Populate the past 6 days to search for records
        var chosenDay = moment(date)
        for i in 1...5 {
            chosenDay = chosenDay.subtract(7.days)
            let pastDayDate = chosenDay.date
            let pastDateString = dateFormatter.stringFromDate(pastDayDate)
            pastSixDays[pastDateString] = 0.0
        }
        
        // Load Records
        loadRecords()
        
        for record in self.records {
            
            // Check if the record is the selected past six days.
            let recordDate = record["date"] as! String
            if (pastSixDays.keys.contains(recordDate)) {
                
                // Check the type of record, only use "Sales"
                let type = record["type"] as! Int
                if (type == 0) {
                    
                    // Get the amount and add to the dictionary for the respective dates.
                    let amount = record["amount"] as! Double
                    let dayAmount = pastSixDays[recordDate]
                    let newDayAmount = dayAmount! + amount
                    pastSixDays[recordDate] = newDayAmount
                }
            }
        }
        return pastSixDays
    }
}