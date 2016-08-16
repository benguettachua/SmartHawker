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
    
    func getMainValues() -> (Double, Double, Double, Double, Double, Double, String, String){
        
        var array = connectionDAO().loadRecords()
        var tempCounter = 0
        var datesAndRecords = [String:[RecordTable]]()
        var datesWithRecords = [String]()
        
        for object in array {
            let dateString = object["date"] as! String
            let type = object["type"] as! Int
            let amount = object["amount"] as! Double
            var localIdentifierString = object["subUser"]
            var recordedBy = object["subuser"]
            if (recordedBy == nil) {
                recordedBy = ""
            }
            var typeString = ""
            if (type == 0) {
                typeString = "Sales"
            } else if (type == 1) {
                typeString = "COGS"
            } else if (type == 2) {
                typeString = "Expenses"
            } else if (type == 3){
                typeString = "fixMonthlyExpenses"
            }
            
            var description = object["description"]
            
            if (description == nil || description as! String == "") {
                description = "No description"
            }
            
            if (localIdentifierString == nil) {
                localIdentifierString = String(tempCounter += 1)
            }
            
            let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
            if datesAndRecords[dateString] == nil {
                var arrayForRecords = [RecordTable]()
                arrayForRecords.append(newRecord)
                datesAndRecords[dateString] = arrayForRecords
            }else{
                datesAndRecords[dateString]?.append(newRecord)
            }
        }
        
        var totalSales = 0.0
        var totalDays = 0.0
        var highSales: Double!
        var highSalesDay: String!
        var lowSales: Double!
        var lowSalesDay: String!
        var totalProfit = 0.0
        var expenses = 0.0
        
        for (myKey,myValue) in datesAndRecords {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var correctDateString = dateFormatter.stringFromDate(NSDate())
            
            let recordDate = dateFormatter.dateFromString(myKey)
            let todayDate = dateFormatter.stringFromDate(NSDate())
            let earlier = recordDate!.earlierDate(NSDate()).isEqualToDate(recordDate!) && myKey.containsString(correctDateString)
            let same = myKey.containsString(todayDate)
            var profit = 0.0
            var sales = 0.0
            
            
            for record in myValue {
                if earlier || same {
                    if datesWithRecords.contains(record.date) == false {
                        datesWithRecords.append(record.date)
                        totalDays += 1.0
                    }
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        totalProfit += amount
                        totalSales += amount
                        profit += amount
                        sales += amount
                        
                        
                        //to get max and min sales
                        if highSales == nil && sales > 0{
                            highSales = sales
                            highSalesDay = record.date
                        }else if sales > highSales{
                            highSales = sales
                            highSalesDay = myKey
                        }
                        
                        
                        if lowSales == nil  && sales > 0{
                            lowSales = sales
                            lowSalesDay = myKey
                        }else if sales < lowSales && sales > 0{
                            lowSales = sales
                            lowSalesDay = myKey
                        }
                        
                    } else if (type == "COGS") {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    } else if (type == "Expenses") {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    }
                    
                    
                }
                
                
            }
            
        }
        if totalDays == 0.0 {
            highSales = 0.0
            lowSales = 0.0
            highSalesDay = "None"
            lowSalesDay = "None"
        }
        
        return (totalSales,expenses,totalProfit,highSales,lowSales,(totalSales/totalDays),highSalesDay,lowSalesDay)
    }
    
}


