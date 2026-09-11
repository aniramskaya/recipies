//
//  recipesApp.swift
//  recipes
//
//  Created by Марина Чемезова on 14.10.2023.
//

import SwiftUI
import RecipeList
import Recipe

@main
struct recipesApp: App {
    @State private var path = NavigationPath()
    @State private var isAddingRecipe = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                WithAddRecipeSheet {
                    RecipeListAssembly
                        .composeWithAsyncServices(
                            loader: RecipeListLoaderStub(),
                            onSelectItem: {
                                path.append(RecipeId(id: $0))
                            },
                        )

                }
                .navigationDestination(for: RecipeId.self) { id in
                    RecipeDetailWithEditScreenAssembly.compose(loader: RecipeLoader(id: id.id))
                }
            }
        }
    }
}
