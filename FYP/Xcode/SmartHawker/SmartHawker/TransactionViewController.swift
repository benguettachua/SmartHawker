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
    @IBOutlet weak var ExpensesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var SalesBarButtonItem: UIBarButtonItem!
    
    // View Did Load
    override func viewDidLoad() {
        self.viewDidLoad()
        
        UITextFieldTextDidBeginEditingNotification
    }
}
