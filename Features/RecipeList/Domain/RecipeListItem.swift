//
//  RecipeListItem.swift
//  recipies
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

struct RecipeListItem: Equatable {
    let id: UUID
    let name: String
    let cookingTime: TimeInterval
    let imageUrl: URL
    let rating: Float?
}
