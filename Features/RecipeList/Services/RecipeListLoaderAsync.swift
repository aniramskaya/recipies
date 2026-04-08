//
//  RecipeListLoaderAsync.swift
//  recipies
//
//  Created by Марина Чемезова on 06.04.2026.
//

protocol RecipeListLoaderAsync {
    func load() async throws -> [RecipeListItem]
}
