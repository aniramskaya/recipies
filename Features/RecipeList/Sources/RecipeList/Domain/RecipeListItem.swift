//
//  RecipeListItem.swift
//  recipes
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public struct RecipeListItem: Equatable, Sendable {
    let id: UUID
    let name: String
    let cookingTimeMins: Int
    let imageUrl: URL
    let rating: Float?
    let complexity: Int

    public init(id: UUID, name: String, cookingTimeMins: Int, imageUrl: URL, rating: Float?, complexity: Int) {
        self.id = id
        self.name = name
        self.cookingTimeMins = cookingTimeMins
        self.imageUrl = imageUrl
        self.rating = rating
        self.complexity = complexity
    }
}
