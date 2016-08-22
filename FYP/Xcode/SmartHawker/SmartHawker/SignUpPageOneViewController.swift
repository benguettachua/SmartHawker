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

    
    var faicon = [String: UniChar]()
    @IBOutlet weak var cancel: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        
        faicon["fatimes"] = 0xf00d
        cancel.text = String(format: "%C", faicon["fatimes"]!)
        
    let phoneNumber = TextField()
    phoneNumber.placeholder = "Enter your phone number"
    
    phoneNumber.detail = "Enter 8 digits."
        
    //if phone number format wrong then show this
    //phoneNumber.detail = "Error. Please enter correct phone number format."
    //
        
    view.layout(phoneNumber).top(100).horizontally(left: 20, right: 20)
    }


}