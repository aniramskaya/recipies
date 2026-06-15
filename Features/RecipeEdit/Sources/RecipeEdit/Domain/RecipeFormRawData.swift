//
//  RecipeFormData.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.05.2026.
//

import Foundation
import Scenarios

struct RecipeFormRawData: Sendable {
    let id: UUID
    let name: String
    let cookingTime: String
    let complexity: Int
}

extension RecipeFormRawData {
    func validateAndMapToData() -> Result<RecipeData, FormValidationError> {
        let name = self.name.isEmpty ? nil : self.name
        let cookingTime = self.cookingTime.isEmpty ? nil : self.cookingTime
        let cookingTimeInt = cookingTime
            .flatMap { Int($0) }
            .flatMap { $0 > 0 ? $0 : nil }

        var errors: Dictionary<String, String> = [:]
        errors["name"] = name == nil ? RecipeFormValidationError.required.description : nil
        if cookingTime == nil {
            errors["cookingTime"] = RecipeFormValidationError.required.description
        } else if cookingTimeInt == nil {
            errors["cookingTime"] = RecipeFormValidationError.numberInvalid.description
        }

        guard let name, let cookingTimeInt else {
            return .failure(.init(form: nil, field: errors))
        }

        return .success(RecipeData(
            id: self.id,
            name: name,
            cookingTime: cookingTimeInt,
            complexity: self.complexity
        ))
    }
}

private enum RecipeFormValidationError: Error {
    case required
    case numberInvalid

    var description: String? {
        switch self {
        case .required:      "Поле обязательно"
        case .numberInvalid: "Введите корректное число"
        }
    }
}
