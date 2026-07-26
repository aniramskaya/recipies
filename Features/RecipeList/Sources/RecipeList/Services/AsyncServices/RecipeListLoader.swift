//
//  RecipeListLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

public protocol RecipeListLoader: Sendable {
    func load() async throws -> [RecipeListItem]
}
