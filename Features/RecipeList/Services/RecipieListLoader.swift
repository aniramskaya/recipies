//
//  RecipieListLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

public class RecipieListLoader {
    let dtoLoader: DTOLoader
    let cacheService: RecipieListCache
    let storage: InMemoryStorage<RecipeListStored>
    
    public init(dtoLoader: DTOLoader, cache: RecipieListCache, storage: InMemoryStorage<RecipeListStored>) {
        self.dtoLoader = dtoLoader
        self.cacheService = cache
        self.storage = storage
    }
    
    public func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        let cacheResult = cacheService.read()
        switch cacheResult {
        case .success(let items):
            completion(.success(items))
        case .failure:
            loadFromRemote(completion: completion)
        }
    }
    
    private func loadFromRemote(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        dtoLoader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(dto):
                let models = dto.items.models
                cacheService.write(models)
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
