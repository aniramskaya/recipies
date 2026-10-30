//
//  Recipe.swift
//  RecipeStorage
//
//  Created by Марина Чемезова on 07.10.2026.
//
import Foundation
import SwiftData
import RecipeTypes

@Model
class RecipeModel {
    var id: UUID
    var imageSource: URL?
    var cookingTimeMins: Int
    var complexity: Int
    var title: String
    var text: String?
    @Relationship(deleteRule: .cascade) var ingredients: [IngredientModel]
    var topBlockTitle: String?
    var topBlockText: String?
    @Relationship(deleteRule: .cascade) var steps: [RecipeStepModel]
    var bottomBlockTitle: String?
    var bottomBlockText: String?
    var updatedAt: Date
    var isDraft: Bool

    init(id: UUID, imageSource: URL? = nil, cookingTimeMins: Int, complexity: Int, title: String, text: String? = nil, ingredients: [IngredientModel], topBlockTitle: String? = nil, topBlockText: String? = nil, steps: [RecipeStepModel], bottomBlockTitle: String? = nil, bottomBlockText: String? = nil, updatedAt: Date = .init(), isDraft: Bool = false) {
        self.id = id
        self.imageSource = imageSource
        self.cookingTimeMins = cookingTimeMins
        self.complexity = complexity
        self.title = title
        self.text = text
        self.ingredients = ingredients
        self.topBlockTitle = topBlockTitle
        self.topBlockText = topBlockText
        self.steps = steps
        self.bottomBlockTitle = bottomBlockTitle
        self.bottomBlockText = bottomBlockText
        self.updatedAt = updatedAt
        self.isDraft = isDraft
    }
}

extension RecipeModel {
    var domain: Recipe {
        var topTextBlock: TextBlock?
        var bottomTextBlock: TextBlock?
        
        if let topText = topBlockText {
            topTextBlock = .init(text: topText, title: topBlockTitle)
        }
        if let bottomText = bottomBlockText {
            bottomTextBlock = .init(text: bottomText, title: bottomBlockTitle)
        }
        
        return .init(
            id: id,
            imageSource: imageSource,
            cookingTimeMins: cookingTimeMins,
            complexity: complexity,
            title: title,
            description: text,
            ingredients: ingredients.sorted { $0.sortOrder < $1.sortOrder }.map { $0.domain },
            topText: topTextBlock,
            steps: steps.sorted { $0.sortOrder < $1.sortOrder }.map { $0.domain },
            bottomText: bottomTextBlock,
            isDraft: isDraft
        )
    }

    func update(with recipe: Recipe) {
        title = recipe.title
        imageSource = recipe.imageSource
        cookingTimeMins = recipe.cookingTimeMins
        complexity = recipe.complexity
        text = recipe.description
        ingredients = recipe.ingredients.orderedModel
        topBlockTitle = recipe.topText?.title
        topBlockText = recipe.topText?.text
        bottomBlockTitle = recipe.bottomText?.title
        bottomBlockText = recipe.bottomText?.text
        steps = recipe.steps.orderedModel
        isDraft = recipe.isDraft
        updatedAt = Date()
    }

    static func from(_ domain: Recipe) -> RecipeModel {
        .init(
            id: domain.id,
            imageSource: domain.imageSource,
            cookingTimeMins: domain.cookingTimeMins,
            complexity: domain.complexity,
            title: domain.title,
            text: domain.description,
            ingredients: domain.ingredients.orderedModel,
            topBlockTitle: domain.topText?.title,
            topBlockText: domain.topText?.text,
            steps: domain.steps.orderedModel,
            bottomBlockTitle: domain.bottomText?.title,
            bottomBlockText: domain.bottomText?.text,
            isDraft: domain.isDraft
        )
    }
}

private extension Array where Element == Ingredient {
    var orderedModel: [IngredientModel] {
        var result: [IngredientModel] = []
        for (index, item) in enumerated() {
            let model = IngredientModel.from(item, index: index)
            result.append(model)
        }
        return result
    }
}

private extension Array where Element == RecipeStep {
    var orderedModel: [RecipeStepModel] {
        var result: [RecipeStepModel] = []
        for (index, item) in enumerated() {
            let model = RecipeStepModel.from(item, index: index)
            result.append(model)
        }
        return result
    }
}
