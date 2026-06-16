//
//  CacheStorage.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

// Мы не хотим чтобы кэш случайно раздвоился, поэтому ставим ограничение на AnyObject,
// чтобы реализация точно была reference типом

/// Protocol for asynchronously caching items of a single type using hasheable keys
protocol CacheStorage: AnyObject, Sendable {
    associatedtype Key: Hashable & Sendable
    associatedtype Data: Sendable
    
    /// Returns cache reading tesult for the given key
    func get(key: Key) async -> Data?

    /// Stores the data for the given key.
    /// Note that in general this method is not intended for removing data for given key even is Data is an optional type. Use ``clear`` method instead
    func set(key: Key, data: Data) async
    
    /// Removes entry from the cache for a given key
    func clear(key: Key) async
    
    /// Removes all entries from the cache
    func clearAll() async
}
