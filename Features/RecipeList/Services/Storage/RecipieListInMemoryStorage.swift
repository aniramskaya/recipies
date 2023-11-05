//
//  RecipieListInMemoryStorage.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation

public class RecipieListInMemoryStorage {
    private var data: [RecipeListItem]?
    
    public func read() -> [RecipeListItem]? {
        return data
    }
    
    public func write(_ items: [RecipeListItem]) {
        data = items
    }
    
    public func delete() {
        data = nil
    }
}
