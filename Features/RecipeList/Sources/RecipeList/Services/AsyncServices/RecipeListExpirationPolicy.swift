//
//  RecipeListExpirationPolicy.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

struct RecipeListExpirationPolicy: TimestampExpirationPolicy {
    let timeout: TimeInterval
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func isValid(_ timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) < timeout
    }
}
