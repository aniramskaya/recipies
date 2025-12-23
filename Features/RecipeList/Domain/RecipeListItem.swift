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
    
    public init(id: UUID, name: String, cookingTime: TimeInterval, imageUrl: URL, rating: Float?) {
        self.id = id
        self.name = name
        self.cookingTime = cookingTime
        self.imageUrl = imageUrl
        self.rating = rating
    }
}
