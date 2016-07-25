//
//  OverviewPopupViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 25/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class OverviewPopupViewController: UIViewController {
    
    
    // MARK: Action
    // Clicking this will close this overview
    @IBAction func closeView(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
