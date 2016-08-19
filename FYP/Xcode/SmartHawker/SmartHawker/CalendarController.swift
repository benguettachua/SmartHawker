//
//  CalendarController.swift
//  SmartHawker
//
//  Created by Ben Chua Weilun on 17/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation

class CalendarController{
    
    var records = [PFObject]()
    
    func loadRecords(){
       
        records = connectionDAO().loadRecords()
        
    }
    
    func values(correctDateString: String) -> (Double, Double){
        
        records = connectionDAO().loadRecords()
        
        var salesAmount = 0.0
        var expensesAmount = 0.0
        var dates = [String]()
        for record in self.records {
            
            let dateString = record["date"] as! String
            let type = record["type"] as! Int
            let amount = record["amount"] as! Double
            
            dates.append(record["date"] as! String)
            if dateString.containsString(correctDateString){
                
                if (type == 0) {
                    salesAmount += amount
                } else if (type == 1) {
                    expensesAmount += amount
                } else if (type == 2) {
                    expensesAmount += amount
                }
            }
            
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dates, forKey: "SavedDateArray")
        
        return (salesAmount, expensesAmount)
    }
    
}