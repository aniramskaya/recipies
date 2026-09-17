//
//  RecipeEditScreenAssembly.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI
import Scenarios

public enum RecipeEditScreenAssembly {
    @MainActor
    static func compose(model: RecipeDraftModel) -> some View {
        RecipeEditScreen(model: model)
    }

    @MainActor
    static func composeModal(
        model: RecipeDraftModel,
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) -> RecipeEditScreenModal {
        let viewModel = RecipeEditViewModel(model: model)
        viewModel.onCancelTapped = onCancel
        viewModel.onSaveCompleted = onSave
        viewModel.onSubmitTapped = { [weak viewModel] in
            viewModel?.onSaveCompleted()
        }
        return RecipeEditScreenModal(viewModel: viewModel)
    }

    @MainActor
    public static func composeNewRecipe(
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) -> some View {
        composeModal(model: .empty, onCancel: onCancel, onSave: onSave)
    }

    @MainActor
    static func composeInternal(
        model: RecipeDraftModel,
        saver: any RecipeSaver
    ) -> (RecipeEditScreenModal, AnyObject) {
        let viewModel = RecipeEditViewModel(model: model)

        final class TaskHolder {
            var task: Task<Void, Never>?
        }
        let taskHolder = TaskHolder()

        let scenario = FormSubmitScenario<RecipeDraftModel, RecipeData>(
            getModel: { [weak viewModel] in
                await MainActor.run { viewModel?.model }
            },
            validate: { draftModel in
                await MainActor.run { () -> Result<RecipeData, FormValidationError> in
                    let errors = RecipeFormValidator().validate(draftModel)
                    guard errors.isEmpty else {
                        let fieldErrors = Dictionary(
                            uniqueKeysWithValues: errors.map { ($0.fieldKey, "") }
                        )
                        return .failure(FormValidationError(form: nil, field: fieldErrors))
                    }
                    return .success(draftModel.toRecipeData())
                }
            },
            save: { try await saver.save($0) }
        )

        viewModel.onSubmitTapped = { [weak viewModel] in
            guard let viewModel, !viewModel.isSaving else { return }
            viewModel.fieldErrors = []
            taskHolder.task?.cancel()
            taskHolder.task = Task { [weak viewModel] in
                for await state in scenario.start() {
                    guard let viewModel else { return }
                    switch state {
                    case .validating:
                        viewModel.isSaving = true
                    case .validationFailed(let error):
                        viewModel.isSaving = false
                        viewModel.fieldErrors = RecipeFormValidationError.errors(from: error.field ?? [:])
                    case .saving:
                        viewModel.isSaving = true
                    case .saved:
                        viewModel.isSaving = false
                        viewModel.onSaveCompleted()
                    case .savingFailed(let error):
                        viewModel.isSaving = false
                        viewModel.saveError = error
                    case .idle:
                        break
                    }
                }
            }
        }

        return (RecipeEditScreenModal(viewModel: viewModel), viewModel)
    }
}
