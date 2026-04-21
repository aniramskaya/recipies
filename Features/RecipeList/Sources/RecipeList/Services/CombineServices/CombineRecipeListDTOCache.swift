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
    
    private let lock = NSLock()
    private var storage: [String: RecipeListDTO] = [:]

    func get(key: String) -> AnyPublisher<RecipeListDTO, CombineCacheableError> {
        return Deferred { [weak self] in
            Future { [weak self] promise in
                guard let self else {
                    promise(.failure(CombineCacheableError.notFound))
                    return
                }
                let result: Result<RecipeListDTO, CombineCacheableError>
                
                self.lock.lock()
                if let value = self.storage[key] {
                    result = .success(value)
                } else {
                    result = .failure(CombineCacheableError.notFound)
                }
                self.lock.unlock()
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
    
    func set(key: String, data: RecipeListDTO) {
        self.lock.lock()
        defer { self.lock.unlock() }
        storage[key] = data
    }
    
    func clear(key: String) {
        self.lock.lock()
        defer { self.lock.unlock() }
        storage[key] = nil
    }
    
    func clearAll() {
        self.lock.lock()
        defer { self.lock.unlock() }
        storage = [:]
    }
}
