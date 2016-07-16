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
        // Declare the necessary variables.
        let taxReliefAmount = Int(taxReliefAmountTextField.text!)
        let yearToCalculate = Int(yearToCalculateTextField.text!)
        
        // Load records from local datastore
        loadRecordsFromLocaDatastore(yearToCalculate!, completionHandler: { (success) -> Void in
            if (success) {
                // UI is populated.
                
            } else {
                print("Some error thrown.")
            }
        })
        
        
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
                    
                    totalProfit = totalSales - totalCOGS - totalExpenses
                    self.incomeValueLabel.text = String(totalProfit)
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
    
}
