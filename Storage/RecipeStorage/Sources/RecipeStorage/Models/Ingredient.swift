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
class IngredientModel {
    var id: UUID
    var name: String
    var sortOrder: Int
    
    init(id: UUID, name: String, sortOrder: Int) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
    }
}

extension IngredientModel {
    var domain: Ingredient {
        .init(id: id, name: name)
    }
    
    static func from(_ domain: Ingredient, index: Int) -> IngredientModel {
        .init(id: domain.id, name: domain.name, sortOrder: index)
    }
}

