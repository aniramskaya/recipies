//
//  RecipeId.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 27.04.2026.
//
import Foundation

public struct RecipeId: Hashable {
    public let id: UUID
    public let isDraft: Bool

    public init(id: UUID, isDraft: Bool = false) {
        self.id = id
        self.isDraft = isDraft
    }
}
