//
//  AsyncInMemoryCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

actor AsyncInMemoryCache<Key: Hashable & Sendable, Data: Sendable>: AsyncCacheable {
    typealias Key = Key
    typealias Data = Data

    private var storage: [Key: Data] = [:]

    func get(key: Key) async -> Scenarios.AsyncCacheableResult<Data> {
        guard let data = storage[key] else { return .empty }
        return .fresh(data)
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
