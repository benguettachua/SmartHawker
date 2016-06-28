//
//  ShareData.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 28/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    
    var dateSelected: String!
    var date: NSDate!
}