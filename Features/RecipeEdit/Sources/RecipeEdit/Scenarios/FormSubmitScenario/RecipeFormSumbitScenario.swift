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

actor RecipeFormSubmitScenario: Scenario {
    private let stream: CurrentValueStream<State>

    private let getModel: @Sendable () async -> RecipeFormData
    private let save: @Sendable (_: RecipeData) async throws -> Void
    
    init(
        getModel: @escaping @Sendable () async -> RecipeFormData,
        save: @escaping @Sendable (_: RecipeData) async throws -> Void
    ) {
        self.getModel = getModel
        self.save = save
        self.stream = CurrentValueStream(.idle)
    }
    
    // MARK: FormSubmitScenario
    
    typealias State = FormSubmitState

    func statesStream() async -> AsyncStream<FormSubmitState> {
        await stream.makeStream()
    }
    
    func start() async {
        await stream.yield(.validating)
        let model = await getModel()
        switch RecipeData.validate(model) {
        case let .success(data):
            await stream.yield(.saving)
            do {
                try await save(data)
                await stream.yield(.saved)
            } catch {
                await stream.yield(.savingFailed(error))
            }
        case let .failure(error):
            await stream.yield(.validationFailed(error))
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

        var errors: Dictionary<String, LocalizedError> = [:]
        errors["name"] = name == nil ? RecipeFormValidationError.required : nil
        if cookingTime == nil {
            errors["cookingTime"] = RecipeFormValidationError.required
        } else if cookingTimeInt == nil {
            errors["cookingTime"] = RecipeFormValidationError.numberInvalid
        }

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
