//
//  RecipeEditScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

struct RecipeEditScreen: View {
    @State private var viewModel: RecipeEditViewModel
    
    init(
        draft: RecipeDraftModel,
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void,
        onDeleteCompleted: @escaping () -> Void
    ) {
        _viewModel = State(wrappedValue: RecipeEditScreenAssembly.composeDraftEditModel(
            model: draft,
            saver: saver,
            deleter: deleter,
            onCancel: onCancel,
            onSaveCompleted: onSaveCompleted,
            onDeleteCompleted: onDeleteCompleted
        ))
    }
    
    init(viewModel: RecipeEditViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }


    var body: some View {
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
            ToolbarItem(placement: .confirmationAction) {
                if viewModel.isSaving {
                    ProgressView()
                        .accessibilityIdentifier(RecipeEditA11y.savingIndicator)
                } else {
                    Button("recipeEdit.done", action: viewModel.onSubmitTapped)
                        .accessibilityIdentifier(RecipeEditA11y.saveButton)
                }
            }
        }
    }
}
