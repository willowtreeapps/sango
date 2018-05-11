//
//  Configuration.swift
//  Sango
//
//  Created by Adam Shea on 5/7/18.
//  Copyright © 2018 Afero, Inc. All rights reserved.
//

import Foundation

public struct Configuration {
    
    var inputAssets:String
    var inputs:[String]
    var platform:Platform
    var identifierFilename:String?
    var outLocation:String
    var package:String?
    
    init(inputAssets:String, inputs:[String], platform:Platform,
         identifierFilename:String?, outLocation:String, package:String?) {
        self.inputAssets = inputAssets
        self.inputs = inputs
        self.platform = platform
        self.identifierFilename = identifierFilename
        self.outLocation = outLocation
        self.package = package
    }

    public static func fromConfigFile(text:[String:Any]) -> Configuration {
        let inputAssets = text["input_assets"] as? String
        let inputFiles = text["inputs"] as? [String]
        let identifierFilename = text["out_identifier_name"] as? String
        let outLocation = text["out_location"] as? String
        let platform = getPlatformFromString(platformString: text["platform"] as? String)
        let package = text["package"] as? String
        
        if (outLocation == nil) {
            Utils.error("Error: missing out location")
            exit(-1)
        }
        
        if (inputAssets == nil) {
            Utils.error("Error: missing input assets")
            exit(-1)
        }
        
        if (inputFiles == nil) {
            Utils.error("Error: missing input files")
            exit(-1)
        }
    
        return Configuration(inputAssets: inputAssets!, inputs: inputFiles!,
                             platform: platform, identifierFilename: identifierFilename,
                             outLocation: outLocation!, package: package)
    }
    
    static func getPlatformFromString(platformString: String?) -> Platform {
        if (platformString != nil) {
            switch platformString?.description.lowercased() {
            case "android":
                return Platform.android
            case "ios":
                return Platform.ios
            case "web":
                return Platform.web
            case "test":
                return Platform.test
            default:
                Utils.error("Error: invalid platform \(platformString)")
                exit(-1)
            }
        } else {
            Utils.error("Error: Need to specify a platform in configuration file")
            exit(-1)
        }
    }
}
