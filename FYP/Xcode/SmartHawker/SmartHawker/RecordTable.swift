//
//  RecordTable.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 3/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordTable {
    
    // MARK: Properties
    var date: String
    var type: String
    var amount: Int
    var objectId: String!
    
    // MARK: Initialisation
    init (date: String, type: String, amount: Int, objectId: String) {
        self.date = date
        self.type = type
        self.amount = amount
        self.objectId = objectId
    }
    
    func toString() -> String {
        let toReturn = "Date: " + date + " Type: " + type + " Amount: " + String(amount) + " Object Id: " + objectId
        return toReturn
    }
    
}
