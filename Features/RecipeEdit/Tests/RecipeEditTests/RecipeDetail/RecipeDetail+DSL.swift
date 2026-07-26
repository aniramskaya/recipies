//
//  RecipeDetail+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeUIKit
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<RecipeDetailView> {
    @MainActor
    func assertIsDisplaying(model: RecipeDetailViewModel, sourceLocation: SourceLocation = #_sourceLocation) throws {
        try assertHeader(model: model, sourceLocation: sourceLocation)
        try assertTitle(model: model, sourceLocation: sourceLocation)
        try assertDescription(model: model, sourceLocation: sourceLocation)
        try assertIngredients(model: model, sourceLocation: sourceLocation)
        try assertTextBlocks(model: model, sourceLocation: sourceLocation)
        try assertCookingSteps(model: model, sourceLocation: sourceLocation)
    }
}

private extension InspectableView where View == ViewType.View<RecipeDetailView> {
    @MainActor
    func assertHeader(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        guard let header = try? self.find(RecipeHeaderView.self) else {
            throw sourceLocation.error("RecipeDetailView does not have a header")
        }
        try header.assertIsDisplaying(
            image: model.imageSource,
            complexity: model.complexity,
            cookingTime: "\(model.cookingTimeMins) min",
            sourceLocation: sourceLocation
        )
    }

    @MainActor
    func assertTitle(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        guard let titleView = try? self.find(RecipeTitleView.self) else {
            throw sourceLocation.error("RecipeDetailView does not have a title view")
        }
        try titleView.assertIsDisplaying(title: model.title, sourceLocation: sourceLocation)
    }

    @MainActor
    func assertDescription(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        if let description = model.description {
            guard let view = try? self.find(RecipeDescriptionView.self) else {
                throw sourceLocation.error("RecipeDetailView does not have a description view")
            }
            try view.assertIsDisplaying(description: description, sourceLocation: sourceLocation)
        } else if (try? self.find(RecipeDescriptionView.self)) != nil {
            throw sourceLocation.error("RecipeDetailView has a description view but model.description is nil")
        }
    }

    @MainActor
    func assertIngredients(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        guard let list = try? self.find(IngredientListView.self) else {
            throw sourceLocation.error("RecipeDetailView does not have an ingredients list")
        }
        try list.assertIsDisplaying(items: model.ingredients.items, sourceLocation: sourceLocation)
    }

    @MainActor
    func assertTextBlocks(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        let found = self.findAll(TextBlockView.self)
        let expected = [model.topText, model.bottomText].compactMap { $0 }

        guard found.count == expected.count else {
            throw sourceLocation.error("RecipeDetailView text blocks count mismatch: expected \(expected.count), found \(found.count)")
        }
        for (index, view) in found.enumerated() {
            try view.assertIsDisplaying(title: expected[index].title, text: expected[index].text, sourceLocation: sourceLocation)
        }
    }

    @MainActor
    func assertCookingSteps(model: RecipeDetailViewModel, sourceLocation: SourceLocation) throws {
        guard let cookingBlock = try? self.find(RecipeCookingBlock.self) else {
            throw sourceLocation.error("RecipeDetailView does not have a cooking block")
        }
        try cookingBlock.assertIsDisplaying(steps: model.steps, sourceLocation: sourceLocation)
    }
}
