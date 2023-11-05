//
//  RecipeListItem.swift
//  recipies
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public struct RecipeListItem: Equatable {
    let id: UUID
    let name: String
    let cookingTime: TimeInterval
    let imageUrl: URL
    let rating: Float?
    
    public init(id: UUID, name: String, cookingTime: TimeInterval, imageUrl: URL, rating: Float?) {
        self.id = id
        self.name = name
        self.cookingTime = cookingTime
        self.imageUrl = imageUrl
        self.rating = rating
    }
}
