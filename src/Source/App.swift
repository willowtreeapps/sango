/**
 * Copyright 2016 Afero, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import AppKit
import CoreGraphics

let optConfig = "-config"

public enum Platform {
    case android
    case ios
    case web
    case test
}

class App {
    
    var configuration: Configuration? = nil

    func parseConfigFile() {
        let configFile = getOption(args, option: optConfig)
        if (configFile != nil) {
            let result = Utils.fromJSONFile(configFile!)
            if (result != nil) {
                configuration = Configuration.fromConfigFile(text: result!)
            } else {
                Utils.error("Error: must use configuration file")
                exit(-1)
            }
        }
    }
    
    func start(_ args: [String]) {
   
        parseConfigFile()

        var result:[String:Any]?
        
        guard let configuration = configuration else {
            Utils.error("Error: currently only works with a configuration file")
            exit(-1)
        }
        
        result = [:]
        for file in configuration.inputs {
            let filePath = (configuration.inputAssets) + "/" + file
            if let d = Utils.fromJSONFile(filePath) {
                result = result! + d
            }
            else {
                exit(-1)
            }
        }
        
        guard let combinedResult = result else {
            Utils.error("Error: missing input file")
            exit(-1)
        }
        
        let writer = WriterFactory.getWriter(with: configuration)
        if (combinedResult["Identifiers"] != nil) {
            writer.writeIds(combinedResult["Identifiers"] as! Dictionary<String, Any>)
        }
    }
}

