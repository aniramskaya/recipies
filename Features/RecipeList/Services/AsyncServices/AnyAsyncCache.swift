//
//  AnyAsyncCache.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

final class AnyAsyncCacheable<Key: Hashable, Data>: AsyncCacheable {
    private let _get: (Key) async throws -> Data
    private let _set: (Key, Data) async -> Void
    private let _clear: (Key) async -> Void
    private let _clearAll: () async -> Void
    
    init<C: AsyncCacheable>(_ cache: C) where C.Key == Key, C.Data == Data {
        self._get = { key in try await cache.get(key: key) }
        self._set = { key, data in await cache.set(key: key, data: data) }
        self._clear = { key in await cache.clear(key: key) }
        self._clearAll = { await cache.clearAll() }
    }
    
    func get(key: Key) async throws -> Data {
        try await _get(key)
    }
    
    func set(key: Key, data: Data) async {
        await _set(key, data)
    }
    
    func clear(key: Key) async {
        await _clear(key)
    }
    
    func clearAll() async {
        await _clearAll()
    }
}

extension AsyncCacheable {
    func erasedToAnyAsyncCacheable() -> AnyAsyncCacheable<Self.Key, Self.Data> {
        .init(self)
    }
}
