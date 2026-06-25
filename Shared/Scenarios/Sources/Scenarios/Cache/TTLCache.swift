//
//  TTLCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import  Foundation

public actor TTLCache<Storage: CacheStorage>: Cache {
    public typealias Key = Storage.Key
    public typealias Data = Storage.Data
    
    private let storage: Storage
    private let expirationPolicy: TTLPolicy
    private var saveTime: [Key: Date] = [:]
    
    public init(storage: Storage, expirationPolicy: TTLPolicy) {
        self.storage = storage
        self.expirationPolicy = expirationPolicy
    }
    
    // Non-Sendable type 'CacheEntry<TTLCache<Storage>.Data>' (aka 'CacheEntry<any Sendable>') cannot be returned from actor-isolated implementation to caller of protocol requirement 'get(key:)'
    public func get(key: Key) async -> CacheEntry<Data> {
        let data = await storage.get(key: key)
        guard let data else { return .empty }
        return isFresh(key: key) ? .fresh(data) : .stale(data)
    }
    
    private func isFresh(key: Key) -> Bool {
        guard let saved = saveTime[key] else { return false }
        return expirationPolicy.isValid(savedAt: saved)
    }
    
    public func set(key: Key, data: Data) async {
        saveTime[key] = Date()
        await storage.set(key: key, data: data)
    }
    
    public func clear(key: Key) async {
        saveTime[key] = nil
        await storage.clear(key: key)
    }
    
    public func clearAll() async {
        saveTime = [:]
        await storage.clearAll()
    }
}
