//
//  HistoryViewController.swift
//  Tendable
//
//  Created by Josh Barker on 10/07/2023.
//

import UIKit

class HistoryViewController: UIViewController {

    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }

    func updateUI () {
        
        let inspection = QuestionsViewModel.shared.getCompleteInspection()
        
        if inspection != nil {
            self.continueButton.isHidden = false
            self.deleteButton.isHidden = false
        } else {
            self.continueButton.isHidden = true
            self.deleteButton.isHidden = true
        }
    }
    
    @IBAction func startNewPressed(_ sender: Any) {
        Logging.JLog(message: "startNewPressed")
        
        
        InspectionViewModel.shared.getInspectionFromServer (fetchCompletion: { [self] (success:Bool, error:String, inspection:InspectionModel?)  in
            
            if success && inspection != nil {
                _ = InspectionManager.shared.saveInspection(theInspection: inspection!)
                
                DispatchQueue.main.async {
                    self.updateUI()
                    
                    self.performSegue(withIdentifier: "showQuestionsView", sender: nil)
                }
            }
            
        })
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        Logging.JLog(message: "continuePressed")
        
        self.performSegue(withIdentifier: "showQuestionsView", sender: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        Logging.JLog(message: "logoutPressed")
        
        UserManager.shared.markUserLoggedOut()
        
        SceneDelegate.redirectToLoginVC(currentVC: self)
    }
    

    @IBAction func deletePressed(_ sender: Any) {
        Logging.JLog(message: "deletePressed")
        
        InspectionViewModel.shared.deleteInspectionsFromDevice()
        
        self.updateUI()
        
        
    }
    

}
