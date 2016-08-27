//
//  TransactionViewController.swift
//  SmartHawker
//
//  Created by Gao Min on 24/08/2016.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import FontAwesome_iOS

class TransactionViewController: UIViewController {
    
    // MARK: Properties
    // UI Bar Button Item
    @IBOutlet weak var expensesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var salesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    // Text Fields
    @IBOutlet weak var amountTextField: UITextField!
    
    // Labels
    @IBOutlet weak var SGDLabel: UILabel!
    @IBOutlet weak var positiveNegativeSignLabel: UILabel!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    // Variables
    let shared = ShareData.sharedInstance
    
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the type of record
        let record = shared.selectedRecord
        // Add new record
        if (record == nil) {
            selectSales(salesBarButtonItem)
        }
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
    
    @IBAction func nextPage(sender: UIButton) {
        self.performSegueWithIdentifier("nextPage", sender: self)
    }
    
    
    @IBAction func back(sender: AnyObject) {
        print("Am I here")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Move to page two of transaction
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("BYE")
        // Set the destination view controller
        let destinationVC : TransactionFinalViewController = segue.destinationViewController as! TransactionFinalViewController
        
        destinationVC.amount = Double(amountTextField.text!)!
    }
}
