//
//  RecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 27/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var dateSelectedLabel: UILabel!
    var shared = ShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelectedLabel.text = self.shared.dateSelected
    }
}
