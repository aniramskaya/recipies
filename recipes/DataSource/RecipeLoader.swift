//
//  RecipeLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 21.07.2026.
//

import Foundation
import Recipe
import RecipeTypes
import RecipeStorage

actor RecipeRepositoryDraftLoader: RecipeDetailLoader {
    let repository: RecipeRepository
    let id: UUID?
    
    init(_ repository: RecipeRepository, id: UUID?) {
        self.repository = repository
        self.id = id
    }
    
    func load() async throws -> Recipe {
        if let id {
            return try await repository.fetchOne(id: id)
        } else {
            return Recipe(
                id: UUID(),
                title: "",
                description: nil,
                ingredients: [.init(id: UUID(), name: "")],
                topText: nil,
                steps: [.init(id: UUID(), title: nil, imageSource: nil, text: "")],
                bottomText: nil
            )
        }
    }
}

actor RecipeRepositoryLoader: RecipeDetailLoader {
    let repository: RecipeRepository
    let id: UUID
    
    init(_ repository: RecipeRepository, id: UUID) {
        self.repository = repository
        self.id = id
    }
    
    func load() async throws -> Recipe {
        try await repository.fetchOne(id: id)
    }
}

struct RecipeNotFoundError: Error {
    var localizedDescription: String { "Recipe not found" }
}
