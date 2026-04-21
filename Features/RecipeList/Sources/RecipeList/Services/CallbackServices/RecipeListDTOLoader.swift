//
//  RecipeListDTOLoader.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

protocol RecipeListDTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}
