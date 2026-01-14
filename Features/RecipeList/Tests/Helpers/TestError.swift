//
//  TestError.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 05.01.2026.
//

import Foundation

struct TestError: LocalizedError {
    let reason: String
    
    init(reason: String) {
        self.reason = reason
    }
    
    var errorDescription: String? {
        return reason
    }
}
