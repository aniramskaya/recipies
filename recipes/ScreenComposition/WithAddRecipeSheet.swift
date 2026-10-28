//
//  RecipeListWithAdd.swift
//  recipies
//
//  Created by Марина Чемезова on 11.09.2026.
//

import SwiftUI
import RecipeList
import Recipe

public struct NewRecipeDraft: Hashable {}

struct WithCreateRecipePush<Content: View>: View {
    @Binding var path: NavigationPath
    let loader: any RecipeDetailLoader
    let saver: any RecipeSaver
    let deleter: any RecipeDeleter
    @ViewBuilder let content: Content

    var body: some View {
        content

    }
}
