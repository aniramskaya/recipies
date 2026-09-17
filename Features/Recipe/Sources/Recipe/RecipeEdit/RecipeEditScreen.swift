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
    let viewModel: RecipeEditViewModel

    var body: some View {
        NavigationStack {
            RecipeEditView(
                dataModel: viewModel.model,
                fieldErrors: viewModel.fieldErrors,
                isSaving: viewModel.isSaving
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить", action: viewModel.onCancelTapped)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isSaving {
                        ProgressView()
                            .accessibilityIdentifier(RecipeEditA11y.savingIndicator)
                    } else {
                        Button("Сохранить", action: viewModel.onSubmitTapped)
                            .accessibilityIdentifier(RecipeEditA11y.saveButton)
                    }
                }
            }
        }
    }
}
