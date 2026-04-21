//
//  waitFor.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//

import Foundation
import Testing

@MainActor
func waitFor(timeout: TimeInterval = 1, checkInterval: TimeInterval = 0.05, sourceLocation: SourceLocation = #_sourceLocation, _ condition: @escaping () throws -> Bool ) async {
    let deadline = Date().addingTimeInterval(timeout)
    var lastError: Error?
    
    while Date() < deadline {
        do {
            if try condition() { return }
            lastError = nil
        } catch {
            lastError = error
        }
        
        try? await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))
    }
    
    if let lastError {
        #expect(Bool(false), "waitFor timed out. Last error \(lastError)", sourceLocation: sourceLocation)
    } else {
        #expect(Bool(false), "waitFor timed out.", sourceLocation: sourceLocation)
    }
}
