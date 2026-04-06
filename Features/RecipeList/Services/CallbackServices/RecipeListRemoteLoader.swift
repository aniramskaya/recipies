//
//  RecipeListRemoteLoader.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

public class RecipeListRemoteLoader: RecipeListLoader {
    let dtoLoader: RecipeListDTOLoader
    let cache: RecipeListCache
    
    public init(dtoLoader: RecipeListDTOLoader, cache: RecipeListCache) {
        self.dtoLoader = dtoLoader
        self.cache = cache
    }
    
    public func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        dtoLoader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(dto):
                let models = dto.items.models
                cache.write(models)
                completion(.success(models))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
