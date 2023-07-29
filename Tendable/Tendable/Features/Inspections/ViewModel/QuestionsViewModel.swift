//
//  QuestionsViewModal.swift
//  Tendable
//
//  Created by Josh Barker on 07/07/2023.
//

import UIKit

class QuestionsViewModel: NSObject {

    static let shared = QuestionsViewModel ()

    
    
    var currentScore = Double (0)
    
    // This needs breaking up into smaller chunks
    func getCompleteInspection () -> InspectionModel? {
        
        var inspectionScore = Double (0)
        
        let inspectionsGot = InspectionManager.shared.getInspections()
        
        if inspectionsGot.count == 0 {
            return nil
        }
        
        guard let inspectionGot = inspectionsGot.first else {
            Logging.JLog(message: "WARN : nil inspections")
            return nil
        }
        
        guard let insAreaName = inspectionGot.areaName else {
            Logging.JLog(message: "WARN : nil areaName")
            return nil
        }
        
        let areaModel = AreaModel.init(id: Int(inspectionGot.areaId), name: insAreaName)

        guard let instAccess = inspectionGot.inspectionTypeAccess else {
            Logging.JLog(message: "WARN : nil accessType")
            return nil
        }
        
        guard let accessType = AccessType.init(rawValue: instAccess) else {
            Logging.JLog(message: "WARN : nil accessType init")
            return nil
        }
        
        guard let inspTypeName = inspectionGot.inspectionTypeName else {
            Logging.JLog(message: "WARN : nil inspectionTypeName")
            return nil
        }
        
        let insTypeModel = InspectionTypeModel(id: Int(inspectionGot.inspectionTypeId), name: inspTypeName, access: accessType)
        
        var catsMade = [CategoryTypeModel] ()
        
        guard let insCategories = inspectionGot.categories else {
            Logging.JLog(message: "WARN : nil category")
            return nil
        }
        
        for cat in insCategories {
            
            let category = cat as! Category
            
            var quesesMade = [QuestionTypeModel] ()
            
            guard let catQuestions = category.questions else {
                Logging.JLog(message: "WARN : nil questions")
                continue
            }
            
            for ques in catQuestions {
                
                let question = ques as! Question
                
                var answerChoices = [AnswerChoiceModel] ()
                
                guard let quesAnswers = question.answers else {
                    Logging.JLog(message: "WARN : nil answers")
                    continue
                }
                
                for ans in quesAnswers {
                    
                    guard let answer = ans as? AnswerChoice else {
                        continue
                    }
                    
                    answerChoices.append(self.convertAnswer(theAnswer: answer))
                }
                
                answerChoices = answerChoices.sorted(by: { $0.id > $1.id })
                
                let quesMade = self.convertQuestion(theQuestion: question, answers: answerChoices)
                
                inspectionScore = inspectionScore + self.getScoreForQuestion(theQuestion: quesMade, answers: answerChoices)
                Logging.JLog(message: "inspectionScore : \(inspectionScore)")
                
                quesesMade.append(quesMade)
            }
            
            quesesMade = quesesMade.sorted(by: { $0.id > $1.id })

            
            let catty = self.convertCategory(theCat: category, questions: quesesMade)
            
            catsMade.append(catty)
        }
        
        catsMade = catsMade.sorted(by: { $0.id > $1.id })
        
        let surveyModel = SurveyTypeModal.init(id: Int(inspectionGot.surveyId), categories: catsMade)
        
        self.currentScore = inspectionScore
        
        let inspie = InspectionModel.init(id: Int(inspectionGot.id), inspectionType: insTypeModel, area: areaModel, survey: surveyModel)
        
        return inspie
    }
    
    private func convertCategory (theCat: Category, questions: [QuestionTypeModel]) -> CategoryTypeModel {
        
        let cat = CategoryTypeModel.init(id: Int(theCat.id), name: theCat.name!, questions: questions)
        
        return cat
    }
    
    private func convertQuestion (theQuestion: Question, answers: [AnswerChoiceModel]) -> QuestionTypeModel {
        
        var ques = QuestionTypeModel(id: Int(theQuestion.id), answerChoices: answers, name: theQuestion.name!)
        ques.selectedAnswerChoiceId = Int(theQuestion.answerId)
        
        return ques
    }
    
    func getScoreForQuestion (theQuestion: QuestionTypeModel, answers: [AnswerChoiceModel]) -> Double {
        
        if theQuestion.selectedAnswerChoiceId == nil {
            return 0
        }
        
        for answer in answers {
            
            if theQuestion.selectedAnswerChoiceId == answer.id {
                
                return answer.score
            }
        }
        
        return 0
    }
    
    private func convertAnswer (theAnswer: AnswerChoice) -> AnswerChoiceModel {
        
        let ansId = Int(theAnswer.id)
        
        let ans = AnswerChoiceModel(id: ansId, name: theAnswer.name!, score: theAnswer.score)
        
        return ans
    }

    func getCategory (theCatIdx: Int) -> CategoryTypeModel? {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories

        guard cats != nil else {
            return nil
        }
        
        let catty = cats! [theCatIdx]
        
        return catty
    }

    
    func getQuestion (theCatIdx: Int, theQIdx: Int) -> QuestionTypeModel? {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories

        guard cats != nil else {
            return nil
        }
        
        let catty = cats! [theCatIdx]
        
        let question = catty.questions [theQIdx]
     
        return question
    }
    
    func getQuestionName (theCatIdx: Int, theQIdx: Int) -> String {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories

        guard cats != nil else {
            return ""
        }
        
        let catty = cats! [theCatIdx]
        
        let question = catty.questions [theQIdx]
        
        return question.name
    }
    
    func getQuestionAnswer (theCatIdx: Int, theQIdx: Int) -> String {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories

        guard cats != nil else {
            return ""
        }
        
        let catty = cats! [theCatIdx]
        
        let question = catty.questions [theQIdx]
        
        let ansId = question.selectedAnswerChoiceId
        
        if ansId == nil {
            return "Not Answered"
        }
        
        for answer in question.answerChoices {
            
            if answer.id == ansId {
                return answer.name
            }
            
        }
        
        return "Not Answered"
    }
    
    func getCategoryName (theIdx: Int) -> String {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories
        
        guard cats != nil else {
            return ""
        }
        
        return cats! [theIdx].name
        
    }
    
    func getCategoryNumQuestions (theIdx: Int) -> Int {
        
        let cats = InspectionViewModel.shared.currentInspection?.survey.categories
        
        guard cats != nil else {
            return 0
        }
        
        return cats! [theIdx].questions.count
        
    }
    
    func getNumberCategories () -> Int {
        
        let numCats = InspectionViewModel.shared.currentInspection?.survey.categories.count
        
        guard numCats != nil else {
            return 0
        }
        
        return numCats!
        
    }
    
    func answerQuestion (theAnsweredQuestion: QuestionTypeModel, theCategory: CategoryTypeModel) {
     
        QuestionManager.shared.markQuestionAnswered(theQuestion: theAnsweredQuestion, theCategory: theCategory)
        
    }
    
}
