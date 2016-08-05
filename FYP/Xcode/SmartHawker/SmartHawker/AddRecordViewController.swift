//
//  AddRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {
    
    // Properties
    // Views
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var expensesView: UIView!
    
    // Action
    @IBAction func segmentCtrl(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            UIView.animateWithDuration(0.5, animations: {
                self.expensesView.alpha = 0
                self.saleView.alpha = 1
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.expensesView.alpha = 1
                self.saleView.alpha = 0
            })
        }
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.expensesView.alpha = 0
        self.saleView.alpha = 1
    }
}
