//
//  Configuration.swift
//  Sango
//
//  Created by Adam Shea on 5/7/18.
//  Copyright © 2018 Afero, Inc. All rights reserved.
//

import Foundation

public struct Configuration {
    
    var inputAssets: String
    var inputs: [String]
    var platform: Platform
    var identifierFilename: String?
    var outLocation: String
    var package: String?
    
    init(inputAssets: String, inputs: [String], platform: Platform,
         identifierFilename: String?, outLocation: String, package: String?) {
        self.inputAssets = inputAssets
        self.inputs = inputs
        self.platform = platform
        self.identifierFilename = identifierFilename
        self.outLocation = outLocation
        self.package = package
    }

    public static func fromConfigFile(text:[String:Any]) -> Configuration {
        guard let inputAssets = text["input_assets"] as? String else {
            Utils.error("Error: missing input assets")
            exit(-1)
        }
        guard let inputFiles = text["inputs"] as? [String] else {
            Utils.error("Error: missing input files")
            exit(-1)
        }
        guard let outLocation = text["out_location"] as? String else {
            Utils.error("Error: missing out location")
            exit(-1)
        }
        let identifierFilename = text["out_identifier_name"] as? String
        let platform = getPlatformFromString(text["platform"] as? String)
        let package = text["package"] as? String
    
        return Configuration(inputAssets: inputAssets, inputs: inputFiles,
                             platform: platform, identifierFilename: identifierFilename,
                             outLocation: outLocation, package: package)
    }
    
    static func getPlatformFromString(_ platformString: String?) -> Platform {
        
        guard let platformString = platformString else {
            Utils.error("Error: Need to specify a platform in configuration file")
            exit(-1)
        }
        switch platformString.description.lowercased() {
        case "android":
            return Platform.android
        case "ios":
            return Platform.ios
        case "web":
            return Platform.web
        case "test":
            return Platform.test
        default:
            Utils.error("Error: No platform found for \(platformString.description.lowercased())")
            exit(-1)
        }
    }
}
