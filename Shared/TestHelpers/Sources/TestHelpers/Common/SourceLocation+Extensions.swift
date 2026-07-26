//
//  SourceLocation+Extensions.swift
//  TestHelpers
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing

public extension SourceLocation {
    func error(_ message: String) -> TestError {
        TestError(reason: message, sourceLocation: self)
    }
}
