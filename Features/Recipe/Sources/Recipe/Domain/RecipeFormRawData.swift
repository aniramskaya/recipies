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

        var errors: Dictionary<String, String> = [:]
        errors["name"] = name == nil ? "Поле обязательно" : nil

        guard let name else {
            return .failure(.init(form: nil, field: errors))
        }

        return .success(RecipeData(
            id: self.id,
            title: name,
            description: "",
            ingredients: [],
            topTextBlock: nil,
            steps: [],
            bottomTextBlock: nil
        ))
    }
}
