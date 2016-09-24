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
    
    let formatter = NSNumberFormatter()
    
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
            if (profit![profit!.startIndex] == "$") {
                profit?.removeAtIndex((profit?.startIndex)!)
            }
            
            
            self.formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            // Turn the adjusted profit into Double for calculation.
            let profitDouble = Double(self.formatter.numberFromString(profit!)!)
            
            // Calculate the amount of tax payable.
            let taxPayable = self.taxController.calculateTax(profitDouble)
            
            self.formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            self.formatter.locale = NSLocale(localeIdentifier: "en_US")
            self.incomeTaxAmountLabel.text = self.formatter.stringFromNumber(taxPayable)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalExpensesTextField.delegate = self
        additionalExpensesTextField.placeholder = "Optional".localized()
        adjustProfitSub.text = "Gross Profit – Allowable \nBusiness Expenses".localized()
        navBar.title = "Income Tax".localized()
        back.title = "Back".localized()
        revenueLabelOnly.text = "Revenue".localized()
        totalSalesLabel.text = "(" + "Total Sales".localized() + ")"
        grosssProfitLabelOnly.text = "Gross Profit".localized()
        calculationLabelOnly.text = "(" + "Total Sales".localized() + " - " + "Total COGS".localized() + ")"
        additionalBusinessExpenses.text = "Allowable Business Expenses".localized()
        adjustedProfitLabelOnly.text = "Adjusted Profit/Loss".localized()
        generateTaxButton.setTitle("Calculate Income Tax".localized(), forState: UIControlState.Normal)
        accessLabel.text = "Please assess your \nTotal Expenses and enter \nallowable amount. Check \nIRAS website if unsure.".localized()
        //access2Label.text = "Gross Profit – Allowable \nBusiness Expenses".localized()
        estimatedTaxPayable.text = "Your estimated tax payable is:".localized()
        lastUpdatedLabel.text = "Last updated: ".localized()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let year = yearLabel.text
        
        // Load records of the year
        let records = taxController.retrieveThisYearRecord(year!)
        
        // Populate the UI with necessary information
        // Step 1: Reset all values to 0 to prevent double counting of any records.
        let revenue = records.0
        let COGS = records.1
        var grossprofit = records.2
        var adjustedProfit = records.3
        
        // Step 4: Populate with $ sign and 2 decimal place.
        revenueLabel.text = formatter.stringFromNumber(revenue)
        grossProfitLabel.text = formatter.stringFromNumber(grossprofit)
        
        
        // Step 5: Find the allowable business expenses and populate the UI.
        
        let ABE_PFObject = taxController.getAllowableBusinessExpenses()
        if (ABE_PFObject == nil) {
            additionalExpensesTextField.text = "$0.00"
        } else {
            additionalExpensesTextField.text = formatter.stringFromNumber(ABE_PFObject!["amount"]as! Double)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy, hh.mm a"
            
            let lastUpdatedDate = ABE_PFObject!["lastUpdated"]
            if lastUpdatedDate != nil {
                let lastUpdatedString = dateFormatter.stringFromDate((ABE_PFObject!["lastUpdated"] as! NSDate))
                lastUpdatedLabel.text = "Last updated: ".localized() + lastUpdatedString
            } else {
                lastUpdatedLabel.text = "Last updated: ".localized()
            }
            
            
            
        }
        
        
        var allowableBusinessExpensesString = additionalExpensesTextField.text
        if (allowableBusinessExpensesString![allowableBusinessExpensesString!.startIndex] == "$") {
            allowableBusinessExpensesString!.removeAtIndex(allowableBusinessExpensesString!.startIndex)
        }
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let allowableBusinessExpenses = Double(formatter.numberFromString(allowableBusinessExpensesString!)!)
        adjustedProfitLabel.text = "$" + formatter.stringFromNumber(adjustedProfit - allowableBusinessExpenses)!
    }
    
    // When the user is editting additional expenses, they are not allowed to click generate tax.
    func textFieldDidBeginEditing(textField: UITextField) {
        generateTaxButton.enabled = false
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var value = textField.text
        if (value![value!.startIndex] == "$") {
            value!.removeAtIndex(value!.startIndex)
        }
        let valueString = Double(formatter.numberFromString(value!)!)
        
        textField.text = String(valueString)
    }
    
    
    // Once the user is done editting additional expenses, reflect the change immediately. Re-enable the button to generate tax after that.
    func textFieldDidEndEditing(textField: UITextField) {
        
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        var newValue = textField.text
        if (newValue == nil || newValue == "" || Double(newValue!) == nil) {
            newValue = "0.0"
        }
        
        if (newValue![newValue!.startIndex] == "$") {
            newValue!.removeAtIndex(newValue!.startIndex)
        }
        let doubleValue = Double(formatter.numberFromString(newValue!)!)
        // Update the last updated record in database with this new value.
        let updatedABE = taxController.updateAllowableBusinessExpenses(doubleValue)
        if (updatedABE != nil) {
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            
            additionalExpensesTextField.text = formatter.stringFromNumber(updatedABE!["amount"]as! Double)
            let lastUpdated = updatedABE!["lastUpdated"] as! NSDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy, hh.mm a"
            lastUpdatedLabel.text = "Last updated: ".localized() + dateFormatter.stringFromDate(lastUpdated)
        } else {
            // Error
        }
        
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var grossProfit = grossProfitLabel.text
        grossProfit?.removeAtIndex((grossProfit?.startIndex)!)
        
        let grossProfitAmount = formatter.numberFromString(grossProfit!)
        // Change the UI with the newly calculated adjusted profit.
        var adjustedProfit = Double(grossProfitAmount!) - Double(newValue!)!
        adjustedProfitLabel.text = "$" + formatter.stringFromNumber(adjustedProfit)!
        self.incomeTaxAmountLabel.text = "-"
        generateTaxButton.enabled = true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect the selected row after selecting to prevent the row from permanently highlighted.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
