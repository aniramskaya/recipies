//
//  RecipeListCache.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

public struct RecipeListStored {
    public let items: [RecipeListItem]
    public let timestamp: Date
    
    public init(items: [RecipeListItem], timestamp: Date) {
        self.items = items
        self.timestamp = timestamp
    }
}

public protocol TimestampExpirationPolicy {
    func isValid(_: Date) -> Bool
}

public class RecipeListCache {
    public enum Error: Swift.Error {
        case empty
        case expired
    }
    
    private let storage: InMemoryStorage<RecipeListStored>
    private let expirationPolicy: TimestampExpirationPolicy
    
    public init(storage: InMemoryStorage<RecipeListStored>, expirationPolicy: TimestampExpirationPolicy) {
        self.storage = storage
        self.expirationPolicy = expirationPolicy
    }
    
    public func read() -> Result<[RecipeListItem], Error> {
        if let stored = storage.read() {
            if expirationPolicy.isValid(stored.timestamp) {
                return .success(stored.items)
            } else {
                return .failure(.expired)
            }
        } else {
            return .failure(.empty)
        }
    }
    
    public func write(_ items: [RecipeListItem]) {
        storage.write(RecipeListStored(items: items, timestamp: Date()))
    }
}
