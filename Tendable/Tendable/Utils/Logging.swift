//
//  Logging.swift
//  korke
//
//  Created by Josh Barker on 22/03/2023.
//

import UIKit

class Logging {
    
    class func JLog(message: String, functionName: String = #function, fileName: String = #file, lineNum: Int = #line) {
        
        NSLog ("%@", "\(fileName): \(functionName): \(lineNum): \(message)")
    }

}

