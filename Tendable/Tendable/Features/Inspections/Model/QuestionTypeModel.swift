//
//  QuestionTypeModal.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

struct QuestionTypeModel: Codable {

    let id: Int
    let answerChoices: [AnswerChoiceModel]
    let name: String
    var selectedAnswerChoiceId: Int?
}
