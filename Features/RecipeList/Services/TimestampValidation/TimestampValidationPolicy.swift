//
//  TimestampValidationPolicy.swift
//  recipies
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation

public protocol TimestampValidationPolicy {
    func isValid(_ timestamp: Date) -> Bool
}
