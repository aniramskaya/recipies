//
//  IngredientDraft.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//
import Foundation

struct IngredientDraft: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
