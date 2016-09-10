//
//  BestSalesViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class BestSalesViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    
    // Controller
    let analyticController = AnalyticsController()
    
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            let (bestSalesMonth, sortedMonth) = analyticController.getBestSalesMonth()
            for month in sortedMonth {
                print("Month: " + String(month) + " Sales: " + String(bestSalesMonth[month]))
            }
            
        } else {
            let (bestSalesYear, sortedYear) = analyticController.getBestSalesYear()
            for year in sortedYear {
                print("Year: " + String(year) + " Sales: " + String(bestSalesYear[year]))
            }
        }
    }
    
}
