//
//  FormScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation


public struct FormValidationError: Error, Sendable {
    public let form: [LocalizedError]?
    public let field: Dictionary<String, LocalizedError>?
}

public enum FormSubmitState: Sendable {
    case idle
    case validating
    case validationFailed(FormValidationError)
    case saving
    case savingFailed(Error)
    case saved
}
