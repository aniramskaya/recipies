//
//  ScopedCache.swift
//  Scenarios
//

/// Adapts a multi-key ``Cache`` to ``SingleValueCache`` by binding it to a specific key.
public final class ScopedCache<C: Cache>: SingleValueCache, Sendable {
    private let cache: C
    private let key: C.Key

    public init(cache: C, key: C.Key) {
        self.cache = cache
        self.key = key
    }

    public func get() async -> CacheEntry<C.Data> {
        await cache.get(key: key)
    }

    public func set(data: C.Data) async {
        await cache.set(key: key, data: data)
    }

    public func clear() async {
        await cache.clear(key: key)
    }
}

extension Cache {
    /// Returns a ``SingleValueCache`` view of this cache bound to the given key.
    public func scoped(to key: Key) -> ScopedCache<Self> {
        ScopedCache(cache: self, key: key)
    }
}
