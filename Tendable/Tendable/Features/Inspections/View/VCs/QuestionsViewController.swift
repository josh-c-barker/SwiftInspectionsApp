//
//  QuestionsViewController.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

import UIKit
import CoreData

class QuestionsViewController: TCViewController {

    @IBOutlet weak var questionsTableView: QuestionsTableView!
    
    @IBOutlet weak var questionsHeaderView: QuestionsHeaderView!
    
    var selectedQuestion:QuestionTypeModel?
    var selectedCategory:CategoryTypeModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        Logging.JLog(message: "viewDidLoad")
        self.questionsTableView.delegate = self
        
        self.updateUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Logging.JLog(message: "viewWillAppear")
        
        self.updateUI()

    }
    
    func updateUI () {
        
        let inspection = QuestionsViewModel.shared.getCompleteInspection()
        InspectionViewModel.shared.currentInspection = inspection
        
        if inspection != nil {

            self.questionsTableView.populateQuestionsView(theSurvey: inspection!.survey)
            
            self.questionsHeaderView.populateQuestionHeaderView(theInspection: inspection!, theScore: QuestionsViewModel.shared.currentScore)
        }

    }
    
    @IBAction func submitInspectionPressed(_ sender: Any) {
        Logging.JLog(message: "submitInspectionPressed")
        
        InspectionViewModel.shared.submitInspectionsToServer (submitCompletion: { (success:Bool, error:String)  in
            Logging.JLog(message: "success : \(success)")
            
            if success {
                self.showUserAlert(titleStr: "Hello", msg: "Submission was successful...!")
            } else {
                self.showUserAlert(titleStr: "Oh no...!", msg: "Submission was not successful...!")
            }
            
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? QuestionDetailViewController {
            vc.selectedQuestion = self.selectedQuestion
            vc.selectedCategory = self.selectedCategory
        }
        
    }
}

extension QuestionsViewController : QuestionsTableViewDelegate {

    func questionsTableQuestionPressed(theQuestion: QuestionTypeModel, theCategory: CategoryTypeModel) {
        
        Logging.JLog(message: "questionsTableQuestionPressed")
        
        self.selectedQuestion = theQuestion
        self.selectedCategory = theCategory
        
        self.performSegue(withIdentifier: "showDetailView", sender: nil)
    }
    
}
