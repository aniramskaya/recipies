
//
//  CombineRecipeListLoder.swift
//  recipies
//
//  Created by Марина Чемезова on 06.04.2026.
//
import Combine
import AsyncAlgorithms

struct CombineRecipeListLoader: RecipeListLoaderAsync {
    let publisherFactory: () -> AnyPublisher<[RecipeListItem], Error>
    
    init(publisherFactory: @escaping () -> AnyPublisher<[RecipeListItem], Error>) {
        self.publisherFactory = publisherFactory
    }
    
    func load() async throws -> [RecipeListItem] {
        let publisher = publisherFactory()
        
        for try await value in publisher.values {
            return value
        }
        
        return []
    }
}
