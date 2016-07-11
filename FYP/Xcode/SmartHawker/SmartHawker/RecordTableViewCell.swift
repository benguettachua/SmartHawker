//
//  RecordTableViewCell.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    var rowSelected: Int!
    var shared = ShareData.sharedInstance
    
    // Delegate
    var delegate: MyCustomerCellDelegator!
    
    // MARK: Action
    @IBAction func editButton(sender: UIButton) {
        let records = shared.records
        let selectedRecord = records[rowSelected]
        if (self.delegate != nil) {
            shared.selectedRecord = selectedRecord
            self.delegate.callSegueFromCell(myData: selectedRecord)
        }
        
    }
    @IBAction func deleteButton(sender: UIButton) {
        print("Delete is clicked")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
