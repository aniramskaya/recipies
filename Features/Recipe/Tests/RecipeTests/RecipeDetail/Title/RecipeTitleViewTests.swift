//
//  RecipeTitleViewTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
@testable import Recipe

struct RecipeTitleViewTests {
    @MainActor
    @Test("Recipe title displays value")
    func recipeTitlDisplay() throws {
        let sut = RecipeTitleView(title: "Recipe title")
        let inspectable = try sut.inspect().find(RecipeTitleView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(title: "Recipe title")
        }
    }
}
