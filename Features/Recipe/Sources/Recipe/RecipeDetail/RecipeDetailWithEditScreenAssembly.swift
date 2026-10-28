//
//  RecipeDetailWithEditScreenAssembly.swift
//  Recipe
//
//  Created by Марина Чемезова on 11.09.2026.
//

import SwiftUI

// TODO: Вернуть обновление деталки рецепта после сохранения
public struct RecipeDetailWithEdit: View {
    let loader: any RecipeDetailLoader
    let saver: any RecipeSaver
    let deleter: any RecipeDeleter
    @Environment(\.dismiss) private var dismiss
    @State var draft: RecipeDraftModel? = nil
    
    public init(loader: any RecipeDetailLoader, saver: any RecipeSaver, deleter: any RecipeDeleter) {
        self.loader = loader
        self.saver = saver
        self.deleter = deleter
    }

    public var body: some View {
        RecipeDetailScreen(
                loader: loader,
                onEdit: { item, _ in
                    draft = item
                }
            )
            .sheet(item: $draft) { item in
                RecipeEditModalScreen(
                    draft: item,
                    saver: saver,
                    deleter: deleter,
                    onCancel: { draft = nil },
                    onSaveCompleted: {
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
