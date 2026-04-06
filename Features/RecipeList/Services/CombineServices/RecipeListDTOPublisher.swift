//
//  RecipeListDTOPublisher.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

protocol RecipeListDTOPublisher {
    func publisher() -> AnyPublisher<RecipeListDTO, Error>
}
