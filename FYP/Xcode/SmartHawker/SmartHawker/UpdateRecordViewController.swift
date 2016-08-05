//
//  UpdateRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateRecordViewController: UIViewController{
    
    // MARK: Properties
    var shared = ShareData.sharedInstance
    
    // Container Views
    @IBOutlet weak var expensesView: UIView!
    @IBOutlet weak var salesView: UIView!
    
    // Segment Control
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editType = shared.selectedRecord.type
        if (editType == "Sales") {
            self.expensesView.alpha = 0
            self.salesView.alpha = 1
        } else {
            self.expensesView.alpha = 1
            self.salesView.alpha = 0
            self.segmentCtrl.selectedSegmentIndex = 1
        }
    }
    
    
    @IBAction func changeType(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            UIView.animateWithDuration(0.5, animations: {
                self.expensesView.alpha = 0
                self.salesView.alpha = 1
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.expensesView.alpha = 1
                self.salesView.alpha = 0
            })
        }
    }
    
}
