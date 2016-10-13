//
//  ShareData.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 28/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment

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
    
    func clearData(){
        autoSync = true
        isSubUser = false
        subuser = nil
        storeDate = nil
        dateSelected = nil
        dateString = nil
        toDisplayDate = nil
        password = nil
        records = nil
        rowNo = nil
        selectedRecord = nil
        datesWithRecords = [String]()
        stringsWithAutoFill = nil
    }
    var autoSync = true
    var isSubUser = false
    var subuser: String!
    var storeDate: Moment!
    var dateSelected: String!
    var dateString: String!
    var toDisplayDate: String!
    var password: String!
    var records: [PFObject]!
    var rowNo: Int!
    var selectedRecord: PFObject!
    var datesWithRecords = [String]()
    var stringsWithAutoFill: [String]!
    // Month selected for population of Monthly Records.
    var monthSelected: NSDate!
}
