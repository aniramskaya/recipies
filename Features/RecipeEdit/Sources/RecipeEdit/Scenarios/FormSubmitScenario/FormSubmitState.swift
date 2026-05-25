//
//  FormScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation


public struct FormValidationError: Error, Sendable {
    public let form: [String]?
    public let field: Dictionary<String, String>?
}

public enum FormSubmitState: Sendable {
    case idle
    case validating
    case validationFailed(FormValidationError)
    case saving
    case savingFailed(Error)
    case saved
}
