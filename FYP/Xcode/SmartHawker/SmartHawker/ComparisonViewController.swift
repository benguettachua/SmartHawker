//
//  ComparisonViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/9/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment

class ComparisonViewController: UIViewController {
    
    // MARK: Properties
    // Controllers
    let analyticController = AnalyticsController()
    
    // UI Button
    @IBOutlet weak var selectDateButton: UIButton!
    
    override func viewDidLoad() {
    
    }
    
    func getPastSixDays(date: NSDate) {
        
        let pastSixDays = analyticController.getPastSixSimilarDays(date)
        print(pastSixDays)
    }
    
    // Changing Dates of the record
    @IBAction func changeDate(sender: UIButton) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Creating the date picker
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .Date
        let pickerSize : CGSize = picker.sizeThatFits(CGSizeZero)
        
        // Adding date picker to a custom view to be added to the alert.
        let margin:CGFloat = 8.0
        let rect = CGRectMake(margin, margin, alertController.view.bounds.size.width - margin * 4.0, pickerSize.height)
        let customView = UIView(frame: rect)
        picker.frame = CGRectMake(customView.frame.size.width/2 - pickerSize.width/2, margin, pickerSize.width, pickerSize.height/2)
        customView.addSubview(picker)
        alertController.view.addSubview(customView)
        
        let cancelAction = UIAlertAction(title: "Done", style: .Default, handler: { void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.stringFromDate(picker.date)
            let momentDateSelected = moment(picker.date)
            let weekday = momentDateSelected.weekdayName
            self.selectDateButton.setTitle(dateString + ", " + weekday, forState: .Normal)
            self.getPastSixDays(picker.date)
            
        })
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
    }
}
