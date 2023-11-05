//
//  RecipieListStorage.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation

public protocol RecipieListStorage {
    func read() -> [RecipeListItem]?
    func write(_ items: [RecipeListItem])
    func delete()
}
