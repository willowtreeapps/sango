
import Foundation

class IOSWriter : Writer {

    var configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func writeIds(_ identifiers: Dictionary<String, Any>) {
        
        Utils.createFolderForFile(configuration.outLocation + configuration.identifierFilename!)
        
        var outputString:String = String()
        var tempString:String = String()
        
        outputString.append("/* Auto-generated. Do not modify */\n\n")
        outputString.append("import UIKit\n")
        outputString.append("public struct \(configuration.identifierFilename!) {\n")
        
        for (key, value) in Array(identifiers).sorted(by: {$0.0 < $1.0}) {
            let line = writeConstants(key, value:value)
            tempString.append(line)
        }
        
        outputString.append(insertTabPerLine(tempString))
        outputString.append("\n}")
        
        writeToFile(outputString, file: configuration.outLocation + configuration.identifierFilename! + ".swift")

    }
    
    func writeConstants(_ name: String, value: Any, level: Int = 0) -> String {
            var outputString = ""
            if (reservedWords.contains(name.lowercased())) {
                Utils.error("Error: Class '\(name)' is a reserved word and has to be changed")
                exit(-1)
            }
        
            if let constantsDictionary = value as? Dictionary<String, Any> {
                var tabs = ""
                for _ in 0..<level {
                    tabs.append("\t")
                }
                outputString.append(tabs + "public struct ")
                outputString.append(name + " {\n")
                for (key, value) in Array(constantsDictionary).sorted(by: {$0.0 < $1.0}) {
                    if (reservedWords.contains(key.lowercased())) {
                        Utils.error("Error: Constant '\(name).\(key)' is a reserved word and has to be changed")
                        exit(-1)
                    }
                    
                    var lineValue: String = ""
                    if ((value as AnyObject).className.contains("Dictionary")) {
                        lineValue = writeConstants(key, value: value, level: level + 1)
                    } else {
                        let line = tabs + "\tpublic static let " + key.snakeCaseToCamelCase() + " = "
                        outputString.append(line)
                        lineValue = parseSwiftConstant(key, value: value)
                    }
                    outputString.append(lineValue + "\n");
                }
                outputString.append(tabs + "}\n")
            }
            else if let constantsArray = value as? Array<Any> {
                outputString.append("public static let \(name.lowercasedFirst()) = [\n\t\t")
                let lastItm = constantsArray.count - 1
                for (index, itm) in constantsArray.enumerated() {
                    let lineValue = parseSwiftConstant(String(index), value: itm)
                    outputString.append(lineValue);
                    if (index < lastItm) {
                        outputString.append(",\n\t\t")
                    }
                }
                outputString.append("\n\t]");
            }
        
            return outputString
    }
    
    func parseSwiftConstant(_ key: String, value: Any) -> String {
        var outputString = ""
        let strValue = String(describing: value)
    
        if (value is String) {
            outputString.append("\"\(String(describing: value))\"")
        }
        else {
            outputString.append(strValue);
        }
        
        return outputString
    }

}
