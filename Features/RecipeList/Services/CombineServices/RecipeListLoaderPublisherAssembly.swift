//
//  RecipeListLoaderAssembly.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

let RecipeListCacheKey = "RecipeList"

enum RecipeListLoaderPublisherAssembly {
    static func composeInternal(
        dtoLoader: RecipeListDTOPublisher,
        cacheExpirationPolicy: TimestampExpirationPolicy
    ) -> (AnyPublisher<[RecipeListItem], Error>, RecipeListDTOExpirableCache) {
        let cache = RecipeListDTOExpirableCache(cache: RecipeListDTOCache(), expirationPolicy: cacheExpirationPolicy)
        
        let publisher = dtoLoader.publisher()
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
        return (publisher, cache)
    }
}
