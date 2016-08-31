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
   
    // This disables the Analytics tab and redirect the user back to home.
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let selectedTitle = tabBar.selectedItem?.title
        if (selectedTitle == "Analytics".localized()) {
            let alert = UIAlertController(title: "Coming soon".localized(), message: "Function currently developing!".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { void in
                self.selectedViewController = self.viewControllers![2]
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tabBar.items?[0].title = "Report".localized()
        tabBar.items?[1].title = "Analytics".localized()
        tabBar.items?[2].title = "Home".localized()
        tabBar.items?[3].title = "Calendar".localized()
        tabBar.items?[4].title = "Profile".localized()
        print(tabBar.items?[0].title)
        print(tabBar.items?[1].title)
        print(tabBar.items?[2].title)
        print(tabBar.items?[3].title)
        print(tabBar.items?[4].title)
        
        
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
    
    override func viewDidLoad() {
        // Start with the home page
        self.selectedViewController = self.viewControllers![2]
    }
    
}
