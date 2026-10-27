//
//  RecipeListLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 21.07.2026.
//

import RecipeList
import Recipe
import RecipeTypes
import Foundation
import RecipeStorage

actor RecipeListRepositoryLoader: RecipeListLoader {
    let repository: RecipeRepository

    init (_ repository: RecipeRepository) {
        self.repository = repository
    }

    func load() async throws -> [RecipeListItem] {
        let start = Date()
        let items = try await self.repository.fetchAll()
        print("Loading took \(Date().timeIntervalSince(start))")
        return items.map(\.self).listItems
    }
}

private extension Array where Element == Recipe {
    var listItems: [RecipeListItem] {
        self.map { item in
            RecipeListItem(
                id: item.id,
                name: item.title,
                cookingTimeMins: item.cookingTimeMins,
                imageUrl: item.imageSource,
                rating: nil,
                complexity: item.complexity,
                isDraft: item.isDraft
            )
        }
    }
}
