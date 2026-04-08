//
//  TimestampExpirationPolicy.swift
//  recipies
//
//  Created by Марина Чемезова on 08.04.2026.
//

public protocol TimestampExpirationPolicy: Sendable {
    func isValid(_: Date) -> Bool
}
