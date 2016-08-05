//
//  SubuserTableViewCell.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 4/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class SubuserTableViewCell: UITableViewCell {
    
    // Properties
    // Labels
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var subuserNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    
    // Image View
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
