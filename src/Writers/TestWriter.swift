import Foundation

class TestWriter: Writer {
    
    var configuration: Configuration
    
    init(configuration:Configuration) {
        self.configuration = configuration
    }
    
    func writeIds(_ identifiers: Dictionary<String, Any>) {
    
        if (configuration.package == nil) {
            Utils.always("Test configuration needs a package specified")
            exit(-1)
        }
        
        if (configuration.identifierFilename == nil) {
            Utils.always("Test configuration needs an Identifier filename specified")
            exit(-1)
        }
        
        Utils.createFolderForFile(configuration.outLocation + configuration.identifierFilename!)
        
        var outputString:String = String()
        var tempString:String = String()
        
        outputString.append("/* Auto-generated. Do not modify */\n")
        outputString.append("package \(configuration.package!);\n\n")
        outputString.append("public final class \(configuration.identifierFilename!) {")

        for (key, value) in Array(identifiers).sorted(by: {$0.0 < $1.0}) {
        let line = writeConstants(key, value:value)
            tempString.append(line)
        }
        
        outputString.append(insertTabPerLine(tempString))
        outputString.append("\n}")
        
        writeToFile(outputString, file: configuration.outLocation + configuration.identifierFilename! + ".java")
    }
    
    func writeConstants(_ name: String, value: Any, level: Int = 0) -> String {
    
        var skipClass = true
        let tabs = ""
        var outputClassString = tabs
        var outputString = ""
        
        if let constantsDictionary = value as? Dictionary<String, Any> {
            for (key, value) in Array(constantsDictionary).sorted(by: {$0.0 < $1.0}) {
                if (reservedWords.contains(key.lowercased())) {
                    Utils.error("Error: Constant '\(name).\(key)' is a reserved word and has to be changed")
                    exit(-1)
                }
                if ((value as AnyObject).className.contains("Dictionary")) {
                    var tabs = ""
                    for _ in 0..<level {
                        tabs.append("\t")
                    }
                    outputClassString.append(writeConstants(key, value: value, level: level + 1))
                    outputClassString.append("\n")
                    skipClass = false
                } else {
                    let strValue = String(describing: value)
                    var lineValue = parseJavaConstant(key, value: value)
                    
                    var tabs = ""
                    for _ in 0..<level {
                        tabs.append("\t")
                    }
                    let line = tabs + "\tpublic static final String" + " " + key.uppercased() + " = \(lineValue);\n"
                    outputClassString.append(line)
                    skipClass = false
                
                }
            }
        }
        
        if (skipClass == false) {
            var tabs = ""
            for _ in 0..<level {
                tabs.append("\t")
            }
            outputString.append(tabs + "public static final class ")
            outputString.append(name + " {\n")
            outputString.append(outputClassString)
            outputString.append(tabs + "}")
            outputString.append("\n\n")
        }

        return outputString
    }
    
    func parseJavaConstant(_ key: String, value: Any) -> String {
        var outputString = ""
        let strValue = String(describing: value)
        
        let line = "\"" + strValue + "\""
        outputString.append(line)
        
        return outputString
    }
}
