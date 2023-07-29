//
//  LoginViewController.swift
//  Tendable
//
//  Created by Josh Barker on 07/07/2023.
//

import UIKit

class LoginViewController: TCViewController {

    @IBOutlet weak var userDetailsView: UserDetailsView!
    
    @IBOutlet weak var offlineModeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userDetailsView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userDetailsView.configure(theActionName: "Login")
        
        let inspection = QuestionsViewModel.shared.getCompleteInspection()
        
        if inspection != nil {
            self.offlineModeButton.isHidden = false
        } else {
            self.offlineModeButton.isHidden = true
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showRegisterView", sender: nil)
    }
    
    @IBAction func offlineModePressed(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "showQuestionsView", sender: nil)
        
        SceneDelegate.redirectToMainNavRVC(currentVC: self)
    }
    
    


}

extension LoginViewController : UserDetailsViewDelegate {

    func userDatailsFailedValidation() {
        self.showUserAlert(titleStr: "Oh no...!", msg: "User details are not valid...!")
    }
    
    
    func actionButtonPressed(theUser: UserModel) {
        
        UserViewModel.shared.loginUserToServer(theUser: theUser, loginCompletion: { (success:Bool, error:String)  in
            
            DispatchQueue.main.async {
                
                if success {

                    SceneDelegate.redirectToMainNavRVC(currentVC: self)
                    
                    //self.performSegue(withIdentifier: "showHistoryView", sender: nil)

                } else {
                    self.showUserAlert(titleStr: "Oh no...!", msg: "Error logging in...!")
                }
                
            }
            
        })
        
        
    }
    
}
