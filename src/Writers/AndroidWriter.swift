import Foundation

class AndroidWriter: Writer {
 
    var configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func writeIds(_ identifiers: Dictionary<String, Any>) {
        Utils.createFolderForFile(configuration.outLocation + configuration.identifierFilename!)
        
        var outputString:String = String()
        
        outputString.append("<!--  Auto-generated. Do not modify  -->\n\n")
        outputString.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        outputString.append("<resources>\n")
        
        for (key, value) in Array(identifiers).sorted(by: {$0.0 < $1.0}) {
            let line = writeConstants(key, value:value, level: 0)
            outputString.append(line)
        }
        
        outputString.append("</resources>")

        writeToFile(outputString, file: configuration.outLocation + configuration.identifierFilename! + ".xml")
    }
    
    func writeConstants(_ name: String, value: Any, level: Int) -> String {
        var outputString = String()

        if let constantsDictionary = value as? Dictionary<String, Any> {
            for (key, value) in Array(constantsDictionary).sorted(by: {$0.0 < $1.0}) {
                if (reservedWords.contains(key.lowercased())) {
                    Utils.error("Error: Constant '\(name).\(key)' is a reserved word and has to be changed")
                    exit(-1)
                }
                if ((value as AnyObject).className.contains("Dictionary")) {
                    outputString.append(writeConstants(key, value: value, level: level))
                } else {
                    outputString.append("\t <item name=\(value) type=\"id\"/>\n")
                }
            }
        }
        return outputString
    }
}
