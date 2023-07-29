//
//  APIManager.swift
//  Tendable
//
//  Created by Josh Barker on 06/07/2023.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    static let shared = APIManager ()
    
    let API_URL = "http://127.0.0.1:5001/"
    
    var session = Session ()
    
    func registerUser (email: String, password: String, completion: @escaping (_ success: Bool, _ error: String) -> Void)  {
        
        let params: Parameters = [
            "email": email,
            "password": password,
        ]
        
        var headers = HTTPHeaders()
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        headers.add(httpHeader)
        
        AF.request(API_URL + "api/register", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).response { response in
            
            switch response.result {
            case .success(let data):
                
                completion (true, "")
                
            case .failure(let error):
                
                Logging.JLog(message: "WARN : errpr : \(error.localizedDescription)")
                
                completion (false, error.localizedDescription)
            }
        }
        
    }
    
    func loginUser (email: String, password: String, completion: @escaping (_ success: Bool, _ error: String) -> Void)  {
        
        let params: Parameters = [
            "email": email,
            "password": password,
        ]
        
        var headers = HTTPHeaders()
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        headers.add(httpHeader)
        
        AF.request(API_URL + "api/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).response { response in
            
            switch response.result {
            case .success(let data):
                
                completion (true, "")

            case .failure(let error):
                
                Logging.JLog(message: "WARN : errpr : \(error.localizedDescription)")
                
                completion (false, error.localizedDescription)
            }
        }
        
    }
    
    func getInspectionsMock (completion: @escaping (_ success: Bool, _ error: String, _ inspection: InspectionModel?) -> Void)  {
        
        var headers = HTTPHeaders()
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        headers.add(httpHeader)
        
        
        
        let apiUrl = API_URL + "inspections/start"
        Logging.JLog(message: "apiUrl : " + apiUrl)
        
        session.request(API_URL + "api/inspections/start", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).responseData { response in
            
            switch response.result {
            case .success(let data):
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        Logging.JLog(message: "WARN : Error: Cannot convert data to JSON object")
                        completion (false, "Error: Cannot convert data to JSON object", nil)
                        
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        
                        Logging.JLog(message: "WARN : Error: Cannot convert JSON object to Pretty JSON data")
                        completion (false, "Error: Cannot convert JSON object to Pretty JSON data", nil)
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        
                        Logging.JLog(message: "WARN : Error: Could print JSON in String")
                        completion (false, "Error: Could print JSON in String", nil)
                        return
                    }
                    
                    let decoded = try JSONSerialization.jsonObject(with: data) as? InspectionModel
                    Logging.JLog(message: "decoded : \(decoded)")
                    
                    let decoder = JSONDecoder()
                    
                    /*
                     let inspectionData = try decoder.decode([String: Inspection].self, from: prettyJsonData)
                     
                     if let inspection = inspectionData["inspection"] {
                     Logging.JLog(message: "inspection : \(inspection)")
                     }*/
                    
                    let inspectionData = try decoder.decode([String: InspectionModel].self, from: prettyJsonData)
                    
                    if let inspection = inspectionData["inspection"] {
                        Logging.JLog(message: "inspection : \(inspection)")
                        completion (true, "", inspection)
                    } else {
                        completion (true, "", nil)
                    }
                    
                    //print(prettyPrintedJson)
                } catch {
                    Logging.JLog(message: "WARN : Error: Trying to convert JSON data to string")
                    completion (false, "Error: Trying to convert JSON data to string", nil)
                    return
                }
            case .failure(let error):
                print(error)
                
                completion (false, error.localizedDescription, nil)
            }
        }
        
    }
    
    
    func getInspections (completion: @escaping (_ success: Bool, _ error: String, _ inspection: InspectionModel?) -> Void)  {
        
        var headers = HTTPHeaders()
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        headers.add(httpHeader)
        
        let apiUrl = API_URL + "inspections/start"
        Logging.JLog(message: "apiUrl : " + apiUrl)
        
        
        
        //self.session = sessionManager
        
        self.session.request(API_URL + "api/inspections/start", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).responseData { response in
            
            switch response.result {
            case .success(let data):
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        Logging.JLog(message: "WARN : Error: Cannot convert data to JSON object")
                        completion (false, "Error: Cannot convert data to JSON object", nil)
                        
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        
                        Logging.JLog(message: "WARN : Error: Cannot convert JSON object to Pretty JSON data")
                        completion (false, "Error: Cannot convert JSON object to Pretty JSON data", nil)
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        
                        
                        
                        Logging.JLog(message: "WARN : Error: Could print JSON in String")
                        completion (false, "Error: Could print JSON in String", nil)
                        return
                    }
                    
                    Logging.JLog(message: "prettyPrintedJson : \(prettyPrintedJson)")
                    
                    let decoded = try JSONSerialization.jsonObject(with: data) as? InspectionModel
                    Logging.JLog(message: "decoded : \(decoded)")
                    
                    let decoder = JSONDecoder()
                    
                    /*
                     let inspectionData = try decoder.decode([String: Inspection].self, from: prettyJsonData)
                     
                     if let inspection = inspectionData["inspection"] {
                     Logging.JLog(message: "inspection : \(inspection)")
                     }*/
                    
                    let inspectionData = try decoder.decode([String: InspectionModel].self, from: prettyJsonData)
                    
                    if let inspection = inspectionData["inspection"] {
                        Logging.JLog(message: "inspection : \(inspection)")
                        completion (true, "", inspection)
                    } else {
                        completion (true, "", nil)
                    }
                    
                    //print(prettyPrintedJson)
                } catch (let error) {
                    Logging.JLog(message: "WARN : Error: Trying to convert JSON data to string")
                    
                    Logging.JLog(message: "error : \(error)")
                    
                    completion (false, "Error: Trying to convert JSON data to string", nil)
                    return
                }
            case .failure(let error):
                print(error)
                
                completion (false, error.localizedDescription, nil)
            }
        }
        
    }
    
    
    func submitInspection (theInspection: InspectionModel, completion: @escaping (_ success: Bool, _ error: String) -> Void) {
    
        let jsonEncoder = JSONEncoder()
        
        var jsonStr = ""
        
        do {
            
            let jsonData = try jsonEncoder.encode(theInspection)
            jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            Logging.JLog(message: "jsonStr : \(jsonStr)")
            
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
        
        // should made this better. Maybe a top level object
        let jsonUseStr = "{ \"inspection\": " + jsonStr + "}"
        
        var headers = HTTPHeaders()
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        headers.add(httpHeader)

        let url = API_URL + "api/inspections/submit"
        
        Logging.JLog(message: "url : " + url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = (jsonUseStr).data(using: .unicode)
        
        // this does not return json
        AF.request(request).validate(statusCode: 200 ..< 299).response { response in
            
            switch response.result {
            case .success(let data):
                Logging.JLog(message: "success..!")

                completion (true, "")

                
            case .failure(let error):
                Logging.JLog(message: "failure..!")
                
                Logging.JLog(message: "error : \(error.localizedDescription)")
                
                completion (false, error.localizedDescription)
            }

            
        }
        
         
        
    }
    
}

