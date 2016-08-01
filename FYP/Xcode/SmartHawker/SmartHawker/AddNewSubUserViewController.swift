//
//  AddNewSubUserViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 1/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AddNewSubUserViewController: UIViewController {
    
    // MARK: Properties
    // Text Field
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var PINTextField: UITextField!
    
    // Variables
    let user = PFUser.currentUser()
    
    // MARK: Action
    @IBAction func addSubUser(sender: UIButton) {
        let subUser = PFObject(className: "SubUser")
        subUser.ACL = PFACL(user: user!)
        
        // Sub User Properties
        subUser["user"] = user
        subUser["name"] = nameTextField.text
        subUser["pin"] = PINTextField.text
        subUser["address"] = addressTextField.text
        subUser.saveEventually()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all PINS that are used
    }
}
