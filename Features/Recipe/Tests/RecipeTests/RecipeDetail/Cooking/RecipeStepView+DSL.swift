//
//  RecipeStepView+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeStepView> {
    @MainActor
    func assertIsDisplaying(model: RecipeStepViewModel, stepNumber: UInt, sourceLocation: SourceLocation = #_sourceLocation) throws {
        guard let stepValue = try? self.find(viewWithAccessibilityIdentifier: RecipeStepHeaderA11y.step).text().string() else {
            throw sourceLocation.error("RecipeStepHeader step number is missing")
        }
        guard stepValue == "\(stepNumber)" else {
            throw sourceLocation.error("RecipeStep expected to be \(stepNumber), found \(stepValue) instead")
        }

        guard let titleValue = try? self.find(viewWithAccessibilityIdentifier: RecipeStepHeaderA11y.title).text().string() else {
            throw sourceLocation.error("RecipeStepHeader title is missing")
        }
        guard titleValue == model.title else {
            throw sourceLocation.error("RecipeTitle expected to be \(model.title), found \(titleValue) instead")
        }

        guard let textValue = try? self.find(viewWithAccessibilityIdentifier: RecipeStepViewA11y.text).text().string() else {
            throw sourceLocation.error("RecipeStep text is missing")
        }
        
        guard textValue == model.text else {
            throw sourceLocation.error("RecipeText expected to be \(model.text), found \(textValue) instead")
        }
        
        let imageView = try? self.find(viewWithAccessibilityIdentifier: RecipeStepViewA11y.image)
        switch (model.imageSource, imageView) {
        case (.some, .none):
            throw sourceLocation.error("RecipeImage expected to be on screen, but not found")
        case (.none, .some):
            throw sourceLocation.error("RecipeImage expected to absent on screen, but is found")
        default:
            break
        }
    }
}
