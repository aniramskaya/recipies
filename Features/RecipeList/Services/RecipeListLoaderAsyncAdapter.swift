//
//  RecipeListLoaderAsyncAdapter.swift
//  recipies
//
//  Created by Марина Чемезова on 14.01.2026.
//

struct RecipeListLoaderAsyncAdapter {
    let loader: RecipieListLoader
    init(loader: RecipieListLoader) {
        self.loader = loader
    }
    
    func load() async throws -> [RecipeListItem] {
        try await withCheckedThrowingContinuation { continuation in
            loader.load { result in
                continuation.resume(with: result)
            }
        }
    }
}
