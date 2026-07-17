//
//  RecipeCookingBlock+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeCookingBlock> {
    @MainActor
    func assertIsDisplaying(steps: [RecipeStepViewModel]) throws {
        let found = self.findAll(RecipeStepView.self)
        
        #expect(found.count == steps.count)
        for (index, _) in found.enumerated() {
            #expect(throws: Never.self) {
                try found[index].assertIsDisplaying(model: steps[index])
            }
        }
    }
}
