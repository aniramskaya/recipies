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

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                if let recipeRepository {
                    let recipeList = RecipeListAssembly
                        .composeWithAsyncServices(
                            loader: RecipeListRepositoryLoader(recipeRepository),
                            onSelectItem: { id, isDraft in
                                path.append(RecipeId(id: id, isDraft: isDraft))
                            },
                        )
//                    WithCreateRecipePush(
//                        path: $path,
//                        loader: RecipeRepositoryDraftLoader(recipeRepository, id: nil),
//                        saver: recipeRepository,
//                        deleter: recipeRepository
//                    ) {
//                        recipeList
//                    }
                    recipeList
                    .navigationDestination(for: RecipeId.self) { destination in
                        if destination.isDraft {
                            RecipeCreateScreenAssembly.compose(
                                loader: RecipeRepositoryDraftLoader(recipeRepository, id: destination.id),
                                saver: recipeRepository,
                                deleter: recipeRepository
                            )
                        } else {
                            RecipeDetailWithEditScreenAssembly.compose(
                                loader: RecipeRepositoryLoader(recipeRepository, id: destination.id),
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
