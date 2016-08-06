//
//  ReportsViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController, UITextFieldDelegate {
    
    // Mark: Properties
    // General Variables
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // Labels
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var COGSLabel: UILabel!
    @IBOutlet weak var grossProfitLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var adjustedProfitLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var additionalExpensesTextField: UITextField!
    
    // Button
    @IBOutlet weak var generateTaxButton: UIButton!
    
    
    
    // Mark: Action
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextYear(sender: UIButton) {
        var year = Int(yearLabel.text!)!
        year += 1
        yearLabel.text = String(year)
        self.viewWillAppear(true)
    }
    
    @IBAction func previousYear(sender: UIButton) {
        var year = Int(yearLabel.text!)!
        year -= 1
        yearLabel.text = String(year)
        self.viewWillAppear(true)
    }
    
    @IBAction func generateIncomeTax(sender: UIButton) {
        var taxPayable = 0.0
        var expenses = adjustedProfitLabel.text
        expenses?.removeAtIndex((expenses?.startIndex)!)
        let taxableDouble = Double(expenses!)
        print(taxableDouble)
        if (taxableDouble < 20000) {
            taxPayable = 0
        } else if (taxableDouble < 30000) {
            taxPayable = (taxableDouble! - 20000) * 2 / 100
        } else if (taxableDouble < 40000) {
            taxPayable = (taxableDouble! - 30000) * 3.50 / 100
            print(taxPayable)
            taxPayable += 200
        } else if (taxableDouble < 80000) {
            taxPayable = (taxableDouble! - 40000) * 7 / 100
            taxPayable += 550
        } else if (taxableDouble < 120000) {
            taxPayable = (taxableDouble! - 80000) * 11.5 / 100
            taxPayable += 3350
        } else if (taxableDouble < 160000) {
            taxPayable = (taxableDouble! - 120000) * 15 / 100
            taxPayable += 7950
        } else if (taxableDouble < 200000) {
            taxPayable = (taxableDouble! - 160000) * 17 / 100
            taxPayable += 13950
        } else if (taxableDouble < 320000) {
            taxPayable = (taxableDouble! - 200000) * 18 / 100
            taxPayable += 20750
        } else {
            taxPayable = (taxableDouble! - 320000) * 20 / 100
            taxPayable += 42350
        }
        
        let alert = UIAlertController(title: "Income Tax", message: "Your payable tax is $" + String(format: "%.2f", taxPayable) + ".", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalExpensesTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadRecords()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        generateTaxButton.enabled = false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        var newValue = textField.text
        if (newValue == nil || newValue == "") {
            newValue = "0.0"
        }
        var expenses = expensesLabel.text
        expenses?.removeAtIndex((expenses?.startIndex)!)
        var grossProfit = grossProfitLabel.text
        grossProfit?.removeAtIndex((grossProfit?.startIndex)!)
        var adjustedProfit = 0.0
        adjustedProfit = Double(grossProfit!)! - Double(expenses!)! - Double(newValue!)!
        adjustedProfitLabel.text = "$" + String(format: "%.2f", adjustedProfit)
        generateTaxButton.enabled = true
    }
    
    func loadRecords() {
        let query = PFQuery(className: "Record")
        let yearToRecord = yearLabel.text
        var records = [PFObject]()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: user!)
        do{
            records = try query.findObjects()
            var revenue = 0.0
            var COGS = 0.0
            var grossprofit = 0.0
            var expenses = 0.0
            var adjustedProfit = 0.0
            for record in records {
                let dateString = record["date"] as! String
                // Only count the records that are made in the selected year.
                if (dateString.containsString(yearToRecord!)){
                    if (record["type"] as! Int == 0) {
                        revenue += record["amount"] as! Double
                    } else if (record["type"] as! Int == 1) {
                        COGS += record["amount"] as! Double
                    } else if (record["type"] as! Int == 2) {
                        expenses += record["amount"] as! Double
                    } else if (record["type"] as! Int == 3) {
                        expenses += record["amount"] as! Double
                    }
                }
            }
            grossprofit = revenue - COGS
            adjustedProfit = grossprofit - expenses
            
            revenueLabel.text = "$" + String(format:"%.2f", revenue)
            COGSLabel.text = "$" + String(format:"%.2f", COGS)
            grossProfitLabel.text = "$" + String(format:"%.2f", grossprofit)
            expensesLabel.text = "$" + String(format:"%.2f", expenses)
            adjustedProfitLabel.text = "$" + String(format:"%.2f", adjustedProfit)
        } catch {
            
        }
    }
    /*
     @IBAction func calculateTax(sender: UIButton) {
     // Validate if the required fields are empty.
     var ok = 0
     if (taxReliefAmountTextField.text!.isEqual("")) {
     
     // Validition: Ensures that Business Address field is not empty
     taxReliefAmountTextField.text = ""
     taxReliefAmountTextField.attributedPlaceholder = NSAttributedString(string:"Tax Relief Required", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
     
     } else {
     ok += 1
     }
     
     if (yearToCalculateTextField.text!.isEqual("")) {
     
     // Validition: Ensures that Business Address field is not empty
     yearToCalculateTextField.text = ""
     yearToCalculateTextField.attributedPlaceholder = NSAttributedString(string:"Year Required", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
     
     } else {
     ok += 1
     }
     
     if (ok == 2) { // Both required fields are not empty
     // Declare the necessary variables.
     let taxReliefAmount = Int(taxReliefAmountTextField.text!)!
     let yearToCalculate = Int(yearToCalculateTextField.text!)!
     
     // Load records from local datastore
     loadRecordsFromLocaDatastore(yearToCalculate, completionHandler: { (success) -> Void in
     if (success) {
     // Populate the UI
     let income = Double(self.incomeValueLabel.text!)!
     var taxableIncome = income - Double(taxReliefAmount)
     if (taxableIncome < 0) {
     taxableIncome = 0.0
     }
     self.reliefValueLabel.text = String(format:"%.2f", Double(taxReliefAmount))
     self.taxableIncomeValueLabel.text = String(format:"%.2f", Double(taxableIncome))
     
     // Tax calculation
     var taxPayable = 0.0
     let taxableDouble = Double(taxableIncome)
     
     if (taxableIncome < 20000) {
     taxPayable = 0
     } else if (taxableIncome < 30000) {
     taxPayable = (taxableDouble - 20000) * 2 / 100
     } else if (taxableIncome < 40000) {
     taxPayable = (taxableDouble - 30000) * 3.50 / 100
     print(taxPayable)
     taxPayable += 200
     } else if (taxableIncome < 80000) {
     taxPayable = (taxableDouble - 40000) * 7 / 100
     taxPayable += 550
     } else if (taxableIncome < 120000) {
     taxPayable = (taxableDouble - 80000) * 11.5 / 100
     taxPayable += 3350
     } else if (taxableIncome < 160000) {
     taxPayable = (taxableDouble - 120000) * 15 / 100
     taxPayable += 7950
     } else if (taxableIncome < 200000) {
     taxPayable = (taxableDouble - 160000) * 17 / 100
     taxPayable += 13950
     } else if (taxableIncome < 320000) {
     taxPayable = (taxableDouble - 200000) * 18 / 100
     taxPayable += 20750
     } else {
     taxPayable = (taxableDouble - 320000) * 20 / 100
     taxPayable += 42350
     }
     
     self.taxPayableValueLabel.text = String(format:"%.2f", taxPayable)
     } else {
     print("Some error thrown.")
     }
     })
     }
     
     
     }
     
     */
    
    /*
     // Populate your income on UI
     func loadRecordsFromLocaDatastore(year: Int, completionHandler: CompletionHandler) {
     // Part 2: Load from local datastore into UI.
     let query = PFQuery(className: "Record")
     query.whereKey("user", equalTo: user!)
     query.fromLocalDatastore()
     query.findObjectsInBackgroundWithBlock {
     (objects: [PFObject]?, error: NSError?) -> Void in
     
     if error == nil {
     // Do something with the found objects
     if let objects = objects {
     var totalSales = 0
     var totalCOGS = 0
     var totalExpenses = 0
     var totalProfit = 0
     
     for object in objects {
     let dateString = object["date"] as! String
     // Only count the records that are made in the selected year.
     if (dateString.containsString(self.yearToCalculateTextField.text!)){
     let type = object["type"] as! Int
     let amount = object["amount"] as! Int
     if (type == 0) {
     totalSales += amount
     } else if (type == 1) {
     totalCOGS += amount
     } else if (type == 2) {
     totalExpenses += amount
     }
     }
     
     }
     
     totalProfit = totalSales - totalCOGS - totalExpenses
     self.incomeValueLabel.text = String(format:"%.2f", Double(totalProfit))
     print(String(format:"$.2f",Double(totalProfit)))
     completionHandler(success: true)
     }
     } else {
     // Log details of the failure
     print("Error: \(error!) \(error!.userInfo)")
     completionHandler(success: false)
     }
     }
     }
     */
    /**
     * Closes the keyboard when the user touches anywhere
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
