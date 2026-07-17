//
//  RecipeStepViewTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.07.2026.
//

import Testing
import ViewInspector
import RecipeUIKit
@testable import RecipeEdit

struct RecipeStepViewTests {
    @MainActor
    @Test("RecipeStepView full content is displayed")
    func recipeStepViewFullContent() throws {
        let sut = RecipeStepView(model: fullModel)
        let inspectable = try sut.inspect().find(RecipeStepView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(model: fullModel)
        }
    }
    
    @MainActor
    @Test("RecipeStepView compact content is displayed")
    func recipeStepViewCompactContent() throws {
        let sut = RecipeStepView(model: compactModel)
        let inspectable = try sut.inspect().find(RecipeStepView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(model: compactModel)
        }
    }
}

nonisolated(unsafe) private let fullModel = RecipeStepViewModel(
    step: 1,
    title: "Recipe title",
    imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
    text: "Recipe text"
)

nonisolated(unsafe) private let compactModel = RecipeStepViewModel(
    step: 2,
    title: "Recipe title 2",
    imageSource: nil,
    text: "Recipe text 2"
)
