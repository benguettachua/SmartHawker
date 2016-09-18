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
    @IBOutlet weak var grossProfitLabel: UILabel!
    @IBOutlet weak var adjustedProfitLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var incomeTaxAmountLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var adjustProfitSub: UILabel!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var revenueLabelOnly: UILabel!
    @IBOutlet weak var grosssProfitLabelOnly: UILabel!
    @IBOutlet weak var calculationLabelOnly: UILabel!
    @IBOutlet weak var additionalBusinessExpenses: UILabel!
    @IBOutlet weak var adjustedProfitLabelOnly: UILabel!
    @IBOutlet weak var estimatedTaxPayable: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    
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
        additionalExpensesTextField.text = ""
        self.viewWillAppear(true)
    }
    
    @IBAction func previousYear(sender: UIButton) {
        var year = Int(yearLabel.text!)!
        year -= 1
        yearLabel.text = String(year)
        additionalExpensesTextField.text = ""
        self.viewWillAppear(true)
    }
    
    @IBAction func generateIncomeTax(sender: UIButton) {
        
        
        
        
        
        // Inform the user the amount of tax he will have to pay based on his income.
        let alert = UIAlertController(title: "Disclaimer".localized(), message: "The calculations below are only meant to help you estimate your income tax payable. For the actual amount to be declared to IRAS, please check with your accountant and/or review your own financial records for the relevant year of assessment before making your declaration.".localized(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { void in
            // Get the adjusted profit, which will be calculated for tax.
            var profit = self.adjustedProfitLabel.text
            
            // Remove the "$" in front of the string.
            profit?.removeAtIndex((profit?.startIndex)!)
            
            // Turn the adjusted profit into Double for calculation.
            let profitDouble = Double(profit!)
            
            // Calculate the amount of tax payable.
            let taxPayable = self.taxController.calculateTax(profitDouble!)
            
            self.incomeTaxAmountLabel.text = "$" + String(format:"%.2f", taxPayable)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalExpensesTextField.delegate = self
        additionalExpensesTextField.placeholder = "Optional".localized()
        navBar.title = "Income Tax".localized()
        back.title = "Back".localized()
        revenueLabelOnly.text = "Revenue".localized()
        totalSalesLabel.text = "(Total Sales)".localized()
        grosssProfitLabelOnly.text = "Gross Profit".localized()
        calculationLabelOnly.text = "(Total Sales - Total COGS)".localized()
        additionalBusinessExpenses.text = "Allowable Business Expenses".localized()
        adjustedProfitLabelOnly.text = "Adjusted Profit/Loss".localized()
        generateTaxButton.setTitle("Income Tax".localized(), forState: UIControlState.Normal)
        accessLabel.text = "Please assess your \nTotal Expenses and enter \nallowable amount. Check \nIRAS website if unsure.".localized()
        //access2Label.text = "Gross Profit – Allowable \nBusiness Expenses".localized()
        estimatedTaxPayable.text = "Your estimated tax payable is:".localized()
        
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
        var adjustedProfit = 0.0
        
        // Step 2: Loop through all records, adding each record to respective category.
        for record in records {
            
            if (record["type"] as! Int == 0) {
                
                // Revenue
                revenue += record["amount"] as! Double
            } else if (record["type"] as! Int == 1) {
                
                // Cost of goods sold
                COGS += record["amount"] as! Double
            }
        }
        
        // Step 3: Calculate gross profit and adjusted profit
        grossprofit = revenue - COGS
        adjustedProfit = grossprofit
        
        // Step 4: Populate with $ sign and 2 decimal place.
        revenueLabel.text = "$" + String(format:"%.2f", revenue)
        grossProfitLabel.text = "$" + String(format:"%.2f", grossprofit)
        adjustedProfitLabel.text = "$" + String(format:"%.2f", adjustedProfit)
        
        // Step 5: Find the allowable business expenses and populate the UI.
        let ABE_PFObject = taxController.getAllowableBusinessExpenses()
        if (ABE_PFObject == nil) {
            additionalExpensesTextField.text = "$0.00"
        } else {
            additionalExpensesTextField.text = "$" + String(format:"%.2f", ABE_PFObject!["amount"]as! Double)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy, hh.mm a"
            let lastUpdatedString = dateFormatter.stringFromDate((ABE_PFObject?.updatedAt)!)
            lastUpdatedLabel.text = "Last updated: ".localized() + lastUpdatedString
        }
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
        
        if (newValue![newValue!.startIndex] == "$") {
            newValue!.removeAtIndex(newValue!.startIndex)
        }
        let doubleValue = Double(newValue!)
        
        // Update the last updated record in database with this new value.
        let updatedABE = taxController.updateAllowableBusinessExpenses(doubleValue!)
        if (updatedABE != nil) {
            additionalExpensesTextField.text = "$" + String(format:"%.2f", updatedABE!["amount"]as! Double)
            print(updatedABE?.updatedAt) // To populate label with this
        } else {
            print("error")
        }
        
        var grossProfit = grossProfitLabel.text
        grossProfit?.removeAtIndex((grossProfit?.startIndex)!)
        
        // Change the UI with the newly calculated adjusted profit.
        var adjustedProfit = Double(grossProfit!)! - Double(newValue!)!
        adjustedProfitLabel.text = "$" + String(format: "%.2f", adjustedProfit)
        generateTaxButton.enabled = true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect the selected row after selecting to prevent the row from permanently highlighted.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
