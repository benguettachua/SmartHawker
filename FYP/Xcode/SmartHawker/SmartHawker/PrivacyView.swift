//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class PrivacyView: UIViewController {
    
    //MARK properties
    @IBOutlet weak var navBackBtn: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        
        backbtn.titleLabel?.lineBreakMode
        backbtn.titleLabel?.numberOfLines = 2
        backbtn.titleLabel!.textAlignment = .Center
        
        var backs = String(format: "%C", faicon["faleftback"]!)
        
        backs += "\n"
        
        backs += "Back".localized()
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        backbtn.setTitle(String(backs), forState: .Normal);
        
        let navigationItem = UINavigationItem.init(title: "Privacy".localized())
        navigationItem.leftBarButtonItem = navBackBtn
        navBar.items = [navigationItem]
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
