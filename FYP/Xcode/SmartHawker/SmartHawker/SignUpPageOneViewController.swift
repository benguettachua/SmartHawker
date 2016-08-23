//
//  SignUpPageOneViewController.swift
//  SmartHawker
//
//  Created by GX on 22/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import Material
import FontAwesome_iOS
import UIKit


class SignUpPageOneViewController: UIViewController {

    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var cancelbtn: UIButton!
    override func viewDidLoad() {
        
    super.viewDidLoad()
        var faicon = [String: UniChar]()
        faicon["facross"] = 0xf00d
        
        cancelbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 25)
        
        cancelbtn.setTitle(String(format: "%C", faicon["facross"]!), forState: .Normal)
        
        
    let phoneNumber = TextField()
    phoneNumber.placeholder = "Enter your phone number"
    
    phoneNumber.detail = "Enter 8 digits."
        
    //if phone number format wrong then show this
    //phoneNumber.detail = "Error. Please enter correct phone number format."
    //
        
    view.layout(phoneNumber).top(100).horizontally(left: 20, right: 20)
    }


}