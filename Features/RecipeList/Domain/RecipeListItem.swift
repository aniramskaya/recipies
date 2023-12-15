//
//  RecipeListItem.swift
//  RecipieList
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation

public struct RecipeListItem: Equatable {
    public let id: UUID
    public let name: String
    public let cookingTime: TimeInterval
    public let imageUrl: URL
    public let rating: Float?
}
