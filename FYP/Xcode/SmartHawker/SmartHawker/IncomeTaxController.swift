//
//  IncomeTaxController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 17/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

class IncomeTaxController {
    
    // Import DAO to access database
    let dao = connectionDAO()
    
    func retrieveThisYearRecord(year: String) -> [PFObject]{
        
        var thisYearRecord = [PFObject]()
        
        // Get all the records by user
        let records = dao.loadRecords()
        
        for record in records {
            let recordDate = record["date"] as! String
            
            // Filter the record by the year.
            if (recordDate.containsString(year)) {
                thisYearRecord.append(record)
            }
        }
        
        return thisYearRecord
    }
    
    // Calculate the amount of tax payable based on profit 'amount'.
    func calculateTax(amount: Double) -> Double{
        
        var taxPayable = 0.0
        
        // 2016 formula for calculation of tax.
        if (amount < 20000) {
            taxPayable = 0
        } else if (amount < 30000) {
            taxPayable = (amount - 20000) * 2 / 100
        } else if (amount < 40000) {
            taxPayable = (amount - 30000) * 3.50 / 100
            taxPayable += 200
        } else if (amount < 80000) {
            taxPayable = (amount - 40000) * 7 / 100
            taxPayable += 550
        } else if (amount < 120000) {
            taxPayable = (amount - 80000) * 11.5 / 100
            taxPayable += 3350
        } else if (amount < 160000) {
            taxPayable = (amount - 120000) * 15 / 100
            taxPayable += 7950
        } else if (amount < 200000) {
            taxPayable = (amount - 160000) * 17 / 100
            taxPayable += 13950
        } else if (amount < 320000) {
            taxPayable = (amount - 200000) * 18 / 100
            taxPayable += 20750
        } else {
            taxPayable = (amount - 320000) * 20 / 100
            taxPayable += 42350
        }
        
        return taxPayable
    }
    
    func getAllowableBusinessExpenses () -> PFObject? {
        return dao.getAllowableBusinessExpenses()
    }
    
    func updateAllowableBusinessExpenses (amount: Double) -> PFObject?{
        
        return dao.updateAllowableBusinessExpenses(amount)
        
    }
}
