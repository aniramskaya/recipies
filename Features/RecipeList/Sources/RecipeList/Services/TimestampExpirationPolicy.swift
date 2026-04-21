//
//  TimestampExpirationPolicy.swift
//  recipies
//
//  Created by Марина Чемезова on 08.04.2026.
//

import Foundation

public protocol TimestampExpirationPolicy: Sendable {
    func isValid(_: Date) -> Bool
}
