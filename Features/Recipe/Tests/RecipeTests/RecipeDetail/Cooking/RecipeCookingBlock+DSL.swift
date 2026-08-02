//
//  RecipeCookingBlock+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<RecipeCookingBlock> {
    @MainActor
    func assertIsDisplaying(steps: [RecipeStepViewModel], sourceLocation: SourceLocation = #_sourceLocation) throws {
        let found = self.findAll(RecipeStepView.self)
        
        guard found.count == steps.count else {
            throw sourceLocation.error("Invalid number of cooking steps. Expected: \(steps.count), found \(found.count).")
        }
        
        for (index, _) in found.enumerated() {
            try found[index].assertIsDisplaying(model: steps[index], stepNumber: UInt(index + 1), sourceLocation: sourceLocation)
        }
    }
}
