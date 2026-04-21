//
//  AsyncRecipeListLoader.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

let AsyncRecipeListCacheKey = "RecipeList"

struct AsyncRecipeListLoader: RecipeListLoaderAsync {
    let flow: Flow<[RecipeListItem]>
    
    init(dtoLoader: AsyncRecipeListDTOLoader, cache: AnyAsyncCacheable<String, RecipeListDTO>) {
        flow = Flow{
            try await dtoLoader.load()
        }
        .onSuccess{ dto in
            await cache.set(key: AsyncRecipeListCacheKey, data: dto)
        }
        .fallback{
            try await cache.get(key: AsyncRecipeListCacheKey)
        }
        .map{ dto in
            dto.items.models
        }
    }
    
    func load() async throws -> [RecipeListItem] {
        try await flow()
    }
}
