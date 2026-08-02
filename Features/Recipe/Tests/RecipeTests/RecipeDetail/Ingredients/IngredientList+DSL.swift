//
//  IngredientList+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<IngredientListView> {
    @MainActor
    func assertIsDisplaying(items: [IngredientModel], sourceLocation: SourceLocation = #_sourceLocation) throws {

        let foundItems = self.findAll(IngredientView.self)
        guard foundItems.count == items.count else {
            throw sourceLocation.error("Ingredients count mismatch. Expected \(items.count), found \(foundItems.count)")
        }
        for (index, _) in foundItems.enumerated() {
            try foundItems[index].assertIsDisplaying(name: items[index].name, sourceLocation: sourceLocation)
        }
    }
}
