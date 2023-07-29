//
//  QuestionsTableView.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//
//  wraps a UITableView showing questions

import UIKit

protocol QuestionsTableViewDelegate: NSObject {
    
    func questionsTableQuestionPressed (theQuestion: QuestionTypeModel, theCategory: CategoryTypeModel)
    
    
}

class QuestionsTableView: UIView {

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var tableView: UITableView!

    var delegate:QuestionsTableViewDelegate?
    
    let EXPANDING_CELL_REUSE_ID = "QuestionsTableViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit ()
    }
    
    private func commonInit () {

        Bundle.main.loadNibNamed("QuestionsTableView", owner:self, options: nil)
        addSubview(contentView)
        
        self.contentView.clipsToBounds = true
        self.contentView.frame.size = self.frame.size
        
        self.tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: EXPANDING_CELL_REUSE_ID)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    func populateQuestionsView (theSurvey: SurveyTypeModal) {
        
        self.tableView.reloadData()
        
    }
    
}

extension QuestionsTableView : UITableViewDelegate {
    
    
}

extension QuestionsTableView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return QuestionsViewModel.shared.getCategoryName(theIdx: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Logging.JLog(message: "didSelectRowAt")
        
        let question = QuestionsViewModel.shared.getQuestion(theCatIdx: indexPath.section, theQIdx: indexPath.row)
        let catty = QuestionsViewModel.shared.getCategory(theCatIdx: indexPath.section)

        
        if question != nil && catty != nil {
            self.delegate?.questionsTableQuestionPressed (theQuestion: question!, theCategory: catty!)
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return QuestionsViewModel.shared.getNumberCategories()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return QuestionsViewModel.shared.getCategoryNumQuestions(theIdx: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        let myCell:QuestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: EXPANDING_CELL_REUSE_ID, for: indexPath) as! QuestionTableViewCell
        
        //        myCell.populateLargeExpNewsCell(theStory: story, theIdx: indexPath.row)
        
        let questionName = QuestionsViewModel.shared.getQuestionName(theCatIdx: indexPath.section, theQIdx: indexPath.row)
        let answerText = QuestionsViewModel.shared.getQuestionAnswer(theCatIdx: indexPath.section, theQIdx: indexPath.row)
        
        myCell.populateQuestionsTableCell(theQuestion: questionName, theAnswer: answerText)
        
        
        cell = myCell
        
        return cell!
    }
    
    
}
