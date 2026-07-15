//
//  IngredientList+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<IngredientListView> {
    @MainActor
    func assertIsDisplaying(items: [IngredientModel]) throws {

        let foundItems = self.findAll(IngredientView.self)
        #expect(foundItems.count == items.count)
        for (index, _) in foundItems.enumerated() {
            try foundItems[index].assertIsDisplaying(name: items[index].name)
        }
    }
}
