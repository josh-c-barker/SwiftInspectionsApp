//
//  InspectionViewModel.swift
//  Tendable
//
//  Created by Josh Barker on 10/07/2023.
//

import UIKit

class InspectionViewModel: NSObject {

    static let shared = InspectionViewModel ()

    var currentInspection:InspectionModel?
    
    func submitInspectionsToServer (submitCompletion: @escaping (_ submitSuccess: Bool, _ submitError: String) -> Void) {
        
        let inspie = InspectionViewModel.shared.currentInspection
        
        APIManager.shared.submitInspection (theInspection: inspie!, completion: { (success:Bool, error:String)  in
            
            Logging.JLog(message: "success : \(success)")
            
            submitCompletion (success, error)
        })
        
    }
    
    func deleteInspectionsFromDevice () {
        
        InspectionManager.shared.deleteInspections()
    }
    
    func getInspectionFromServer (fetchCompletion: @escaping (_ fetchSuccess: Bool, _ fetchError: String, _ fetchInspection:InspectionModel?) -> Void) {
        
        InspectionManager.shared.deleteInspections()
        
        APIManager.shared.getInspections (completion: { (success:Bool, error:String, inspection:InspectionModel?)  in
            
            fetchCompletion (success, error, inspection)
            
        })
    }
    
}
