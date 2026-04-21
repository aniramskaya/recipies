//
//  AsyncCacheable.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

// Мы не хотим чтобы кэш случайно раздвоился, поэтому ставим ограничение на AnyObject,
// чтобы реализация точно была reference типом
protocol AsyncCacheable: AnyObject, Sendable {
    associatedtype Key: Hashable & Sendable
    associatedtype Data: Sendable
    
    func get(key: Key) async throws -> Data
    func set(key: Key, data: Data) async
    func clear(key: Key) async
    func clearAll() async
}

enum AsyncCacheableError: Error {
    case notFound
    case expired
}
