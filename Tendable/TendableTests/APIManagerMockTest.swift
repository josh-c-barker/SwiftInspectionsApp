//
//  APIManagerMockTest.swift
//  TendableTests
//
//  Created by Josh Barker on 16/07/2023.
//

import XCTest
import Alamofire
import Mocker

final class APIManagerMockTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let exp:XCTestExpectation = expectation(description: "was success")

        
        
        let areaModel = AreaModel.init(id: 1, name: "MyArea")
        let accessType = AccessType.write
    
        let insTypeModel = InspectionTypeModel(id: 1, name: "inspection", access: accessType)
        
        let ans1 = AnswerChoiceModel.init(id: 1, name: "AAA", score: 1.0)
        let ans2 = AnswerChoiceModel.init(id: 2, name: "BBB", score: 1.0)

        let question = QuestionTypeModel(id: 1, answerChoices: [ans1, ans2], name: "QQQQ")
        
        let catty = CategoryTypeModel.init(id: 1, name: "CCCC", questions: [question])
        let surveyModel = SurveyTypeModal.init(id: 1, categories: [catty])
        
        let inspie = InspectionModel.init(id: 1, inspectionType: insTypeModel, area: areaModel, survey: surveyModel)
        
        let parent = [
            "inspection" : inspie
        ]
        
        let originalURL = URL(string: "http://127.0.0.1:5001/api/inspections/start")!
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(parent)
        
        let mock = Mock (url: originalURL, dataType: .json, statusCode: 200, data: [
            .get : jsonData
        ])
  
        mock.register()
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Session.init(configuration: configuration)
        
        APIManager.shared.session = sessionManager
        
        APIManager.shared.getInspections (completion: { (success:Bool, error:String, inspection:InspectionModel?)  in
            
            Logging.JLog(message: "success : \(success)")
            
            XCTAssert(inspection != nil)
            
            if success {
                exp.fulfill()
            }
            
        })
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
