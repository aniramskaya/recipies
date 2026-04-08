//
//  RecipeListRemoteLoader.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

class RecipeListRemoteLoader: RecipeListLoader {
    let dtoLoader: RecipeListDTOLoader
    let cache: RecipeListCache
    
    init(dtoLoader: RecipeListDTOLoader, cache: RecipeListCache) {
        self.dtoLoader = dtoLoader
        self.cache = cache
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
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
