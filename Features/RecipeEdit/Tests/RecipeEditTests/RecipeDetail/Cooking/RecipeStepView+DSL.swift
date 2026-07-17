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
    func assertIsDisplaying(model: RecipeStepViewModel) throws {
        let stepValue = try self.find(viewWithAccessibilityIdentifier: RecipeStepHeaderA11y.step).text().string()
        guard stepValue == "\(model.step)" else {
            throw TestError(reason: "RecipeStep expected to be \(model.step), found \(stepValue) instead")
        }

        let titleValue = try self.find(viewWithAccessibilityIdentifier: RecipeStepHeaderA11y.title).text().string()
        guard titleValue == model.title else {
            throw TestError(reason: "RecipeTitle expected to be \(model.title), found \(titleValue) instead")
        }

        let textValue = try self.find(viewWithAccessibilityIdentifier: RecipeStepViewA11y.text).text().string()
        guard textValue == model.text else {
            throw TestError(reason: "RecipeText expected to be \(model.text), found \(textValue) instead")
        }
        
        let imageView = try? self.find(viewWithAccessibilityIdentifier: RecipeStepViewA11y.image)
        switch (model.imageSource, imageView) {
        case (.some, .none):
            throw TestError(reason: "RecipeImage expected to be on screen, but not found")
        case (.none, .some):
            throw TestError(reason: "RecipeImage expected to absent on screen, but is found")
        default:
            break
        }
    }
}
