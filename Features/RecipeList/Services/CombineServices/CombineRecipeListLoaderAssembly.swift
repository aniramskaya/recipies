//
//  RecipeListLoaderAssembly.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

let RecipeListCacheKey = "RecipeList"

enum CombineRecipeListLoaderAssembly {
    static func composeInternal(
        dtoLoader: RecipeListDTOPublisher,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (CombineRecipeListLoader, [AnyObject]) {
        let plainCache = CombineRecipeListDTOCache()
        let cache = CombineRecipeListDTOExpirableCache(cache: plainCache, expirationPolicy: cacheExpirationPolicy)
        
        let publisherFactory =  {
            dtoLoader.publisher()
                .handleEvents(receiveOutput: { dto in
                    cache.set(key: RecipeListCacheKey, data: dto)
                })
                .catch { error in
                    return cache.get(key: RecipeListCacheKey).mapError { _ in error }
                }
                .map({ value in
                    value.items.models
                })
                .eraseToAnyPublisher()
        }
        let loader = CombineRecipeListLoader(publisherFactory: publisherFactory)
        
        return (loader, [cache, plainCache])
    }
}
