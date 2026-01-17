//
//  RecipeListLoaderAsyncAdapter.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//

struct RecipeListLoaderAsyncAdapter {
    let loader: RecipeListLoader
    init(loader: RecipeListLoader) {
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
