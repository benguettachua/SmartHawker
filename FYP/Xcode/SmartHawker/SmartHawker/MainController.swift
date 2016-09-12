//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import SwiftMoment
import CoreLocation;

class MainController{
    
    var firstDay: NSDate!
    var lastDay: NSDate!
    let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)

    func loadTargetRecords(currentMonth: String) -> (Bool, Double){
        
        let records = connectionDAO().loadRecords()
        
        for record in records{
            let date = record["date"] as! String
            let type = record["type"] as! Int
            let amount = record["amount"] as! Double
            
            if type == 4 {
                if date.containsString(currentMonth){
                    return (true, amount)
                }
            }
            
        }
        return (false, 0.00)
    }
    
    func deleteMonthlyTarget(monthlyString: String){
        let records = connectionDAO().loadRecords()
        for record in records{
            let date = record["date"] as! String
            let type = record["type"] as! Int
            let subUser = record["subUser"] as! String
            
            if date.containsString(monthlyString) && type == 4{
                connectionDAO().deleteRecord(subUser)
            }
        }
    }
    
    func getMainValues() -> (Double, Double, Double, Double, Double, Double, String, String, Double, Double, Double, Double, Double){
        thisWeekDates()
        var array = connectionDAO().loadRecords()
        var datesAndRecords = [String:[PFObject]]()
        var datesWithRecords = [String]()
        
        for object in array {
            let dateString = object["date"] as! String
            if datesAndRecords[dateString] == nil {
                var arrayForRecords = [PFObject]()
                arrayForRecords.append(object)
                datesAndRecords[dateString] = arrayForRecords
            }else{
                datesAndRecords[dateString]?.append(object)
            }
        }
        var weeklySales = 0.0
        var weeklyExpenses = 0.0
        var weeklyCOGS = 0.0
        var weeklyProfit = 0.0
        var totalSales = 0.0
        var totalDays = 0.0
        var highSales = 0.0
        var highSalesDay = "None".localized()
        var lowSales = 0.0
        var lowSalesDay = "None".localized()
        var totalProfit = 0.0
        var expenses = 0.0
        var COGS = 0.0
        
        for (myKey,myValue) in datesAndRecords {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(NSDate())
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let recordDate = dateFormatter.dateFromString(myKey)
            let todayDate = dateFormatter.stringFromDate(NSDate())
            let earlier = recordDate!.earlierDate(NSDate()).isEqualToDate(recordDate!) && myKey.containsString(correctDateString)
            let same = myKey.containsString(todayDate)
            
            let earlierThanThisWeek = recordDate!.earlierDate(firstDay).isEqualToDate(recordDate!)
            
            var profit = 0.0
            var sales = 0.0
            
            for record in myValue {
                if earlier || same {
                    let type = record["type"] as! Int
                    if (type == 0 || type == 1 || type == 2) {
                        if datesWithRecords.contains(record["date"] as! String) == false {
                            datesWithRecords.append(record["date"] as! String)
                            totalDays += 1.0
                            
                        }
                    }
                    
                    let amount = record["amount"] as! Double
                    //let subuser = object["subuser"] as? String
                    if (type == 0) {
                        totalProfit += amount
                        totalSales += amount
                        profit += amount
                        sales += amount
                        
                        
                        //to get max and min sales
                        if sales > highSales{
                            highSales = sales
                            highSalesDay = myKey
                        }
                        
                        if lowSales == 0 && sales > 0{
                            lowSales = sales
                            lowSalesDay = myKey
                        }else if sales < lowSales && sales > 0{
                            lowSales = sales
                            lowSalesDay = myKey
                        }
                        
                    } else if (type == 1) {
                        COGS += amount
                        profit -= amount
                        totalProfit -= amount
                    } else if (type == 2) {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    }
                    
                    if earlierThanThisWeek == false || myKey.containsString(todayDate) {
                        if (type == 0) {
                            weeklyProfit += amount
                            weeklySales += amount
                        }else if (type == 1) {
                            weeklyCOGS += amount
                            weeklyProfit -= amount
                        } else if (type == 2) {
                            weeklyExpenses += amount
                            weeklyProfit -= amount
                        }
                    }
                }

                
            }
            
        }
        var averageSales = 0.0
        if totalDays != 0{
            averageSales = (totalSales/totalDays)
        }
        return (totalSales,expenses,totalProfit,highSales,lowSales,averageSales,highSalesDay,lowSalesDay, COGS, weeklySales, weeklyCOGS, weeklyExpenses, weeklyProfit)
    }
    
    func thisWeekDates(){
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
            firstDay = calendar!.dateByAddingComponents(
                periodComponents,
                toDate: NSDate(),
                options: [])!
        
        periodComponents.day = 7 - dayOfWeek
        lastDay = calendar!.dateByAddingComponents(
            periodComponents,
            toDate: NSDate(),
            options: [])!
        
        
    }
    
}


