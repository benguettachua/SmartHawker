//
//  AppDelegate.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 6/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        Parse.enableLocalDatastore()
        Parse.setApplicationId("p5eYUBJtyvgCZrQM5pcOGLwaorWAUJn9q95Iwwht", clientKey: "RyMdMeTL5hzX4qxDntNn4UlR2CJAXWXfWT26pjWt")
        
        // Override point for customization after application launch.
        //***********************************************************
        // START OF INITIAL LAUNCH WILL PROMPT FOR LANGUAGE
        //***********************************************************
        IQKeyboardManager.sharedManager().enable = true
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstLaunch = defaults.boolForKey("firstLaunch")
        print(firstLaunch)
        if firstLaunch {
            print("Not first launch.")
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as UIViewController
            
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
        }else {
            print("First launch, setting NSUserDefault.")
            
            // When the app is first launched, set notification to be off.
            defaults.setBool(true, forKey: "notification")
            
            let notification = UILocalNotification()
            
            /* Time and timezone settings */
            let dateComp:NSDateComponents = NSDateComponents()
            dateComp.hour = 21
            dateComp.minute = 0
            dateComp.timeZone = NSTimeZone.systemTimeZone()
            let calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let date:NSDate = calender.dateFromComponents(dateComp)!
            
            notification.fireDate = date
            notification.repeatInterval = NSCalendarUnit.Day
            notification.timeZone = NSCalendar.currentCalendar().timeZone
            notification.alertBody = "Have you made your record today?"
            
            /* Action settings */
            notification.hasAction = true
            notification.alertAction = "View"
            
            /* Badge settings */
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            /* Schedule the notification */
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            defaults.setBool(true, forKey: "notification")
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("lang") as! UINavigationController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }
        //***********************************************************
        // END OF INITIAL LAUNCH ASK LANGUAGE
        //***********************************************************
        
        //***********************************************************
        // START OF ASK FOR NOTIFICATION PERMISSION
        //***********************************************************
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        // Set the badge number to zero when app is laugned
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //***********************************************************
        // END OF ASK FOR NOTIFICATION PERMISSION
        //***********************************************************
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

