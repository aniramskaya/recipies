//
//  RecipeDetailLoader.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import Foundation
import RecipeTypes

public protocol RecipeDetailLoader: AnyObject, Sendable {
    func load() async throws -> Recipe
}
