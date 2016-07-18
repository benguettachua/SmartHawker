//
//  ReportsViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController {
    
    // Mark: Properties
    // General Variables
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    //Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    // Labels
    @IBOutlet weak var yearToCalculateLabel: UILabel!
    @IBOutlet weak var taxPayableLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var taxableIncomeLabel: UILabel!
    @IBOutlet weak var taxReliefLabelTop: UILabel!
    @IBOutlet weak var taxReliefLabelBtm: UILabel!
    
    @IBOutlet weak var taxPayableValueLabel: UILabel!
    @IBOutlet weak var incomeValueLabel: UILabel!
    @IBOutlet weak var reliefValueLabel: UILabel!
    @IBOutlet weak var taxableIncomeValueLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var yearToCalculateTextField: UITextField!
    @IBOutlet weak var taxReliefAmountTextField: UITextField!
    
    
    // Mark: Action
    @IBAction func Logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
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
                    let taxableIncome = income - Double(taxReliefAmount)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        businessName.text! = user!["businessName"] as! String
        username.text! = user!["username"] as! String
        
        // Getting the profile picture
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        
    }
    
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
    
    /**
     * Closes the keyboard when the user touches anywhere
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
