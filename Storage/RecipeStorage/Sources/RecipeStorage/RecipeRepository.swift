//
//  RecipeRepository.swift
//  RecipeStorage
//
//  Created by Марина Чемезова on 08.10.2026.
//
import Foundation
import SwiftData
import RecipeTypes

public func makeRecipeRepository() async throws -> RecipeRepository {
    let configuration = ModelConfiguration()
    let container = try ModelContainer(for: RecipeModel.self, configurations: configuration)
    return RecipeRepository(modelContainer: container)
}

@ModelActor
public actor RecipeRepository {
    public func fetchAll() async throws -> [Recipe] {
        let descriptor = FetchDescriptor<RecipeModel>(
            sortBy: [.init(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { $0.domain }
    }

    public func countRecipes() async throws -> Int {
        return try modelContext.fetchCount(FetchDescriptor<RecipeModel>())
    }

    public func fetchOne(id: UUID) async throws -> Recipe {
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let result = try modelContext.fetch(descriptor).first else {
            throw StorageError.notFound
        }
        
        return result.domain
    }
    
    public func save(_ recipe: Recipe) async throws {
        let id = recipe.id
        let descriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate { $0.id == id }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            existing.update(with: recipe)
        } else {
            modelContext.insert(RecipeModel.from(recipe))
        }
        
        try modelContext.save()
    }
}
