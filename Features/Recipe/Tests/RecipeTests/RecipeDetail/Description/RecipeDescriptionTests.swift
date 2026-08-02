//
//  RecipeDescriptionTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//
import Testing
import ViewInspector
@testable import RecipeEdit

struct RecipeDescriptionTests {
    @MainActor
    @Test("Recipe description displays value")
    func recipeDescriptionDisplay() throws {
        let sut = RecipeDescriptionView(description: "qweasd")
        let inspectable = try sut.inspect().find(RecipeDescriptionView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(description: "qweasd")
        }
    }
}
