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
@testable import Recipe

extension InspectableView where View == ViewType.View<RecipeHeaderView> {
    @MainActor
    func assertIsDisplaying(image: RecipeImageSource, complexity: Int, cookingTime: String, sourceLocation: SourceLocation = #_sourceLocation) throws {

        guard let found = try? self.find(RecipeImageView.self).actualView() else {
            throw sourceLocation.error("RecipeHeaderView does not have an image")
        }
        guard found.source == image else {
            throw sourceLocation.error("RecipeHeaderView image mismatch")
        }


        guard let found = try? self.find(RecipeComplexityView.self).actualView() else {
            throw sourceLocation.error("RecipeHeaderView does not have a complexity view with value \(complexity)")
        }
        guard found.value == complexity else {
            throw sourceLocation.error("RecipeComplexityView expected value \(complexity), found \(found.value) instead")
        }
        
        guard let _ = try? self.find(viewWithAccessibilityIdentifier: RecipeHeaderViewA11y.cookingTime).find(text: cookingTime) else {
            throw sourceLocation.error("RecipeHeaderView does not have a cookingTime view with text \(cookingTime)")
        }
    }
}
