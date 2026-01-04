//
//  RecipeListRow+DSL.swift
//  recipies
//
//  Created by Марина Чемезова on 04.01.2026.
//

import Testing
import ViewInspector
@testable import RecipieList

extension RecipeListRow {
    func assertIsDisplaying(name: String, rating: String, cookingTime: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let inspectable = try self.inspect()
        
        let nameFound = try inspectable.find(viewWithAccessibilityIdentifier: A11y.name).text().string()
        #expect(nameFound == name, "RecipeListRow name expected to be \(name), found \(nameFound) instead", sourceLocation: sourceLocation)

        #expect(throws: Never.self, "RecipeListRow does not have a rating view with text \(rating)", sourceLocation: sourceLocation) {
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: A11y.rating).find(text: rating)
        }
        
        #expect(throws: Never.self, "RecipeListRow does not have a cookingTime view with text \(cookingTime)", sourceLocation: sourceLocation) {
            let _ = try inspectable.find(viewWithAccessibilityIdentifier: A11y.cookingTime).find(text: cookingTime)
        }
    }
}
