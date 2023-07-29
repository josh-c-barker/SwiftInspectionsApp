//
//  RegisterViewController.swift
//  Tendable
//
//  Created by Josh Barker on 06/07/2023.
//

import UIKit

class RegisterViewController: TCViewController {

    
    @IBOutlet weak var userDetailsView: UserDetailsView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userDetailsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userDetailsView.configure(theActionName: "Register")
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
    }
    
}

extension RegisterViewController : UserDetailsViewDelegate {
    
    func userDatailsFailedValidation() {
        self.showUserAlert(titleStr: "Oh no...!", msg: "User details are not valid...!")
    }
    
    func actionButtonPressed(theUser: UserModel) {
        
        UserViewModel.shared.registerUserWithServer(theUser: theUser, registerCompletion: { (success:Bool, error:String)  in
            
            DispatchQueue.main.async {
                
                if success {
                    self.showUserAlert(titleStr: "Hello", msg: "User registered successfully.")
                } else {
                    self.showUserAlert(titleStr: "Oh no...!", msg: "Error registering user...!")
                }
                
            }

        })
        
        
    }
    
}
