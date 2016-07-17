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
    var description: String!
    
    // MARK: Initialisation
    init (date: String, type: String, amount: Int, objectId: String, description: String) {
        self.date = date
        self.type = type
        self.amount = amount
        self.objectId = objectId
        self.description = description
    }
    
    func toString() -> String {
        let toReturn = "Date: " + date + " Type: " + type + " Amount: " + String(amount) + " Object Id: " + objectId + " Description: " + description
        return toReturn
    }
    
}
