//
//  TimestampExpirationPolicyStub.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//
import RecipeList
import Foundation

final class TimestampExpirationPolicyStub: TimestampExpirationPolicy {
    var validationResult = false
    
    func isValid(_: Date) -> Bool {
        return validationResult
    }
}
