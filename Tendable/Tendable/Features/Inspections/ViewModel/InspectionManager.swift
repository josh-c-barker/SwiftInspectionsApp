//
//  InspectionManager.swift
//  Tendable
//
//  Created by Josh Barker on 09/07/2023.
//
//  Manager the details of an inspection.

import UIKit
import CoreData

class InspectionManager: NSObject {

    static let shared = InspectionManager ()
    
    var managedContext:NSManagedObjectContext?

    private override init() {
        
        if self.managedContext == nil {
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            self.managedContext =
            appDelegate.persistentContainer.viewContext
        }
        
    }
    
    func getInspections () -> [Inspection]  {
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Inspection")
        
        var inspectionsFound = [Inspection] ()
        
        do {
            let inspectionsRaw = try self.managedContext!.fetch(fetchRequest)
            Logging.JLog(message: "")
            
            for insRaw in inspectionsRaw {
                
                let insGot = insRaw as? Inspection
                inspectionsFound.append(insGot!)
            }
            
            
            return inspectionsFound
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not fetch. \(error), \(error.userInfo)")
            
            return inspectionsFound
        }
        
    }
    
    func saveInspection (theInspection: InspectionModel) -> Inspection {
        
        let entity = NSEntityDescription.entity(forEntityName: "Inspection", in: self.managedContext!)!
        
        let inspection = NSManagedObject(entity: entity, insertInto: self.managedContext!) as! Inspection
        
        inspection.id = Int16(theInspection.id)
        inspection.areaId = Int16(theInspection.area.id)
        inspection.areaName = theInspection.area.name
        inspection.surveyId = Int16(theInspection.survey.id)
        inspection.inspectionTypeId = Int16(theInspection.inspectionType.id)
        inspection.inspectionTypeName = theInspection.inspectionType.name
        inspection.inspectionTypeAccess = theInspection.inspectionType.access.rawValue
        
        let cats = theInspection.survey.categories
        
        var csAdded = [Category] ()
        
        for cat in cats {
            let category = QuestionManager.shared.saveCategory(theCategory: cat)
            csAdded.append(category)
        }

        let catsSet = Set (csAdded)

        inspection.categories = catsSet as NSSet
        
        do {
            try self.managedContext!.save()
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not save. \(error), \(error.userInfo)")
        }
        
        return inspection
        
    }
    
    func deleteInspections () {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Inspection")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        
        do {
            
            try self.managedContext?.execute (deleteRequest)
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : error : \(error.localizedDescription)")
        }
        
    }
    
}
