//
//  recipesApp.swift
//  recipes
//
//  Created by Марина Чемезова on 14.10.2023.
//

import SwiftUI
import RecipeList
import Recipe
import RecipeStorage
import SwiftData

enum AppRoute: Hashable {
    case recipe(RecipeId)
    case recipeDraft
}

@main
struct recipesApp: App {
    @State private var recipeRepository: RecipeRepository?
    @State private var path: [AppRoute] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                if let recipeRepository {
                    RecipeListScreen(
                        loader: RecipeListRepositoryLoader(recipeRepository),
                        onSelectItem: { id, isDraft in
                            path.append(.recipe(RecipeId(id: id, isDraft: isDraft)))
                        }
                    )
                    .navigationTitle(.recipeListTitle)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(.recipeAdd, action: { path.append(.recipeDraft) })
                        }
                    }
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case let .recipe(recipe):
                            if recipe.isDraft {
                                RecipeCreateScreen(
                                    loader: RecipeRepositoryDraftLoader(recipeRepository, id: recipe.id),
                                    saver: recipeRepository,
                                    deleter: recipeRepository
                                )
                            } else {
                                RecipeDetailWithEdit(
                                    loader: RecipeRepositoryLoader(recipeRepository, id: recipe.id),
                                    saver: recipeRepository,
                                    deleter: recipeRepository
                                )
                            }
                        case .recipeDraft:
                            RecipeCreateScreen(
                                loader: RecipeRepositoryDraftLoader(recipeRepository, id: nil),
                                saver: recipeRepository,
                                deleter: recipeRepository
                            )
                        }
                        
                    }
                } else {
                    Color.primary
                }
            }
            .task {
                recipeRepository = try? await Task.detached {
                    let result = try await makeRecipeRepository()
                    if ((try? await result.countRecipes()) ?? 0) == 0 {
                        for item in sampleRecipes {
                            try? await result.save(item)
                        }
                    }
                    return result
                }.value
            }
        }
    }
}
