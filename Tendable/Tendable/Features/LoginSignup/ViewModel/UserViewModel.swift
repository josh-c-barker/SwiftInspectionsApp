//
//  UserViewModel.swift
//  Tendable
//
//  Created by Josh Barker on 10/07/2023.
//

import UIKit

class UserViewModel: NSObject {

    static let shared = UserViewModel ()
 
    func registerUserWithServer (theUser: UserModel, registerCompletion: @escaping (_ success: Bool, _ error: String) -> Void)  {
        
        APIManager.shared.registerUser(email: theUser.email, password: theUser.password, completion: { (regSuccess:Bool, regError:String)  in
            
            registerCompletion (regSuccess, regError)
        })
        
    }

    func loginUserToServer (theUser: UserModel, loginCompletion: @escaping (_ success: Bool, _ error: String) -> Void)  {
        
        APIManager.shared.loginUser(email: theUser.email, password: theUser.password, completion: { (loginSuccess:Bool, loginError:String)  in
            
            if loginSuccess {
                UserManager.shared.currentUser = theUser
                UserManager.shared.markUserLoggedIn()
            }
            
            loginCompletion (loginSuccess, loginError)
        })
        
    }

    
}
