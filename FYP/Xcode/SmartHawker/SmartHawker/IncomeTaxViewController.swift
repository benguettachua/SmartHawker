//
//  ReportsViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class IncomeTaxViewController: UITableViewController, UITextFieldDelegate {
    
    // Mark: Properties
    
    // Controllers
    let taxController = IncomeTaxController()
    // General Variables
    let user = PFUser.currentUser()
    
    // Labels
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var COGSLabel: UILabel!
    @IBOutlet weak var grossProfitLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var adjustedProfitLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var back: UINavigationItem!
    @IBOutlet weak var cogsLabelOnly: UILabel!
    @IBOutlet weak var revenueLabelOnly: UILabel!
    @IBOutlet weak var grosssProfitLabelOnly: UILabel!
    @IBOutlet weak var calculationLabelOnly: UILabel!
    @IBOutlet weak var businessExpensesLabelOnly: UILabel!
    @IBOutlet weak var additionalBusinessExpenses: UILabel!
    @IBOutlet weak var adjustedProfitLabelOnly: UILabel!
    @IBOutlet weak var calculationsForAdjustedProfit: UILabel!
    
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
        
        // Get the adjusted profit, which will be calculated for tax.
        var profit = adjustedProfitLabel.text
        
        // Remove the "$" in front of the string.
        profit?.removeAtIndex((profit?.startIndex)!)
        
        // Turn the adjusted profit into Double for calculation.
        let profitDouble = Double(profit!)
        
        // Calculate the amount of tax payable.
        let taxPayable = taxController.calculateTax(profitDouble!)
        
        // Inform the user the amount of tax he will have to pay based on his income.
        let alert = UIAlertController(title: "Income Tax", message: "Your payable tax is $" + String(format: "%.2f", taxPayable) + ".", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalExpensesTextField.delegate = self
        additionalExpensesTextField.placeholder = "Optional"
        navBar.title = "Income Tax"
        back.title = "Back"
        cogsLabelOnly.text = "COGS"
        revenueLabelOnly.text = "Revenue"
        grosssProfitLabelOnly.text = "Gross Profit"
        calculationLabelOnly.text = "(Revenue - COGS)"
        businessExpensesLabelOnly.text = "Business Expenses"
        additionalBusinessExpenses.text = "Additional (Optional)\nBusiness Expenses"
        adjustedProfitLabelOnly.text = "Adjusted Profit"
        calculationsForAdjustedProfit.text = "(Gross Profit - Total Expenses)"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let year = yearLabel.text
        
        // Load records of the year
        let records = taxController.retrieveThisYearRecord(year!)
        
        // Populate the UI with necessary information
        // Step 1: Reset all values to 0 to prevent double counting of any records.
        var revenue = 0.0
        var COGS = 0.0
        var grossprofit = 0.0
        var expenses = 0.0
        var adjustedProfit = 0.0
        
        // Step 2: Loop through all records, adding each record to respective category.
        for record in records {
            
            if (record["type"] as! Int == 0) {
                
                // Revenue
                revenue += record["amount"] as! Double
            } else if (record["type"] as! Int == 1) {
                
                // Cost of goods sold
                COGS += record["amount"] as! Double
            } else if (record["type"] as! Int == 2) {
                
                // Expenses
                expenses += record["amount"] as! Double
            } else if (record["type"] as! Int == 3) {
                
                // Month fixed expenses still count as expenses
                expenses += record["amount"] as! Double
            }
        }
        
        // Step 3: Calculate gross profit and adjusted profit
        grossprofit = revenue - COGS
        adjustedProfit = grossprofit - expenses
        
        // Step 4: Populate with $ sign and 2 decimal place.
        revenueLabel.text = "$" + String(format:"%.2f", revenue)
        COGSLabel.text = "$" + String(format:"%.2f", COGS)
        grossProfitLabel.text = "$" + String(format:"%.2f", grossprofit)
        expensesLabel.text = "$" + String(format:"%.2f", expenses)
        adjustedProfitLabel.text = "$" + String(format:"%.2f", adjustedProfit)
    }
    
    // When the user is editting additional expenses, they are not allowed to click generate tax.
    func textFieldDidBeginEditing(textField: UITextField) {
        generateTaxButton.enabled = false
    }
    
    // Once the user is done editting additional expenses, reflect the change immediately. Re-enable the button to generate tax after that.
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
}
