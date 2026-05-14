//
//  FormScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation

public struct FieldValidationError: Error, Sendable {
    public let field: String
    public let error: LocalizedError
}

public struct FormValidationError: Error, Sendable {
    public let form: [LocalizedError]?
    public let field: [FieldValidationError]?
}

public enum FormSubmitState {
    case idle
    case validating
    case validationFailed(FormValidationError)
    case saving
    case savingFailed(Error)
}

public protocol FormSubmitScenario: Scenario {

    // Sequence of LoadingScenarioState emitted by scenario
    var states: AsyncStream<FormSubmitState> { get }
    
    // Starts form submit scenario
    func start() async -> Void
}
