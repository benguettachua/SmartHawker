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
    
    // MARK: Action
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        print(analyticsCategory.selectedSegmentIndex)
    }
}
