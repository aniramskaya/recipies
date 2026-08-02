//
//  RecipeTitleView+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeTitleView> {
    @MainActor
    func assertIsDisplaying(title: String, sourceLocation: SourceLocation = #_sourceLocation) throws {

        guard let valueFound = try? self.find(viewWithAccessibilityIdentifier: A11y.component).text().string() else {
            throw sourceLocation.error("Recipe title is not displayed")
        }
        guard valueFound == title else {
            throw sourceLocation.error("RecipeTitle is expected to be \(title), found \(valueFound) instead")
        }
    }
}

private typealias A11y = RecipeTitleViewA11y
