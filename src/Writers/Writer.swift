//
//  PlatformWriter.swift
//  Sango
//
//  Created by Adam Shea on 5/7/18.
//  Copyright © 2018 Afero, Inc. All rights reserved.
//

import Foundation


public protocol Writer {
    
    var configuration: Configuration { get set }
        
    func writeIdentifiers(_ identifiers: Dictionary<String, Any>)

    func writeConstants(_ name: String, value: Any, level: Int) -> String

}

extension Writer {
    
    init(configuration: Configuration) {
        self.init(configuration: configuration)
    }
    
    func insertTabPerLine(_ text: String) -> String {
        var output = ""
        let lines = text.components(separatedBy: CharacterSet.newlines)
        for line in lines {
            if (line.characters.count > 0) {
                output.append("\n\t")
            }
            output.append(line)
        }
        return output
    }
    
    func writeToFile(_ data:String, file: String) {
        do {
            try data.write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Utils.error("Error: writing to \(file)")
            exit(-1)
        }
    }
}
