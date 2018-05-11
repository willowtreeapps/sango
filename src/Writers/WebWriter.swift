//
//  WebWriter.swift
//  Sango
//
//  Created by Adam Shea on 5/7/18.
//  Copyright © 2018 Afero, Inc. All rights reserved.
//

import Foundation


class WebWriter : Writer {
    var configuration: Configuration
        
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func writeConstants(_ name: String, value: Any, level: Int) -> String {
        return ""
    }
    
    func writeIds(_ identifiers: Dictionary<String, Any>) {

    }
}
