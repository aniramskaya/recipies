//
//  Ingredient+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<IngredientView> {
    @MainActor
    func assertIsDisplaying(name: String) throws {

        let nameFound = try self.toggle().find(ViewType.Text.self).string()
        guard nameFound == name else {
            throw TestError(reason: "Ingredient name expected to be \(name), found \(nameFound) instead")
        }
    }
}
