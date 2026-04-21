//
//  AsyncRecipeListDTOExpirableCache.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//
import Foundation

actor AsyncExpirableCache<WrappedCache: AsyncCacheable>: AsyncCacheable  {
    typealias Key = WrappedCache.Key
    typealias Data = WrappedCache.Data
    
    private let cache: WrappedCache
    private let expirationPolicy: TimestampExpirationPolicy
    private var cacheSaveTime: [Key: Date] = [:]
    
    init(cache: WrappedCache, expirationPolicy: TimestampExpirationPolicy) {
        self.cache = cache
        self.expirationPolicy = expirationPolicy
    }
    
    func get(key: Key) async throws -> Data {
        guard let saved = cacheSaveTime[key], expirationPolicy.isValid(saved) else {
            throw AsyncCacheableError.expired
        }
        return try await cache.get(key: key)
    }
    
    func set(key: Key, data: Data) async {
        cacheSaveTime[key] = Date()
        await cache.set(key: key, data: data)
    }
    
    func clear(key: Key) async {
        cacheSaveTime[key] = nil
        await cache.clear(key: key)
    }
    
    func clearAll() async {
        cacheSaveTime = [:]
        await cache.clearAll()
    }
}
