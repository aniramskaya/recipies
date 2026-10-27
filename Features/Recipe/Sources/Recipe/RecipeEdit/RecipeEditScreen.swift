//
//  RecipeEditScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

struct RecipeEditScreen: View {
    let viewModel: RecipeEditViewModel
    let isModal: Bool

    var body: some View {
        NavigationStack {
            RecipeEditView(
                dataModel: viewModel.model,
                fieldErrors: viewModel.fieldErrors,
                isSaving: viewModel.isSaving,
                onDelete: viewModel.onDeleteTapped
            )
            .task {
                await viewModel.onAppearTask()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isModal {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отменить", action: viewModel.onCancelTapped)
                    }
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
