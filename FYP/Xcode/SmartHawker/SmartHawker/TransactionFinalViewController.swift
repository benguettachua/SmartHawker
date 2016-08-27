//
//  TransactionFinalViewController.swift
//  SmartHawker
//
//  Created by Gao Min on 24/08/2016.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//


import UIKit
import FontAwesome_iOS

class TransactionFinalViewController: UIViewController {
    
    // MARK: Properties
    // Variables from previous VC
    var amount = Double()
    var type = Int()
    
    // UIButton
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    
    // UILabel
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // View Did Load
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c
        faicon["facalendar"] = 0xf274
        faicon["fadesc"] = 0xf044
        faicon["faimage"] = 0xf03e
        
        amountLabel.text = String(amount)

        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
        
        donebtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        donebtn.setTitle(String(format: "%C", faicon["fatick"]!), forState: .Normal)
        
        todaybtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        todaybtn.setTitle(String(format: "%C", faicon["facalendar"]!), forState: .Normal)
        
        descicon.font = UIFont(name: "FontAwesome", size: 20)
        
        descicon.text = String(format: "%C", faicon["fadesc"]!)
        
        imageicon.font = UIFont(name: "FontAwesome", size: 20)
        
        imageicon.text = String(format: "%C", faicon["faimage"]!)
        
    }
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
