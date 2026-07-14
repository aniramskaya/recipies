//
//  IngrediontTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
@testable import RecipeEdit

struct IngredientTests {
    @MainActor
    @Test("Ingredient displays its name")
    func testDisplay() async throws {
        let sut = IngredientView(model: testModel)
        let inspectable = try sut.inspect().find(IngredientView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(name: testModel.name)
        }
    }
    
    @MainActor
    @Test("Ingredient Toggles model on tap")
    func testToggleTap() async throws {
        let sut = IngredientView(model: testModel)

        #expect(testModel.isOn == false)
        try sut.inspect().find(IngredientView.self).toggle().tap()
        #expect(testModel.isOn == true)
    }
}

nonisolated(unsafe) let testModel = IngredientModel(isOn: false, name: "Соль")
