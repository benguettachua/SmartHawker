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
    // Labels
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recordedByLabel: UILabel!
    
    //Image Views
    @IBOutlet weak var buttonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
