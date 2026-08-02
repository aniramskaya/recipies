//
//  RecipeDetailViewModel.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.07.2026.
//

import RecipeUIKit

struct RecipeDetailViewModel {
    let imageSource: RecipeImageSource
    let cookingTimeMins: Int
    let complexity: Int
    let title: String
    let description: String?
    let ingredients: IngredientListModel
    let topText: TextBlockViewModel?
    let steps: [RecipeStepViewModel]
    let bottomText: TextBlockViewModel?

    let onShare: () -> Void
}
