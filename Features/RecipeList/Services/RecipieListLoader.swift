//
//  RecipieListLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

public protocol RecipieListLoader {
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void)
}
