//
//  APIManagerTest.swift
//  TendableTests
//
//  Created by Josh Barker on 10/07/2023.
//

import XCTest

final class APIManagerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegister() throws {
        
        let exp:XCTestExpectation = expectation(description: "was success")

        let email = "josh3@tc.com"
        let password = "Password1234"
        
        APIManager.shared.registerUser (email: email, password: password, completion: { (regSuccess:Bool, regError:String)  in
            
            Logging.JLog(message: "regError : \(regError)")
            
            if regSuccess {
                exp.fulfill()
            }
            
        })
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    // assumes josh3@tc.com has been registered previously
    func testLogin() throws {
        
        let exp:XCTestExpectation = expectation(description: "was success")

        let email = "josh3@tc.com"
        let password = "Password1234"
        
        APIManager.shared.loginUser(email: email, password: password, completion: { (loginSuccess:Bool, loginError:String)  in
            
            if loginSuccess {
                exp.fulfill()
            }
            
        })
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testStartInspection () throws {
        
        let exp:XCTestExpectation = expectation(description: "was success")

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
    
    func testSubmitInspection () throws {
        
        let exp:XCTestExpectation = expectation(description: "was success")

        APIManager.shared.getInspections (completion: { (success:Bool, error:String, inspection:InspectionModel?)  in
            
            Logging.JLog(message: "success : \(success)")
            
            XCTAssert(inspection != nil)
            
            APIManager.shared.submitInspection (theInspection: inspection!, completion: { (submitSuccess:Bool, submitError:String)  in
                
                Logging.JLog(message: "submitSuccess : \(submitSuccess)")
                
                if submitSuccess {
                    exp.fulfill()
                }

            })
            
            
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
