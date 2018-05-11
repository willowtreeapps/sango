//
//  WriterFactory.swift
//  Sango
//
//  Created by Adam Shea on 5/7/18.
//  Copyright © 2018 Afero, Inc. All rights reserved.
//

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
