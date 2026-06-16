//
//  TTLPolicy.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import Foundation

public protocol TTLPolicy: Sendable {
    func isValid(savedAt: Date) -> Bool
}
