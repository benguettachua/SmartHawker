//
//  SignUpPageThreeViewController.swift
//  SmartHawker
//
//  Created by GX on 23/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import Material
import FontAwesome_iOS
import UIKit


class SignUpPageThreeViewController: UIViewController {
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
        
        let name = TextField()
        name.placeholder = "Name"
        
        name.detail = ""
        
        view.layout(name).top(135).horizontally(left: 20, right: 20)
        
        let password = TextField()
        password.placeholder = "Password"
        
        password.detail = ""
        
        //if password format wrong then show this
        //password.detail = "Error. Please enter correct password format."
        //
        view.layout(password).top(215).horizontally(left: 20, right: 20)
        
        let confirmpassword = TextField()
        confirmpassword.placeholder = "Confirm Password"
        
        confirmpassword.detail = ""
        
        //if confirm password does not match password then show this
        //confirmpassword.detail = "Error. Does not match above password."
        //
        view.layout(confirmpassword).top(295).horizontally(left: 20, right: 20)
        
        let adminpin = TextField()
        adminpin.placeholder = "Admin Pin"
        
        adminpin.detail = ""
        
        //if adminpin format wrong then show this
        //adminpin.detail = "Error. Please enter correct adminpin format."
        //
        view.layout(adminpin).top(375).horizontally(left: 20, right: 20)
        
    }
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
}