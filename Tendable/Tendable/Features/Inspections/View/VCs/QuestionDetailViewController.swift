//
//  QuestionDetailViewController.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

import UIKit

class QuestionDetailViewController: TCViewController {

    var selectedQuestion:QuestionTypeModel?
    var selectedCategory:CategoryTypeModel?

    @IBOutlet weak var questionDetailView: QuestionDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionDetailView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.selectedQuestion != nil && self.selectedCategory != nil {
            self.questionDetailView.populateQuestionDetailView(theQuestion: self.selectedQuestion!, theCategory: selectedCategory!)
        }
        
    }
    

}

extension QuestionDetailViewController: QuestionDetailViewDelegate {


    func questionAnswerIsBlank() {
        self.showUserAlert(titleStr: "Hello", msg: "Please select an answer before saving.")
    }
    

    func questionWasAnswered(theAnsweredQuestion: QuestionTypeModel) {
        
        guard self.selectedCategory != nil else {
            return
        }
        
        Logging.JLog(message: "markingAnswered")
        
        QuestionsViewModel.shared.answerQuestion(theAnsweredQuestion: theAnsweredQuestion, theCategory: self.selectedCategory!)
        
        self.showUserAlert(titleStr: "Hello", msg: "Your answer was saved.")
        
    }
    
    
}
