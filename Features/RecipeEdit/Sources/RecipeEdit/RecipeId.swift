//
//  RecipeId.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 27.04.2026.
//
import Foundation

public struct RecipeId: Hashable {
    public let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
