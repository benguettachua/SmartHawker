//
//  TransactionViewController.swift
//  SmartHawker
//
//  Created by Gao Min on 24/08/2016.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import FontAwesome_iOS

class TransactionViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    // UI Bar Button Item
    @IBOutlet weak var expensesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var salesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextBarButtonItem: UIButton!
    
    // Text Fields
    @IBOutlet weak var amountTextField: UITextField!
    
    // Labels
    @IBOutlet weak var SGDLabel: UILabel!
    @IBOutlet weak var positiveNegativeSignLabel: UILabel!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    
    // Variables
    let shared = ShareData.sharedInstance
    var type = 0
    var isNewRecord = false
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        salesBarButtonItem.title = "Sales"
        expensesBarButtonItem.title = "Expenses"
        amountTextField.placeholder = "Amount"
        
        // Get the type of record
        let record = shared.selectedRecord
        // Add new record
        if (record == nil) {
            selectSales(salesBarButtonItem)
            isNewRecord = true
        } 
        
        // Delegate for textfield
        amountTextField.delegate = self
        
        // Disable next button is no amount is entered.
        if (amountTextField.text!.isEmpty) {
            nextbtn.enabled = false
        }
        
        var faicon = [String: UniChar]()
        faicon["facross"] = 0xf00d
        faicon["faright"] = 0xf054
       
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        backbtn.setTitle(String(format: "%C", faicon["facross"]!), forState: .Normal)
        
        nextbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        nextbtn.setTitle(String(format: "%C", faicon["faright"]!), forState: .Normal)
    }
    
    // View Will Appear
    override func viewWillAppear(animated: Bool) {
        // Open the keyboard the moment the view is loaded.
        amountTextField.becomeFirstResponder()
    }
    
    // MARK: Actions
    // Select Sales
    @IBAction func selectSales(sender: UIBarButtonItem) {
        // UI Bar Button Item Change
        salesBarButtonItem.tintColor = hexStringToUIColor("006cff")
        expensesBarButtonItem.tintColor = UIColor.lightGrayColor()
        
        // Positive Negative Label Change
        positiveNegativeSignLabel.text = "+"
        positiveNegativeSignLabel.textColor = hexStringToUIColor("006cff")
        
        // SGD Label Change
        SGDLabel.textColor = hexStringToUIColor("006cff")
        
        // Change type
        type = 0
        
    }
    
    // Select Expenses
    @IBAction func selectExpenses(sender: AnyObject) {
        // UI Bar Button Item Change
        salesBarButtonItem.tintColor = UIColor.lightGrayColor()
        expensesBarButtonItem.tintColor = hexStringToUIColor("ff0000")
        
        // Positive Negative Label Change
        positiveNegativeSignLabel.text = "-"
        positiveNegativeSignLabel.textColor = hexStringToUIColor("ff0000")
        
        // SGD Label Change
        SGDLabel.textColor = hexStringToUIColor("ff0000")
        
        // Change type
        type = 1
    }
    
    // Changing colour based on colour code
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Moves the the next page to add or update Record.
    @IBAction func nextPage(sender: UIButton) {
        self.performSegueWithIdentifier("nextPage", sender: self)
    }
    
    // Dismiss the current view and go back to the previous page.
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Move to page two of transaction
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Set the destination view controller
        let destinationVC : TransactionFinalViewController = segue.destinationViewController as! TransactionFinalViewController
        
        destinationVC.amount = Double(amountTextField.text!)!
        destinationVC.type = type
        destinationVC.isNewRecord = isNewRecord
    }
    
    //Need to have the ViewController extend UITextFieldDelegate for using this feature
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Find out what the text field will be after adding the current edit
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if !text.isEmpty{//Checking if the input field is not empty
            nextbtn.enabled = true //Enabling the button
        } else {
            nextBarButtonItem.enabled = false //Disabling the button
        }
        
        // Return true so the text field will be changed
        return true
    }
    
    
}
