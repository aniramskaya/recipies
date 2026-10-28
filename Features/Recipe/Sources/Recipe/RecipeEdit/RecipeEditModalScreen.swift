//
//  RecipeEditModalScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 28.10.2026.
//

//
//  RecipeEditScreen.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI

struct RecipeEditModalScreen: View {
    @State private var viewModel: RecipeEditViewModel
    
    init(
        draft: RecipeDraftModel,
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void,
        onDeleteCompleted: @escaping () -> Void,
    ) {
        _viewModel = State(wrappedValue: RecipeEditScreenAssembly.composeViewModel(
            model: draft,
            saver: saver,
            deleter: deleter,
            onCancel: onCancel,
            onSaveCompleted: onSaveCompleted,
            onDeleteCompleted: onDeleteCompleted
        ))
    }


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
