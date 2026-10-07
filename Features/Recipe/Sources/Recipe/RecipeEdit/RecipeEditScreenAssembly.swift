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
        saver: any RecipeSaver,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void
    ) -> RecipeEditScreenModal {
        return composeInternal(
            model: model,
            saver: saver,
            onCancel: onCancel,
            onSaveCompleted: onSaveCompleted
        ).0
    }

    @MainActor
    public static func composeNewRecipe(
        saver: any RecipeSaver,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void
    ) -> some View {
        composeModal(model: .empty, saver: saver, onCancel: onCancel, onSaveCompleted: onSaveCompleted)
    }

    @MainActor
    static func composeInternal(
        model: RecipeDraftModel,
        saver: any RecipeSaver,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void
    ) -> (RecipeEditScreenModal, AnyObject) {
        let viewModel = RecipeEditViewModel(model: model)
        viewModel.onCancelTapped = onCancel

        var savingTask: Task<Void, Never>?

        let scenario = FormSubmitScenario<RecipeDraftModel, Recipe>(
            getModel: { [weak viewModel] in
                viewModel?.model
            },
            validate: { draftModel in
                let recipe = await draftModel.toRecipe()
                let errors = RecipeFormValidator.validate(recipe)
                return errors.isEmpty ?
                    .success(recipe) :
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
                    updateModel(viewModel, with: state, onSuccess: onSaveCompleted)
                }
            }
        }

        return (RecipeEditScreenModal(viewModel: viewModel), viewModel)
    }
    
    @MainActor
    static func updateModel(_ model: RecipeEditViewModel?, with state: FormSubmitState, onSuccess: @escaping () -> Void) {
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
            onSuccess()
        case .savingFailed(let error):
            model.isSaving = false
            model.saveError = error
        case .idle:
            break
        }
    }
}

private extension RecipeEditViewModel {
    func resetErrors() {
        fieldErrors.removeAll()
        saveError = nil
    }
}
