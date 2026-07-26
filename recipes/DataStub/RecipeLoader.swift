//
//  RecipeLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 21.07.2026.
//

import Foundation
import RecipeEdit

actor RecipeLoader: RecipeDetailLoader {
    let id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
    func load() async throws -> Recipe {
        try await withCheckedThrowingContinuation({ continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard let result = sampleRecipes.first(where: { $0.id == self.id }) else {
                    continuation.resume(throwing: RecipeNotFoundError())
                    return
                }
                continuation.resume(returning: result)
            }
        })
    }
}

struct RecipeNotFoundError: Error {
    var localizedDescription: String { "Recipe not found" }
}
