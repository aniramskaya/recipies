//
//  AsyncCacheable.swift
//  Scenarios
//
//  Created by Марина Чемезова on 15.06.2026.
//

/// Result of reading from the cache by the given key
public enum CacheEntry<Data: Sendable>: Sendable {
    /// No entry for the given key in the cache
    case empty
    /// Data for the given key is present in the cache and **is not marked as stale**
    case fresh(Data)
    /// Data for the given key is present in the cache and **is marked as stale**
    case stale(Data)
}

// Мы не хотим чтобы кэш случайно раздвоился, поэтому ставим ограничение на AnyObject,
// чтобы реализация точно была reference типом

/// Protocol for asynchronously caching items of a single type using hasheable keys
public protocol Cache: AnyObject, Sendable {
    associatedtype Key: Hashable & Sendable
    associatedtype Data: Sendable
    
    /// Returns cache reading tesult for the given key
    func get(key: Key) async -> CacheEntry<Data>

    /// Stores the data for the given key.
    /// Note that in general this method is not intended for removing data for given key even is Data is an optional type. Use ``clear`` method instead
    func set(key: Key, data: Data) async
    
    /// Removes entry from the cache for a given key
    func clear(key: Key) async
    
    /// Removes all entries from the cache
    func clearAll() async
}

extension CacheEntry: Equatable where Data: Equatable {
    public static func == (lhs: CacheEntry, rhs: CacheEntry) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case let (.fresh(lhsData), .fresh(rhsData)): return lhsData == rhsData
        case let (.stale(lhsDate), .stale(rhsDate)): return lhsDate == rhsDate
        default: return false
        }
    }
}
