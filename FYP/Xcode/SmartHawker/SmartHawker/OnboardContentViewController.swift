//
//  OnboardContentViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 17/10/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class OnboardContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.imageFile)
    }
}
