//
//  RecipeListRemoteLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

public class RecipieListRemoteLoader: RecipieListLoader {
    let dtoLoader: DTOLoader
    let cache: RecipieListCache
    let storage: InMemoryStorage<RecipeListStored>
    
    public init(dtoLoader: DTOLoader, cache: RecipieListCache, storage: InMemoryStorage<RecipeListStored>) {
        self.dtoLoader = dtoLoader
        self.cache = cache
        self.storage = storage
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
                if let stored = storage.read() {
                    completion(.success(stored.items))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
