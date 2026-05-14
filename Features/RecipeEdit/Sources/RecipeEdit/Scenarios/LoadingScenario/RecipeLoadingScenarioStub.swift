//
//  RecipeLoadingScenarioStub.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation
import Combine

let recipeLoadingScenario = BasicLoadingScenario {
    try? await Task.sleep(for: .seconds(0.5))
    return RecipeData(id: UUID(), name: "Sample recipe", cookingTime: 45, complexity: 3)
}
