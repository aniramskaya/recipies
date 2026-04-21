//
//  AsyncRecipeListDTOLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

protocol AsyncRecipeListDTOLoader: Sendable {
    func load() async throws -> RecipeListDTO
}
