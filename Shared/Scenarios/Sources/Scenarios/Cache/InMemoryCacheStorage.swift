//
//  InMemoryCacheStorage.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

public actor InMemoryCacheStorage<Key: Hashable & Sendable, Data: Sendable>: CacheStorage {
    public typealias Key = Key
    public typealias Data = Data

    private var storage: [Key: Data] = [:]

    public init() {}
    
    public func get(key: Key) async -> Data? {
        storage[key]
    }
    
    public func set(key: Key, data: Data) async {
        storage[key] = data
    }
    
    public func clear(key: Key) async {
        storage[key] = nil
    }
    
    public func clearAll() async {
        storage = [:]
    }
}
