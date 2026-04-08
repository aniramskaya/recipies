//
//  AsyncRecipeListDTOCache.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

import Foundation

final class AsyncInMemoryCache<Key: Hashable, Data>: AsyncCacheable {
    private var storage: [Key: Data] = [:]

    func get(key: Key) async throws -> Data {
        if let value = storage[key] {
            return value
        } else {
            throw AsyncCacheableError.notFound
        }
    }
    
    func set(key: Key, data: Data) async {
        storage[key] = data
    }
    
    func clear(key: Key) async {
        storage[key] = nil
    }
    
    func clearAll() async {
        storage = [:]
    }
}
