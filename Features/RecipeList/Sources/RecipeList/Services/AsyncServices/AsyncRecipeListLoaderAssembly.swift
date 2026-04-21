//
//  AsyncRecipeListLoaderAssembly.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//


enum AsyncRecipeListLoaderAssembly {
    static func composeInternal(
        dtoLoader: AsyncRecipeListDTOLoader,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (AsyncRecipeListLoader, [AnyObject]) {
        let plainCache = AsyncInMemoryCache<String, RecipeListDTO>()
        let cache = AsyncExpirableCache(cache: plainCache, expirationPolicy: cacheExpirationPolicy).erasedToAnyAsyncCacheable()
        
        let loader = AsyncRecipeListLoader(dtoLoader: dtoLoader, cache: cache)
        
        return (loader, [cache, plainCache])
    }
}
