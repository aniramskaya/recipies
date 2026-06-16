//
//  TimeoutTTLPolicy.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//
import Foundation

struct TimeoutTTLPolicy {
    let timeout: TimeInterval
    
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func isValid(_ date: Date) -> Bool {
        return Date().timeIntervalSince(date) < timeout
    }
}
