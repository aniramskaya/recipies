//
//  RecipeEditScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

struct RecipeEditScreen: View {
    private(set) var model: RecipeDraftModel

    var body: some View {
        RecipeEditView(dataModel: model)
    }
}

struct RecipeEditScreenModal: View {
    private(set) var model: RecipeDraftModel
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            RecipeEditView(dataModel: model)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отменить", action: onCancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Сохранить", action: onSave)
                    }
                }
        }
    }
}
