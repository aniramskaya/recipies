//
//  RecipeHeaderViewTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import RecipeUIKit
@testable import RecipeEdit

struct RecipeHeaderViewTests {
    
    @MainActor
    @Test("RecipeHeader is displaying model correctly")
    func recipeHeaderDisplaysModelCorrectly() throws {
        let sut = RecipeHeaderView(
            imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
            cookingTimeMins: 45,
            complexity: 4
        )
        let inspectable = try sut.inspect().find(RecipeHeaderView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(
                image: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
                complexity: 4,
                cookingTime: "45 min"
            )
        }
    }
}

