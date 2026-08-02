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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                // RecipeListAssembly.composeWithCalbackServices()
                // RecipeListAssembly.composeWithCombineServices()
                RecipeListAssembly
                    .composeWithAsyncServices(
                        loader: RecipeListLoaderStub(),
                        onSelectItem: {
                            path.append(RecipeId(id: $0))
                        }
                    )
                    .navigationTitle("Мои рецепты")
                    .navigationDestination(for: RecipeId.self) { id in
                        RecipeDetailScreenAssembly.compose(loader: RecipeLoader(id: id.id))
                    }
            }
        }
    }
}
