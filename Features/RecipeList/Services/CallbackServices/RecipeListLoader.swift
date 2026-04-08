//
//  RecipeListLoader.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

public protocol RecipeListLoader {
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void)
}
