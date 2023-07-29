//
//  QuestionTableViewCell.swift
//  Tendable
//
//  Created by Josh Barker on 09/07/2023.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateQuestionsTableCell (theQuestion: String, theAnswer: String) {
        
        self.questionLabel.text = "Q: " + theQuestion
        self.answerLabel.text = "A: " + theAnswer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
