//
//  CombineCacheable.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

// Мы не хотим чтобы кэш случайно раздвоился, поэтому ставим ограничение на AnyObject,
// чтобы реализация точно была reference типом
protocol CombineCacheable: AnyObject {
    associatedtype Key: Hashable
    associatedtype Data
    
    func get(key: Key) -> AnyPublisher<Data, CombineCacheableError>
    func set(key: Key, data: Data)
    func clear(key: Key)
    func clearAll()
}

enum CombineCacheableError: Error {
    case notFound
    case expired
}
