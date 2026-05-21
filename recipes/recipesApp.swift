//
//  recipesApp.swift
//  recipes
//
//  Created by Марина Чемезова on 14.10.2023.
//

import SwiftUI
import RecipeList
import RecipeEdit

@main
struct recipesApp: App {
    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                // RecipeListAssembly.composeWithCalbackServices()
                // RecipeListAssembly.composeWithCombineServices()
                RecipeListAssembly
                    .composeWithAsyncServices(onSelectItem: {
                        path.append(RecipeId(id: $0))
                    } )
                    .navigationDestination(for: RecipeId.self) { id in
                        RecipeEditScreenAssembly.compose(id: id)
                    }
            }
        }
    }
}
