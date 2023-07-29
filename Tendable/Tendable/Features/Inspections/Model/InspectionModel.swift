//
//  InspectionModel.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

struct InspectionModel: Codable {

    let id: Int
    let inspectionType: InspectionTypeModel
    let area: AreaModel
    let survey: SurveyTypeModal

}
