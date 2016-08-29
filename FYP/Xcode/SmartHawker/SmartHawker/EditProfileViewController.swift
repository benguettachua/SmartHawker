//
//  EditProfileViewController.swift
//  SmartHawker
//
//  Created by GX on 29/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import Foundation
import Material
import FontAwesome_iOS
import UIKit


class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))

        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c

        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
        
        donebtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        donebtn.setTitle(String(format: "%C", faicon["fatick"]!), forState: .Normal)
        
        let name = TextField()
        name.placeholder = "NAME"
        name.text = "ang boon chang"
        
        view.layout(name).top(200).horizontally(left: 20, right: 20).height(22)
        
        let phone = TextField()
        phone.placeholder = "PHONE"
        phone.text = "98765432"
        
        view.layout(phone).top(245).horizontally(left: 20, right: 20).height(22)
        
        let email = TextField()
        email.placeholder = "EMAIL"
        email.text = "abc@sis"

        view.layout(email).top(290).horizontally(left: 20, right: 20).height(22)
        
        let bizname = TextField()
        bizname.placeholder = "BUSINESS NAME"
        bizname.text = "abc pte ltd"

    
    view.layout(bizname).top(335).horizontally(left: 20, right: 20).height(22)
        
        let biznum = TextField()
        biznum.placeholder = "BUSINESS NUMBER"
        biznum.text = "12345678"

        view.layout(biznum).top(380).horizontally(left: 20, right: 20).height(22)
        
        let address = TextField()
        address.placeholder = "ADDRESS"
        address.text = "21 seletar road"

    view.layout(address).top(425).horizontally(left: 20, right: 20).height(22)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    // Back
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}