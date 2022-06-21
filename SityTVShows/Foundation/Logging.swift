//
//  Logging.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

enum Logging {
    public static func logError(error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        
        var errDebugInfo = ""
        debugPrint(error, to: &errDebugInfo)
        
        print(
            """
            ------------------
            ⚠️ Error! File: \(fileName)
            Function: \(function) | Line: \(line)
            
            \(errDebugInfo)
            ------------------
            """)
    }
}
