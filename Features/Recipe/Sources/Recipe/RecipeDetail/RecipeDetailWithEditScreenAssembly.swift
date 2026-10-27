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
        saver: any RecipeSaver,
        deleter: any RecipeDeleter
    ) -> some View {
        RecipeDetailWithEdit(loader: loader, saver: saver, deleter: deleter)
    }
}

private struct RecipeDetailWithEdit: View {
    let loader: any RecipeDetailLoader
    let saver: any RecipeSaver
    let deleter: any RecipeDeleter
    @Environment(\.dismiss) private var dismiss
    @State var onSaveCompleted: (() -> Void)?
    @State var draft: RecipeDraftModel? = nil

    var body: some View {
        RecipeDetailScreenAssembly.compose(
                loader: loader,
                onEdit: {
                    draft = $0
                    onSaveCompleted = $1
                }
            )
            .sheet(item: $draft) { item in
                RecipeEditScreenAssembly.composeModal(
                    model: item,
                    saver: saver,
                    deleter: deleter,
                    onCancel: { draft = nil },
                    onSaveCompleted: {
                        onSaveCompleted?()
                        onSaveCompleted = nil
                        draft = nil
                    },
                    onDeleteCompleted: {
                        draft = nil
                        dismiss()
                    }
                )
                .interactiveDismissDisabled()
            }
    }
}
