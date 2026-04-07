//
//  RecipeListDTOCache.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Foundation
import Combine


final class CombineRecipeListDTOCache: CombineCacheable {
    typealias Key = String
    typealias Data = RecipeListDTO
    
    private var storage: [String: RecipeListDTO] = [:]

    func get(key: String) -> AnyPublisher<RecipeListDTO, CacheableError> {
        return Deferred { [weak self] in
            Future { promise in
                if let value = self?.storage[key] {
                    promise(.success(value))
                } else {
                    promise(.failure(CacheableError.notFound))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func set(key: String, data: RecipeListDTO) {
        storage[key] = data
    }
    
    func clear(key: String) {
        storage[key] = nil
    }
    
    func clearAll() {
        storage = [:]
    }
}
