//
//  recipesApp.swift
//  recipes
//
//  Created by Марина Чемезова on 14.10.2023.
//

import SwiftUI
import RecipeList

@main
struct recipesApp: App {
    var body: some Scene {
        WindowGroup {
            // RecipeListAssembly.composeWithCalbackServices()
            // RecipeListAssembly.composeWithCombineServices()
            RecipeListAssembly.composeWithAsyncServices()
        }
    }
}
