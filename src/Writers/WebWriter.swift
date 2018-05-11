
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
