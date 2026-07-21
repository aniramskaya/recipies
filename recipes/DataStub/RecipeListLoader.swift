//
//  RecipeListLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 21.07.2026.
//

import RecipeList
import RecipeEdit
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
        self.map({ item in
            RecipeListItem(
                id: item.id,
                name: item.title,
                cookingTime: TimeInterval(item.cookingTimeMins * 60),
                imageUrl: item.imageSource,
                rating: nil,
                complexity: item.complexity
            )
        })
    }
}
