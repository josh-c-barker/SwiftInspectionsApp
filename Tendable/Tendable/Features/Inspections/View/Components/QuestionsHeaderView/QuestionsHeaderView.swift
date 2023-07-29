//
//  QuestionsHeaderView.swift
//  Tendable
//
//  Created by Josh Barker on 07/07/2023.
//

import UIKit

class QuestionsHeaderView: UIView {

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var inspectionNameLabel: UILabel!
    
    @IBOutlet weak var inspectionTypeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    
    var inspection:InspectionModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit ()
    }
    
    private func commonInit () {

        Bundle.main.loadNibNamed("QuestionsHeaderView", owner:self, options: nil)
        addSubview(contentView)
        
        self.contentView.clipsToBounds = true
        self.contentView.frame.size = self.frame.size
    }
    
    func populateQuestionHeaderView (theInspection: InspectionModel, theScore: Double) {
        self.inspection = theInspection
        
        self.inspectionNameLabel.text = self.inspection?.area.name
        self.inspectionTypeLabel.text = self.inspection?.inspectionType.name

        // inspection has to be non-nil at this point
        self.idLabel.text = "Id: #" + self.inspection!.id.description
        
        self.scoreLabel.text = "Score: " + theScore.description
    }
    
    
    

}
