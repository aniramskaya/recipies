//
//  AsyncRecipeListDTOCache.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

import Foundation

actor AsyncInMemoryCache<Key: Hashable & Sendable, Data: Sendable>: AsyncCacheable {
    private var storage: [Key: Data] = [:]

    func get(key: Key) throws -> Data {
        if let value = storage[key] {
            return value
        } else {
            throw AsyncCacheableError.notFound
        }
    }
    
    func set(key: Key, data: Data) {
        storage[key] = data
    }
    
    func clear(key: Key) {
        storage[key] = nil
    }
    
    func clearAll() async {
        storage = [:]
    }
}
