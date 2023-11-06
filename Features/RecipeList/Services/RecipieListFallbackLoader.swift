//
//  RecipieListFallbackLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

public protocol RecipieListLoader {
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void)
}

public class RecipieListFallbackLoader: RecipieListLoader {
    let remoteLoader: RecipieListLoader
    let cache: RecipieListCache
    
    public init(remoteLoader: RecipieListLoader, cache: RecipieListCache) {
        self.remoteLoader = remoteLoader
        self.cache = cache
    }
    
    public func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        let cacheResult = cache.read()
        switch cacheResult {
        case .success(let items):
            completion(.success(items))
        case .failure:
            remoteLoader.load(completion: completion)
        }
    }

}

extension Array where Element == RecipeListItemDTO {
    var models: [RecipeListItem] {
        map { .init(
            id: $0.id,
            name: $0.name,
            cookingTime: Double($0.cookingTime * 60),
            imageUrl: $0.imageUrl,
            rating: $0.rating
        ) }
    }
}
