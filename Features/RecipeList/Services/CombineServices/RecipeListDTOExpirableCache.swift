//
//  RecipeListDTOExpirableCache.swift
//  recipies
//
//  Created by Марина Чемезова on 19.01.2026.
//

import Combine
import Foundation

class RecipeListDTOExpirableCache: Cacheable  {
    typealias Key = String
    typealias Data = RecipeListDTO

    private let cache: RecipeListDTOCache
    private let expirationPolicy: TimestampExpirationPolicy
    private var cacheSaveTime: [String: Date] = [:]
    
    init(cache: RecipeListDTOCache, expirationPolicy: TimestampExpirationPolicy) {
        self.cache = cache
        self.expirationPolicy = expirationPolicy
    }
    
    func get(key: String) -> AnyPublisher<RecipeListDTO, CacheableError> {
        guard let saved = cacheSaveTime[key], expirationPolicy.isValid(saved) else {
            return Fail(error: CacheableError.expired).eraseToAnyPublisher()
        }
        return cache.get(key: key)
    }
    
    func set(key: String, data: RecipeListDTO) {
        cacheSaveTime[key] = Date()
        cache.set(key: key, data: data)
    }
    
    func clear(key: String) {
        cacheSaveTime[key] = nil
        cache.clear(key: key)
    }
    
    func clearAll() {
        cacheSaveTime = [:]
        cache.clearAll()
    }
}
