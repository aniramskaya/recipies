//
//  RecipeFormData.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 20.05.2026.
//

import Foundation

struct RecipeFormData: Sendable {
    let id: UUID
    let name: String?
    let cookingTime: String?
    let complexity: Int?
}
