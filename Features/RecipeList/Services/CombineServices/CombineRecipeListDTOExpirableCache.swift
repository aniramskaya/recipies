//
//  CombineRecipeListDTOExpirableCache.swift
//  recipies
//
//  Created by Марина Чемезова on 19.01.2026.
//

import Combine
import Foundation

final class CombineRecipeListDTOExpirableCache: CombineCacheable  {
    typealias Key = String
    typealias Data = RecipeListDTO

    private let lock = NSLock()
    private let cache: CombineRecipeListDTOCache
    private let expirationPolicy: TimestampExpirationPolicy
    private var cacheSaveTime: [String: Date] = [:]
    
    init(cache: CombineRecipeListDTOCache, expirationPolicy: TimestampExpirationPolicy) {
        self.cache = cache
        self.expirationPolicy = expirationPolicy
    }
    
    func get(key: String) -> AnyPublisher<RecipeListDTO, CombineCacheableError> {
        lock.lock()
        let saved = cacheSaveTime[key]
        lock.unlock()
        guard let saved, expirationPolicy.isValid(saved) else {
            return Fail(error: CombineCacheableError.expired).eraseToAnyPublisher()
        }
        return cache.get(key: key)
    }
    
    func set(key: String, data: RecipeListDTO) {
        lock.lock()
        cacheSaveTime[key] = Date()
        lock.unlock()
        cache.set(key: key, data: data)
    }
    
    func clear(key: String) {
        lock.lock()
        cacheSaveTime[key] = nil
        lock.unlock()
        cache.clear(key: key)
    }
    
    func clearAll() {
        lock.lock()
        cacheSaveTime = [:]
        lock.unlock()
        cache.clearAll()
    }
}
