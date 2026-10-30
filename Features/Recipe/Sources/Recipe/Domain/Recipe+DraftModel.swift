//
//  Recipe+DraftModel.swift
//  Recipe
//
//  Created by Марина Чемезова on 25.10.2026.
//
import RecipeTypes

extension Recipe {
    @MainActor
    func asDraftModel() -> RecipeDraftModel {
        RecipeDraftModel(
            id: id,
            imageSource: imageSource,
            cookingTimeMins: cookingTimeMins,
            complexity: complexity,
            title: title,
            description: description ?? "",
            ingredients: ingredients.map { IngredientDraftModel(id: $0.id, name: $0.name) },
            topTextBlock: topText.map { .init(title: $0.title ?? "", text: $0.text) },
            steps: steps.map { RecipeStepDraftModel(id: $0.id, title: $0.title ?? "", imageSource: $0.imageSource, text: $0.text) },
            bottomTextBlock: bottomText.map { .init(title: $0.title ?? "", text: $0.text) }
        )
    }
}
