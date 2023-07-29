//
//  QuestionManager.swift
//  Tendable
//
//  Created by Josh Barker on 07/07/2023.
//

import CoreData
import Foundation
import UIKit

class QuestionManager: NSObject {
    
    static let shared = QuestionManager ()

    // have a CoreDataStack instead
    
    var managedContext:NSManagedObjectContext?
    
    var questions = [NSManagedObject] ()
    
    var questionsToIds = [Int:Int] ()
    
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
    
    func deleteAllQuestions () {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Question")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            
            try self.managedContext?.execute (deleteRequest)
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : error : \(error.localizedDescription)")
        }
    }
    
    func getQuestionAnswerFromCache (theQuestionId: Int) -> Int? {
         
        let answerId = self.questionsToIds [theQuestionId]
        
        return answerId
        
    }
    
    func getAllQuestions () {
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Question")
        
        do {
            self.questions = try self.managedContext!.fetch(fetchRequest)
            
            Logging.JLog(message: "self.questions : \(self.questions.count)")
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not fetch. \(error), \(error.userInfo)")
        }
        
        // cache answerids so we don't have to keep hitting CoreData
        for question in questions {
            
            let questionId = question.value(forKey: "id") as? Int
            let answerId = question.value(forKey: "answerId") as? Int
            
            if questionId != nil && answerId != nil {
                self.questionsToIds [questionId!] = answerId
            }
            

        }
        
    }
    
    // this is not used...?
    func updateQuestion (theQuestion: QuestionTypeModel) -> Question? {
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Question")
        
        fetchRequest.predicate = NSPredicate(format: "id == %i", theQuestion.id)
        
        var questionMade:Question?
        
        do {
            let questionsFound = try self.managedContext!.fetch(fetchRequest)
            
            if questionsFound.count == 0 {
                questionMade = self.saveQuestion(theQuestion: theQuestion)
            } else {
                
                questionMade = questionsFound.first as? Question
                questionMade!.setValue(theQuestion.selectedAnswerChoiceId, forKeyPath: "answerId")
                
                try self.managedContext!.save()
            }
            
            self.getAllQuestions()
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not fetch. \(error), \(error.userInfo)")
        }
        
        return questionMade
    }
    
    func saveQuestion (theQuestion: QuestionTypeModel) -> Question {
                
        let entity = NSEntityDescription.entity(forEntityName: "Question", in: self.managedContext!)!
          
        let question = NSManagedObject(entity: entity, insertInto: self.managedContext!) as! Question
          
        question.setValue(theQuestion.id, forKeyPath: "id")
        question.setValue(theQuestion.selectedAnswerChoiceId, forKeyPath: "answerId")
        question.setValue(theQuestion.name, forKeyPath: "name")
        
        var asAdded = [AnswerChoice] ()
        
        for answerChoice in theQuestion.answerChoices {
            
            let answerMade = self.saveAnswerChoice(theAnswer: answerChoice)
            asAdded.append(answerMade)
        }
        
        let answersSet = Set (asAdded)
         
        question.answers = answersSet as NSSet
        
        do {
            try self.managedContext!.save()
            questions.append(question)
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not save. \(error), \(error.userInfo)")
        }
        
        return question
    }
    
    func saveAnswerChoice (theAnswer: AnswerChoiceModel) -> AnswerChoice {
                
        let entity = NSEntityDescription.entity(forEntityName: "AnswerChoice", in: self.managedContext!)!
          
        let answer = NSManagedObject(entity: entity, insertInto: self.managedContext!) as! AnswerChoice
          
        answer.id = Int16(theAnswer.id)
        answer.name = theAnswer.name
        answer.score = theAnswer.score
        
        do {
            try self.managedContext!.save()
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not save. \(error), \(error.userInfo)")
        }
        
        return answer
    }
    
    func updateCategory (theCategory: CategoryTypeModel) {
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        fetchRequest.predicate = NSPredicate(format: "id == %i", theCategory.id)
        
        do {
            let objsFound = try self.managedContext!.fetch(fetchRequest)
            
            Logging.JLog(message: "objsFound : \(objsFound.count)")
            
            if objsFound.count == 0 {
                _ = self.saveCategory (theCategory: theCategory)
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func saveCategory (theCategory: CategoryTypeModel) -> Category {
                
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: self.managedContext!)!
        
        var qsAdded = [Question] ()
        
        for question in theCategory.questions {
            
            let questionSaved = self.saveQuestion(theQuestion: question)
            Logging.JLog(message: "questionSaved : \(questionSaved)")
            qsAdded.append(questionSaved)
            
        }
        
        Logging.JLog(message: "qsAdded : \(qsAdded.count)")
        
        let questionsSet = Set (qsAdded)
        
        let category = NSManagedObject(entity: entity, insertInto: self.managedContext!) as! Category
          
        category.id = Int16(theCategory.id)
        category.name = theCategory.name
        
        category.questions = questionsSet as NSSet
        
        do {
            try self.managedContext!.save()
//            questions.append(question)
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not save. \(error), \(error.userInfo)")
        }
        
        return category
    }
    
    func getAllCategories () -> [Category] {
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        var categoriesFound = [Category] ()
        
        do {
            let categories = try self.managedContext!.fetch(fetchRequest)
            
            Logging.JLog(message: "categories : \(categories.count)")
            

            for cat in categories {
                
                guard let catty = cat as? Category else {
                    continue
                }
                
                categoriesFound.append(catty)
            }
            
        } catch let error as NSError {
            Logging.JLog(message: "WARN : Could not fetch. \(error), \(error.userInfo)")
        }
        
        return categoriesFound
    }
    
    func markQuestionAnswered (theQuestion: QuestionTypeModel, theCategory: CategoryTypeModel) {
        
        let cats = self.getAllCategories()
        
        for cat in cats {
        
            let catId = cat.id
            
            if catId == theCategory.id {
                
                for ques in cat.questions! {
                    
                    let question = ques as! Question
                    
                    if question.id == theQuestion.id {
                        //Logging.JLog(message: "marking question : \(question.name) ans with \(theQuestion.selectedAnswerChoiceId)")
                        
                        if theQuestion.selectedAnswerChoiceId != nil {
                            
                            question.answerId = Int16(theQuestion.selectedAnswerChoiceId!)
                            
                            do {
                                try self.managedContext!.save()
                            } catch let error as NSError {
                                Logging.JLog(message: "WARN : Could not save. \(error), \(error.userInfo)")
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
}
