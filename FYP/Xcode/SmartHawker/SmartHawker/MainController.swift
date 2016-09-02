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
        var datesAndRecords = [String:[PFObject]]()
        var datesWithRecords = [String]()
        
        for object in array {
            let dateString = object["date"] as! String
            //            let type = object["type"] as! Int
            //            let amount = object["amount"] as! Double
            //            var localIdentifierString = object["subUser"]
            //            var recordedBy = object["subuser"]
            //            if (recordedBy == nil) {
            //                recordedBy = ""
            //            }
            //            var typeString = ""
            //            if (type == 0) {
            //                typeString = "Sales"
            //            } else if (type == 1) {
            //                typeString = "COGS"
            //            } else if (type == 2) {
            //                typeString = "Expenses"
            //            } else if (type == 3){
            //                typeString = "fixMonthlyExpenses"
            //            }
            //
            //            var description = object["description"]
            //
            //            if (description == nil || description as! String == "") {
            //                description = "No description"
            //            }
            //
            //            if (localIdentifierString == nil) {
            //                localIdentifierString = String(tempCounter += 1)
            //            }
            //
            //            let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
            if datesAndRecords[dateString] == nil {
                var arrayForRecords = [PFObject]()
                arrayForRecords.append(object)
                datesAndRecords[dateString] = arrayForRecords
            }else{
                datesAndRecords[dateString]?.append(object)
            }
        }
        
        var totalSales = 0.0
        var totalDays = 0.0
        var highSales = 0.0
        var highSalesDay = "None"
        var lowSales = 0.0
        var lowSalesDay = "None"
        var totalProfit = 0.0
        var expenses = 0.0
        
        for (myKey,myValue) in datesAndRecords {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(NSDate())
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let recordDate = dateFormatter.dateFromString(myKey)
            let todayDate = dateFormatter.stringFromDate(NSDate())
            let earlier = recordDate!.earlierDate(NSDate()).isEqualToDate(recordDate!) && myKey.containsString(correctDateString)
            let same = myKey.containsString(todayDate)
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
                        
                        
                        if sales < lowSales && sales > 0{
                            lowSales = sales
                            lowSalesDay = myKey
                        }
                        
                    } else if (type == 1) {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    } else if (type == 2) {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    }
                    
                    
                }
                
                
            }
            
        }
        
        return (totalSales,expenses,totalProfit,highSales,lowSales,(totalSales/totalDays),highSalesDay,lowSalesDay)
    }
    
}


