//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = "Report".localized()
        tabBar.items?[1].title = "Analytics".localized()
        tabBar.items?[2].title = "Home".localized()
        tabBar.items?[3].title = "Calendar".localized()
        tabBar.items?[4].title = "Profile".localized()
        
    }

    
}
