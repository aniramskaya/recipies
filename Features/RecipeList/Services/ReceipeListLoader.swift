//
//  ReceipeListLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation

protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

class ReceipeListLoader {
    let dtoLoader: DTOLoader
    
    var cache: [RecipeListItem]?
    var lastLoaded: Date?
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        if let cache, (lastLoaded ?? .distantPast).addingTimeInterval(3600) > Date() {
            completion(.success(cache))
            return
        }

        dtoLoader.load { [weak self] result in
            switch result {
            case let .failure(error):
                if let cache = self?.cache {
                    completion(.success(cache))
                } else {
                    completion(.failure(error))
                }
            case let .success(dto):
                var models: [RecipeListItem] = []
                for item in dto.items {
                    models.append(.init(
                        id: item.id,
                        name: item.name,
                        cookingTime: TimeInterval(item.cookingTime * 60),
                        imageUrl: item.imageUrl,
                        rating: item.rating
                    ))
                }
                self?.cache = models
                self?.lastLoaded = Date()
                completion(.success(models))
            }
        }
    }
}
