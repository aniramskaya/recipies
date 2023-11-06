//
//  RecipeListItem.swift
//  recipies
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public struct RecipeListDTO: Decodable {
    let items: [RecipeListItemDTO]
    
    public init(items: [RecipeListItemDTO]) {
        self.items = items
    }
}

public struct RecipeListItemDTO: Decodable {
    let id: UUID
    let name: String
    let cookingTime: Int
    let imageUrl: URL
    let rating: Float?
    
    public init(id: UUID, name: String, cookingTime: Int, imageUrl: URL, rating: Float?) {
        self.id = id
        self.name = name
        self.cookingTime = cookingTime
        self.imageUrl = imageUrl
        self.rating = rating
    }
}

extension Array where Element == RecipeListItemDTO {
    var models: [RecipeListItem] {
        map { .init(
            id: $0.id,
            name: $0.name,
            cookingTime: Double($0.cookingTime * 60),
            imageUrl: $0.imageUrl,
            rating: $0.rating
        ) }
    }
}
