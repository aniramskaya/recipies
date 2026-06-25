//
//  TimeoutTTLPolicy.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//
import Foundation

public struct TimeoutTTLPolicy: TTLPolicy {
    private let timeout: TimeInterval
    
    public init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    public func isValid(savedAt: Date) -> Bool {
        return Date().timeIntervalSince(savedAt) < timeout
    }
}
