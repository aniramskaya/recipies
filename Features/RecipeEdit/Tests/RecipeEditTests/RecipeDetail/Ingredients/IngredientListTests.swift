//
//  IngredientListTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//
import Testing
import ViewInspector
@testable import RecipeEdit

struct IngredientListTests {
    
    @MainActor
    @Test("Ingredient list is displaying items")
    func listIsDisplayingItems() throws {
        let sut = IngredientListView(model: .init(items: testItems))
        let inspectable = try sut.inspect().find(IngredientListView.self)

        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(items: testItems)
        }
    }
}

nonisolated(unsafe) let testItems: [IngredientModel] = [
    IngredientModel(isOn: false, name: "Соль"),
    IngredientModel(isOn: false, name: "Вода")
]
