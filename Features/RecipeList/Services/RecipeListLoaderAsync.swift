//
//  RecipeListLoaderAsync.swift
//  recipies
//
//  Created by Марина Чемезова on 06.04.2026.
//

protocol RecipeListLoaderAsync: Sendable {
    func load() async throws -> [RecipeListItem]
}
