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

@main
struct recipesApp: App {
    @State private var recipeRepository: RecipeRepository?
    @State private var path = NavigationPath()
    @State private var isAddingRecipe = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                if let recipeRepository {
                    let (recipeList, reloadRecipeList) = RecipeListAssembly
                        .composeWithAsyncServices(
                            loader: RecipeListRepositoryLoader(recipeRepository),
                            onSelectItem: {
                                path.append(RecipeId(id: $0))
                            },
                        )
                    WithAddRecipeSheet(
                        saver: recipeRepository,
                        onRecipeAdded: reloadRecipeList
                    ) {
                        recipeList
                    }
                    .navigationDestination(for: RecipeId.self) { id in
                        RecipeDetailWithEditScreenAssembly.compose(
                            loader: RecipeRepositoryLoader(recipeRepository, id: id.id),
                            saver: recipeRepository
                        )
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
