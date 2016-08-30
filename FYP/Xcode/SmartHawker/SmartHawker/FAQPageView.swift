//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class FAQPage: UIViewController {
    
    //MARK properties
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        navBar.topItem?.title = "FAQ".localized()
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
