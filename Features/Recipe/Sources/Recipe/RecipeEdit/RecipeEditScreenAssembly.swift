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

        var savingTask: Task<Void, Never>?

        let scenario = FormSubmitScenario<RecipeDraftModel, RecipeData>(
            getModel: { [weak viewModel] in
                viewModel?.model
            },
            validate: { draftModel in
                let errors = await RecipeFormValidator.validate(draftModel)
                return errors.isEmpty ?
                    await .success(draftModel.toRecipeData()) :
                    .failure(FormValidationError(form: nil, field: errors))
            },
            save: { try await saver.save($0) }
        )

        viewModel.onSubmitTapped = { [weak viewModel] in
            guard let viewModel, !viewModel.isSaving else { return }
            viewModel.resetErrors()
            savingTask?.cancel()
            savingTask = Task { [weak viewModel] in
                for await state in scenario.start() {
                    updateModel(viewModel, with: state)
                }
            }
        }

        return (RecipeEditScreenModal(viewModel: viewModel), viewModel)
    }
    
    @MainActor
    static func updateModel(_ model: RecipeEditViewModel?, with state: FormSubmitState) {
        guard let model else { return }
        switch state {
        case .validating:
            model.isSaving = true
        case .validationFailed(let error):
            model.isSaving = false
            model.fieldErrors = error.field ?? [:]
        case .saving:
            model.isSaving = true
        case .saved:
            model.isSaving = false
            model.onSaveCompleted()
        case .savingFailed(let error):
            model.isSaving = false
            model.saveError = error
        case .idle:
            break
        }
    }
}
