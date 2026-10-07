//
//  IngredientListTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//
import Foundation
import Testing
import ViewInspector
@testable import Recipe

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

nonisolated(unsafe) private let testItems: [IngredientModel] = [
    IngredientModel(id: UUID(), name: "Соль", isOn: false),
    IngredientModel(id: UUID(), name: "Вода", isOn: false)
]
