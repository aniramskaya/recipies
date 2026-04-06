//
//  RecipeListItemsPublisher.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//
import Combine

protocol RecipeListItemsPublisher {
    func publisher() -> AnyPublisher<[RecipeListItem], Error>
}
