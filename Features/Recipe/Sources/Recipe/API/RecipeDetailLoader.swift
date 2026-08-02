//
//  RecipeDetailLoader.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import Foundation

public protocol RecipeDetailLoader: AnyObject, Sendable {
    func load() async throws -> Recipe
}
