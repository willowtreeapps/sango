import Foundation

public class WriterFactory {
    
    public static func getWriter(with configuration: Configuration) -> Writer {
        switch configuration.platform {
        case .android:
                return AndroidWriter(configuration: configuration)
        case .ios:
                return IOSWriter(configuration: configuration)
        case .web:
                return WebWriter(configuration: configuration)
        case .test:
                return TestWriter(configuration: configuration)
        }
    }
}
