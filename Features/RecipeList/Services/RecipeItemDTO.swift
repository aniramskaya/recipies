//
//  RecipeListItem.swift
//  recipies
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

struct RecipeListDTO: Decodable {
    let items: [RecipeListItemDTO]
}

struct RecipeListItemDTO: Decodable {
    let id: UUID
    let name: String
    let cookingTime: Int
    let imageUrl: URL
    let rating: Float?
}
