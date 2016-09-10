//
//  AnalyticsViewControllerNEW.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 7/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AnalyticsViewControllerNEW: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var analyticsCategory: UISegmentedControl!
    
    // Views
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    
    // MARK: Action
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            container1.alpha = 0
            container2.alpha = 0
            container3.alpha = 1
        } else if (sender.selectedSegmentIndex == 1) {
            container1.alpha = 1
            container2.alpha = 0
            container3.alpha = 0
        } else if (sender.selectedSegmentIndex == 2) {
            container1.alpha = 0
            container2.alpha = 1
            container3.alpha = 0
        }
    }
}
