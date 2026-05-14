//
//  RecipeFormSumbitScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation

struct RecipeFormData: Sendable {
    let id: UUID
    let name: String?
    let cookingTime: String?
    let complexity: Int?
}

enum RecipeFormValidationError: LocalizedError {
    case required
    case numberInvalid

    var errorDescription: String? {
        switch self {
        case .required:      "Field is required"
        case .numberInvalid: "Cooking time must be a positive number"
        }
    }
}

final class RecipeFormSubmitScenario {
    private let continuation: AsyncStream<FormSubmitState>.Continuation

    private let getModel: @Sendable () -> RecipeFormData
    private let save: @Sendable (_: RecipeData) async throws -> Void
    
    public init(
        getModel: @escaping @Sendable () -> RecipeFormData,
        save: @escaping @Sendable (_: RecipeData) async throws -> Void
    ) {
        self.getModel = getModel
        self.save = save
        (states, continuation) = AsyncStream.makeStream(
            of: FormSubmitState.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        continuation.yield(.idle)
    }
    
    // MARK: FormSubmitScenario
    
    var states: AsyncStream<FormSubmitState>
    
    func start() async {
        continuation.yield(.validating)
        switch RecipeData.validate(getModel()) {
        case let .success(data):
            continuation.yield(.saving)
            do {
                try await save(data)
                continuation.yield(.idle)
            } catch {
                continuation.yield(.savingFailed(error))
            }
        case let .failure(error):
            continuation.yield(.validationFailed(error))
        }
    }
}

extension RecipeData {
    static func validate(_ form: RecipeFormData) -> Result<RecipeData, FormValidationError> {
        let name = form.name.flatMap { $0.isEmpty ? nil : $0 }
        let cookingTime = form.cookingTime.flatMap { $0.isEmpty ? nil : $0 }
        let cookingTimeInt = cookingTime
            .flatMap { Int($0) }
            .flatMap { $0 > 0 ? $0 : nil }

        let errors: [FieldValidationError] = [
            name == nil        ? .init(field: "name", error: RecipeFormValidationError.required)  : nil,
            cookingTime == nil ? .init(field: "cookingTime", error: RecipeFormValidationError.required) : nil,
            cookingTimeInt == nil ? .init(field: "cookingTime", error: RecipeFormValidationError.numberInvalid) : nil
        ].compactMap { $0 }

        guard let name, let cookingTimeInt else {
            return .failure(.init(form: nil, field: errors))
        }

        return .success(RecipeData(
            id: form.id,
            name: name,
            cookingTime: cookingTimeInt,
            complexity: form.complexity ?? 1
        ))
    }
}
