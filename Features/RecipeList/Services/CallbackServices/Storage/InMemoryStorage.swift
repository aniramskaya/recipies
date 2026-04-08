//
//  RecipeListInMemoryStorage.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation

public class InMemoryStorage<Model>: SyncStorage {
    private var data: Model?
    
    public func read() -> Model? {
        return data
    }
    
    public func write(_ items: Model) {
        data = items
    }
    
    public func delete() {
        data = nil
    }
}
