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
    func assertIsDisplaying(title: String) throws {

        let valueFound = try self.find(viewWithAccessibilityIdentifier: A11y.component).text().string()
        guard valueFound == title else {
            throw TestError(reason: "RecipeTitle is expected to be \(title), found \(valueFound) instead")
        }
    }
}

private typealias A11y = RecipeTitleViewA11y
