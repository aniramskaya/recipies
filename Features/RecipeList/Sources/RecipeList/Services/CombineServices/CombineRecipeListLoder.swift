
//
//  CombineRecipeListLoder.swift
//  recipies
//
//  Created by Марина Чемезова on 06.04.2026.
//
import Combine
import AsyncAlgorithms

struct CombineRecipeListLoader: RecipeListLoaderAsync {
    let publisherFactory: PublisherFactory<[RecipeListItem], Error>
    
    init(publisherFactory: PublisherFactory<[RecipeListItem], Error>) {
        self.publisherFactory = publisherFactory
    }
    
    func load() async throws -> [RecipeListItem] {
        let publisher = publisherFactory.make()
        
        for try await value in publisher.values {
            return value
        }
        
        return []
    }
}
