//
//  SignUpPageTwoViewController.swift
//  SmartHawker
//
//  Created by GX on 23/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import Material
import FontAwesome_iOS
import UIKit


class SignUpPageTwoViewController: UIViewController {
    
    
    @IBOutlet weak var verCode: UITextField!
    
    @IBOutlet weak var backbtn: UIButton!
    override func viewDidLoad() {
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 25)
        
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
        
        let verCode = TextField()
        verCode.placeholder = "Verification Code"
        
        verCode.detail = ""
        
        //if phone number format wrong then show this
        //phoneNumber.detail = "Error. Please enter correct phone number format."
        //
        
        view.layout(verCode).top(175).horizontally(left: 20, right: 20)
    }
    
    
}