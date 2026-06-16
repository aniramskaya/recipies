//
//  TTLCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import  Foundation

actor TTLCache<Storage: CacheStorage>: Cache {
    typealias Key = Storage.Key
    typealias Data = Storage.Data
    
    private let storage: Storage
    private let expirationPolicy: TTLPolicy
    private var saveTime: [Key: Date] = [:]
    
    init(storage: Storage, expirationPolicy: TTLPolicy) {
        self.storage = storage
        self.expirationPolicy = expirationPolicy
    }
    
    func get(key: Key) async -> CacheEntry<Data> {
        let data = await storage.get(key: key)
        guard let data else { return .empty }
        return isFresh(key: key) ? .fresh(data) : .stale(data)
    }
    
    private func isFresh(key: Key) -> Bool {
        guard let saved = saveTime[key] else { return false }
        return expirationPolicy.isValid(savedAt: saved)
    }
    
    func set(key: Key, data: Data) async {
        saveTime[key] = Date()
        await storage.set(key: key, data: data)
    }
    
    func clear(key: Key) async {
        saveTime[key] = nil
        await storage.clear(key: key)
    }
    
    func clearAll() async {
        saveTime = [:]
        await storage.clearAll()
    }
}
