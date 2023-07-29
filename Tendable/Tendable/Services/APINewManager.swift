//
//  APINewManager.swift
//  Tendable
//
//  Created by Josh Barker on 17/07/2023.
//

import UIKit

class APINewManager: UIView {

    static let shared = APINewManager ()

    func getInspectionsMock (completion: @escaping (_ success: Bool, _ error: String, _ inspection: InspectionModel?) -> Void) {
        
        let apiUrl = API_URL + "inspections/start"
        
        let requestURL: NSURL = NSURL(string: apiUrl)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest) {
                    (data, response, error) -> Void in

                let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode

                    if (statusCode == 200) {
                        print("Everyone is fine, file downloaded successfully.")
                        do{
                             let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                         }
                         catch{ print("erroMsg") }

                    } else  {
                        print("Failed")
                    }
                }
                    task.resume()
        }
    
}
