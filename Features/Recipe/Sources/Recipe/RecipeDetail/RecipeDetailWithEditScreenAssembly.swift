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
    @State var onEditCompleted: (() -> Void)? = nil
    
    public init(loader: any RecipeDetailLoader, saver: any RecipeSaver, deleter: any RecipeDeleter) {
        self.loader = loader
        self.saver = saver
        self.deleter = deleter
    }

    public var body: some View {
        RecipeDetailScreen(
                loader: loader,
                onEdit: { item, completion in
                    draft = item
                    onEditCompleted = completion
                }
            )
            .sheet(item: $draft) { item in
                RecipeEditModalScreen(
                    draft: item,
                    saver: saver,
                    deleter: deleter,
                    onCancel: { draft = nil },
                    onSaveCompleted: {
                        onEditCompleted?()
                        draft = nil
                        onEditCompleted = nil
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
