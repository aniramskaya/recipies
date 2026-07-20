//
//  RecipeListRow+DSL.swift
//  recipes
//
//  Created by Марина Чемезова on 04.01.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeUIKit
@testable import RecipeList

extension RecipeListRow {
    func assertIsDisplaying(name: String, complexity: Int, cookingTime: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let inspectable = try self.inspect()

        let nameFound = try inspectable.find(viewWithAccessibilityIdentifier: A11y.name).text().string()
        #expect(nameFound == name, "RecipeListRow name expected to be \(name), found \(nameFound) instead", sourceLocation: sourceLocation)

        #expect(throws: Never.self, "RecipeListRow does not have a complexity view with value \(complexity)", sourceLocation: sourceLocation) {
            let found = try inspectable.find(RecipeComplexityView.self).actualView()
            #expect(found.value == complexity, "RecipeComplexityView expected value \(complexity), found \(found.value) instead", sourceLocation: sourceLocation)
        }

        #expect(throws: Never.self, "RecipeListRow does not have a cookingTime view with text \(cookingTime)", sourceLocation: sourceLocation) {
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: A11y.cookingTime).find(text: cookingTime)
        }
    }
}

extension InspectableView where View == ViewType.View<RecipeListRow> {
    @MainActor
    func assertIsDisplaying(name: String, complexity: Int, cookingTime: String) throws {

        let nameFound = try self.find(viewWithAccessibilityIdentifier: A11y.name).text().string()
        guard nameFound == name else {
            throw TestError(reason: "RecipeListRow name expected to be \(name), found \(nameFound) instead")
        }

        do {
            let found = try self.find(RecipeComplexityView.self).actualView()
            guard found.value == complexity else {
                throw TestError(reason: "RecipeComplexityView expected value \(complexity), found \(found.value) instead")
            }
        } catch {
            throw TestError(reason: "RecipeListRow does not have a complexity view with value \(complexity)")
        }

        do {
            let _ = try self.find(viewWithAccessibilityIdentifier: A11y.cookingTime).find(text: cookingTime)
        } catch {
            throw TestError(reason: "RecipeListRow does not have a cookingTime view with text \(cookingTime)")
        }
    }
}
