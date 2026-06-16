//
//  AsyncInMemoryCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

actor InMemoryCacheStorage<Key: Hashable & Sendable, Data: Sendable>: CacheStorage {
    typealias Key = Key
    typealias Data = Data

    private var storage: [Key: Data] = [:]

    func get(key: Key) async -> Data? {
        storage[key]
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
