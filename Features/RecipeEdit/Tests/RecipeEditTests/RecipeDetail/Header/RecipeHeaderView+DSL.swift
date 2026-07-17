//
//  RecipeHeaderView+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeUIKit
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeHeaderView> {
    @MainActor
    func assertIsDisplaying(image: RecipeImageSource, complexity: Int, cookingTime: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        
        #expect(throws: Never.self, "RecipeHeaderView does not have an image", sourceLocation: sourceLocation) {
            let found = try self.find(RecipeImageView.self).actualView()
            #expect(found.source == image, "RecipeHeaderView image mismatch", sourceLocation: sourceLocation)
        }

        #expect(throws: Never.self, "RecipeHeaderView does not have a complexity view with value \(complexity)", sourceLocation: sourceLocation) {
            
            let found = try self.find(RecipeComplexityView.self).actualView()
            #expect(found.value == complexity, "RecipeComplexityView expected value \(complexity), found \(found.value) instead", sourceLocation: sourceLocation)
        }

        #expect(throws: Never.self, "RecipeHeaderView does not have a cookingTime view with text \(cookingTime)", sourceLocation: sourceLocation) {
            let _ = try self.find(viewWithAccessibilityIdentifier: RecipeHeaderViewA11y.cookingTime).find(text: cookingTime)
        }
    }
}
