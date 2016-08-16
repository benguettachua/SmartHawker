//
//  SubuserController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 16/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

class SubuserController {
    
    // Import DAO to access database.
    let dao = connectionDAO()
    
    // This method retrieves all subusers from local datastore.
    func retrieveSubusers() -> [PFObject]{
         return dao.retrieveSubusers()
    }
    
    // This method edits the PIN of the selected subuser
    func editPIN(subuser: PFObject, oldPIN: String, newPIN: String, confirmPIN: String) -> Bool{
        
        // Validate if the entered fields are empty.
        if (oldPIN == "" || newPIN == "" || confirmPIN == "") {
            return false
        }
        
        // Validate if old PIN entered is equals to the PIN of the subuser
        let currentPIN = subuser["pin"] as! String
        if (oldPIN != currentPIN) {
            return false
        }
        
        // Validate if newPIN entered is equals to confirmPIN.
        if (newPIN != confirmPIN) {
            return false
        }
        
        // Update the PIN to new PIN.
        return dao.editPIN(currentPIN, newPIN: newPIN)
    }
    
    // This method deletes the selected subuser.
    func deleteSubuser(subuser: PFObject) -> Bool{
        
        let currentPIN = subuser["pin"] as! String
        return dao.deleteSubuser(currentPIN)
    }
}
