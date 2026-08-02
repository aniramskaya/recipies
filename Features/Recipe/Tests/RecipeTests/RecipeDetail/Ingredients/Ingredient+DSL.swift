//
//  Ingredient+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<IngredientView> {
    @MainActor
    func assertIsDisplaying(name: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let nameFound = try? self.toggle().find(ViewType.Text.self).string() else {
            throw sourceLocation.error("Ingredient name component is missing on the screen")
        }
        guard nameFound == name else {
            throw sourceLocation.error("Ingredient name expected to be \(name), found \(nameFound) instead")
        }
    }
}
