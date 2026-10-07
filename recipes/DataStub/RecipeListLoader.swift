//
//  RecipeListLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 21.07.2026.
//

import RecipeList
import Recipe
import Foundation

actor RecipeListLoaderStub: RecipeListLoader {
    func load() async throws -> [RecipeListItem] {
        try await withCheckedThrowingContinuation({ continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                continuation.resume(returning: sampleRecipes.listItems )
            }
        })
    }
}

private extension Array where Element == Recipe {
    var listItems: [RecipeListItem] {
        self.compactMap { item in
            guard let imageUrl = item.imageSource else { return nil }
            return RecipeListItem(
                id: item.id,
                name: item.title,
                cookingTimeMins: item.cookingTimeMins,
                imageUrl: imageUrl,
                rating: nil,
                complexity: item.complexity
            )
        }
    }
}
