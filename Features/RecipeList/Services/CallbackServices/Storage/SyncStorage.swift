//
//  RecipeListStorage.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation

protocol SyncStorage {
    associatedtype Model
    func read() -> Model?
    func write(_ items: Model)
    func delete()
}
