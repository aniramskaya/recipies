//
//  RecipeFormSumbitScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation

enum RecipeFormValidationError: LocalizedError {
    case required
    case numberInvalid

    var errorDescription: String? {
        switch self {
        case .required:      "Поле обязательно"
        case .numberInvalid: "Введите корректное число"
        }
    }
}

public final class RecipeFormSubmitScenario: Sendable {

    private let getModel: @Sendable () async -> RecipeFormData
    private let save: @Sendable (_: RecipeData) async throws -> Void
    
    init(
        getModel: @escaping @Sendable () async -> RecipeFormData,
        save: @escaping @Sendable (_: RecipeData) async throws -> Void
    ) {
        self.getModel = getModel
        self.save = save
    }
    
    // MARK: FormSubmitScenario
        
    func start() -> AsyncStream<FormSubmitState> {
        let (stream, continuation) = AsyncStream.makeStream(
            of: FormSubmitState.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let task = Task {
            continuation.yield(.validating)
            guard !Task.isCancelled else { continuation.finish(); return }
            let model = await getModel()
            guard !Task.isCancelled else { continuation.finish(); return }
            switch RecipeData.validate(model) {
            case let .success(data):
                continuation.yield(.saving)
                guard !Task.isCancelled else { continuation.finish(); return }
                do {
                    try await save(data)
                    guard !Task.isCancelled else { continuation.finish(); return }
                    continuation.yield(.saved)
                    continuation.finish()
                } catch {
                    guard !Task.isCancelled else { continuation.finish(); return }
                    continuation.yield(.savingFailed(error))
                    continuation.finish()
                }
            case let .failure(error):
                continuation.yield(.validationFailed(error))
                continuation.finish()
            }
        }
        continuation.onTermination = { _ in task.cancel() }
        return stream
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
