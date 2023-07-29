//
//  JHAViewController.swift
//  Motif
//
//  Created by Josh Barker on 14/01/2021.
//

import UIKit

class TCViewController: UIViewController {

    func showUserAlert (msg: String) {
        
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUserAlert (titleStr: String, msg: String) {
        
        let alert = UIAlertController(title: titleStr, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
