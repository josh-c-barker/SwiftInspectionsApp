//
//  UserManager.swift
//  Tendable
//
//  Created by Josh Barker on 16/07/2023.
//

import UIKit
import SwiftKeychainWrapper

class UserManager: NSObject {

    static let shared = UserManager ()
    
    // this could be used avoid logging in again.
    var currentUser:UserModel?

    func isUserLoggedIn () -> Bool {
        
        if KeychainWrapper.standard.hasValue(forKey: "user") {
            return true
        }
        
        return false
        
    }
    
    func markUserLoggedIn () {
        
        KeychainWrapper.standard.set(1, forKey: "user")
    }
    
    func markUserLoggedOut () {
        
        KeychainWrapper.standard.remove(forKey: "user")
        
    }
}
