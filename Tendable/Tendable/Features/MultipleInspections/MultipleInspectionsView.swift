//
//  MultipleInspectionsView.swift
//  Tendable
//
//  Created by Josh Barker on 17/07/2023.
//
//  wraps a UITableView showing Inspections

import UIKit

class MultipleInspectionsView: UIView {

    @IBOutlet private var contentView: UIView!

    @IBOutlet private weak var tableView: UITableView!

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

        Bundle.main.loadNibNamed("MultipleInspectionsView", owner:self, options: nil)
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
}

extension MultipleInspectionsView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell:QuestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: EXPANDING_CELL_REUSE_ID, for: indexPath) as! QuestionTableViewCell
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let item = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
                //Write your code in here
            }
            item.image = UIImage(named: "deleteIcon")

            let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
            return swipeActions
        }

    
}

extension MultipleInspectionsView : UITableViewDelegate {
    
    
}
