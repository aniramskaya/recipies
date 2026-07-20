//
//  TestError.swift
//  RecipeListTests
//
//  Created by Марина Чемезова on 05.01.2026.
//

import Testing
import Foundation

public struct TestError: LocalizedError {
    let reason: String
    let sourceLocation: SourceLocation?
    
    public init(reason: String, sourceLocation: SourceLocation? = nil) {
        self.reason = reason
        self.sourceLocation = sourceLocation
    }
    
    public var errorDescription: String? {
        return reason
    }
}
