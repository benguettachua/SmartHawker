//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var shared = ShareData.sharedInstance
   
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (selectedIndex == 1) {
            print("hello")
            let alert = UIAlertController(title: "Coming soon", message: "Function is coming soon.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Please check back again.", style: .Default, handler: { void in
                self.selectedViewController = self.viewControllers![2]
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBar.items?[0].title = "Report".localized()
        tabBar.items?[1].title = "Analytics".localized()
        tabBar.items?[2].title = "Home".localized()
        tabBar.items?[3].title = "Calendar".localized()
        tabBar.items?[4].title = "Profile".localized()
        
        // Start with the home page
        self.selectedViewController = self.viewControllers![2]
        let isSubUser = shared.isSubUser
        
        // If subuser, only allow calendar.
        if (isSubUser) {
            tabBar.items?[0].enabled = false
            tabBar.items?[1].enabled = false
            tabBar.items?[2].enabled = false
            tabBar.items?[3].enabled = true
            tabBar.items?[4].enabled = false
            self.selectedViewController = self.viewControllers![3]
        }
        
    }

    
}
