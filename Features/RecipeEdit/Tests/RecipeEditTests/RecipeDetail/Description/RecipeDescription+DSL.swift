//
//  RecipeDescription+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeDescriptionView> {
    @MainActor
    func assertIsDisplaying(description: String) throws {

        let valueFound = try self.find(viewWithAccessibilityIdentifier: A11y.description).text().string()
        guard valueFound == description else {
            throw TestError(reason: "RecipeDescription expected to be \(description), found \(valueFound) instead")
        }
    }
}

private typealias A11y = RecipeDescriptionViewA11y
