//
//  UserDetailsView.swift
//  Tendable
//
//  Created by Josh Barker on 07/07/2023.
//
//  View that shows a ui to capture email / password

import UIKit

protocol UserDetailsViewDelegate: NSObject {
    
    func actionButtonPressed (theUser: UserModel)

    func userDatailsFailedValidation ()

}

class UserDetailsView: UIView {

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var actionButton: UIButton!
    
    var delegate:UserDetailsViewDelegate?
    
    @IBOutlet private weak var emailField: UITextField!
    
    @IBOutlet private weak var passwordField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit ()
    }
    
    private func commonInit () {

        Bundle.main.loadNibNamed("UserDetailsView", owner:self, options: nil)
        addSubview(contentView)
        
        self.contentView.clipsToBounds = true
        self.contentView.frame.size = self.frame.size
        
        
    }
    
    func configure (theActionName: String) {
        self.actionButton.setTitle(theActionName, for: .normal)
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
        if self.emailField.text == nil || self.passwordField.text == nil {
            return
        }

        if self.emailField.text == "" || self.passwordField.text == "" {
            
            self.delegate?.userDatailsFailedValidation()
            
            return
        }

        let userModel = UserModel.init(email: self.emailField.text!, password: self.passwordField.text!)
        
        self.delegate?.actionButtonPressed (theUser: userModel)
    }
    
    
    

}
