//
//  RecipeDetailWithEditScreenAssembly.swift
//  Recipe
//
//  Created by Марина Чемезова on 11.09.2026.
//

import SwiftUI

public enum RecipeDetailWithEditScreenAssembly {
    @MainActor
    public static func compose(
        loader: any RecipeDetailLoader,
    ) -> some View {
        RecipeDetailWithEdit(loader: loader)
    }
}

private struct RecipeDetailWithEdit: View {
    let loader: any RecipeDetailLoader
    @State var draft: RecipeDraftModel? = nil

    var body: some View {
        RecipeDetailScreenAssembly
            .compose(loader: loader, onEdit: { draft = $0 })
            .sheet(item: $draft) { item in
                RecipeEditScreenAssembly.composeModal(
                    model: item,
                    onCancel: { draft = nil },
                    onSave: { draft = nil }
                )
            }
    }
}
