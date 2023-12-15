//
//  TimeoutPolicy.swift
//  recipies
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation

public struct TimeoutPolicy: TimestampValidationPolicy {
    private let timeout: TimeInterval
    
    public init(_ timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    public func isValid(_ timestamp: Date) -> Bool {
        timestamp.addingTimeInterval(timeout) > Date()
    }
}
