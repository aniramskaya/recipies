//
//  RecipeDescription+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<RecipeDescriptionView> {
    @MainActor
    func assertIsDisplaying(description: String, sourceLocation: SourceLocation = #_sourceLocation) throws {

        guard let valueFound = try? self.find(viewWithAccessibilityIdentifier: A11y.description).text().string() else {
            throw sourceLocation.error("RecipeDescription is not on the screen")
        }
        guard valueFound == description else {
            throw sourceLocation.error("RecipeDescription expected to be \(description), found \(valueFound) instead")
        }
    }
}

private typealias A11y = RecipeDescriptionViewA11y
