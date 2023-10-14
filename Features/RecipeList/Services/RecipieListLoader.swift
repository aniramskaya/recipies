//
//  RecipieListLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

class RecipieListLoader {
    let dtoLoader: DTOLoader
    var cache: [RecipeListItem]?
    var lastLoaded: Date?
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        if let cache, Date().timeIntervalSince(lastLoaded ?? .distantPast) < 3600 {
            completion(.success(cache))
            return
        }
        dtoLoader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(dto):
                let models = dto.items.models
                self.cache = models
                self.lastLoaded = Date()
                completion(.success(models))
            case let .failure(error):
                if let cache {
                    completion(.success(cache))
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
