//
//  QuestionModel.swift
//  Tendable
//
//  Created by Josh Barker on 08/07/2023.
//

struct QuestionModel: Codable {

    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case score
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
}
