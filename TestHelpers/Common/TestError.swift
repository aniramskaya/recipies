//
//  TestError.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 05.01.2026.
//

import Foundation

public struct TestError: LocalizedError {
    let reason: String
    
    public init(reason: String) {
        self.reason = reason
    }
    
    public var errorDescription: String? {
        return reason
    }
}
