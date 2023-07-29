//
//  CategoryTypeModal.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

struct CategoryTypeModel: Codable {
    let id: Int
    let name: String
    let questions: [QuestionTypeModel]
}
