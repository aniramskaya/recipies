//
//  RecipeListWithAdd.swift
//  recipies
//
//  Created by Марина Чемезова on 11.09.2026.
//

import SwiftUI
import RecipeList
import Recipe

struct WithAddRecipeSheet<Content: View>: View {
    @ViewBuilder let content: Content
    @State private var isAddingRecipe = false

    var body: some View {
        content
            .navigationTitle(.recipeListTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(.recipeAdd, action: { isAddingRecipe = true })
                }
            }
            .sheet(isPresented: $isAddingRecipe) {
                RecipeEditScreenAssembly.composeNewRecipe {
                    isAddingRecipe = false
                } onSave: {
                    isAddingRecipe = false
                }

            }
    }
}
