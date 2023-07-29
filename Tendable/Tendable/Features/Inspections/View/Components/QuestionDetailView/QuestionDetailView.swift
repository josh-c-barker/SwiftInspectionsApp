//
//  QuestionDetailView.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//
//  UIView with some text and a picker.

import UIKit

protocol QuestionDetailViewDelegate: NSObject {
    
    func questionWasAnswered (theAnsweredQuestion: QuestionTypeModel)
    
    func questionAnswerIsBlank ()
}

class QuestionDetailView: UIView {

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var delegate:QuestionDetailViewDelegate?
    
    var question:QuestionTypeModel?
    var category:CategoryTypeModel?

    var pickerView:UIPickerView?
    
    var selectedAnswer:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit ()
    }
    
    private func commonInit () {

        Bundle.main.loadNibNamed("QuestionDetailView", owner:self, options: nil)
        addSubview(contentView)
        
        self.contentView.clipsToBounds = true
        self.contentView.frame.size = self.frame.size
        
        self.setupPickerView()
    }
    
    func populateQuestionDetailView (theQuestion: QuestionTypeModel, theCategory: CategoryTypeModel) {

        self.question = theQuestion
        self.category = theCategory
        
        self.questionLabel.text = self.question?.name
        
        // we just set this
        if self.question!.selectedAnswerChoiceId != nil {
            
            for ans in theQuestion.answerChoices {
                
                if ans.id == self.question!.selectedAnswerChoiceId {
                    self.answerLabel.text = "Answer : " + ans.name
                }
            }
            
        }
        
        self.setPickerDefault()
    }

    func setupPickerView () {
        
        self.pickerView = UIPickerView ()
        self.pickerView?.delegate = self
        
        self.answerTextField.inputView = self.pickerView
        self.answerTextField.becomeFirstResponder()
        
        
    }
    
    func setPickerDefault () {
        
        if self.question != nil {
            
            var counter = 0
            var rowFound = -1
            
            for ans in self.question!.answerChoices {
                
                if ans.id == self.question!.selectedAnswerChoiceId {
                    rowFound = counter
                }
                
                counter = counter + 1
            }
            
            if rowFound != -1 {
                self.pickerView?.selectRow(rowFound, inComponent: 0, animated: false)
            }
            
        }
    }
    
    @IBAction func saveAnswerPressed(_ sender: Any) {
        
        guard self.selectedAnswer != nil else {
            self.delegate?.questionAnswerIsBlank()
            return
        }
        
        
        self.question?.selectedAnswerChoiceId = self.selectedAnswer
        
        // if we are here then we must have a question to answer
        self.delegate?.questionWasAnswered(theAnsweredQuestion: self.question!)
    }
    
    
}

extension QuestionDetailView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let answerLabel = "Answer : " + self.question!.answerChoices [row].name
        
        // get the answer ready for answering
        self.selectedAnswer = self.question!.answerChoices [row].id
        
        self.answerLabel.text = answerLabel
    }
    
}

extension QuestionDetailView : UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard self.question != nil else {
            return ""
        }
        
        let answerChoice = self.question?.answerChoices [row]
        
        return answerChoice?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.question == nil {
            return 0
        }
        
        return self.question!.answerChoices.count
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
}
