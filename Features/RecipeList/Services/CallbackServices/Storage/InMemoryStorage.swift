//
//  RecipeListInMemoryStorage.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation

final class InMemoryStorage<Model>: SyncStorage, @unchecked Sendable {
    private let lock = NSLock()
    private var data: Model?
    
    func read() -> Model? {
        lock.lock()
        defer {  lock.unlock() }
        return data
    }
    
    func write(_ items: Model) {
        lock.lock()
        defer {  lock.unlock() }
        data = items
    }
    
    func delete() {
        lock.lock()
        defer {  lock.unlock() }
        data = nil
    }
}
