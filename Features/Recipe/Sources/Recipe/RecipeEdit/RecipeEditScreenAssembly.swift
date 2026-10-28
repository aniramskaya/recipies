//
//  RecipeEditScreenAssembly.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI
import Scenarios
import RecipeTypes

public enum RecipeEditScreenAssembly {

    @MainActor
    static func composeDraftEditModel(
        model: RecipeDraftModel,
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void,
        onDeleteCompleted: @escaping () -> Void
    ) -> RecipeEditViewModel {

        let viewModel = composeViewModel(
            model: model,
            saver: saver,
            deleter: deleter,
            onCancel: onCancel,
            onSaveCompleted: onSaveCompleted,
            onDeleteCompleted: onDeleteCompleted
        )
        
        viewModel.onAppearTask = { [weak viewModel] in
            guard let viewModel else { return }
            await startAutoSave(viewModel: viewModel, saver: saver)
        }
        
        return viewModel
    }
    
    @MainActor
    private static func startAutoSave(viewModel: RecipeEditViewModel, saver: any RecipeSaver) async {
        while !Task.isCancelled {
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                withObservationTracking {
                    _ = viewModel.model.title
                    _ = viewModel.model.description
                    _ = viewModel.model.ingredients
                    _ = viewModel.model.cookingTimeMins
                    _ = viewModel.model.complexity
                    _ = viewModel.model.imageSource
                    _ = viewModel.model.topTextBlock
                    _ = viewModel.model.steps
                    _ = viewModel.model.bottomTextBlock
                } onChange: {
                    continuation.resume()
                }
            }
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled, !viewModel.isSaving else { continue }
            if viewModel.model.title.trimmingCharacters(in: .whitespaces).isEmpty {
                viewModel.model.title = RecipeDraftModel.defaultTitle()
            }
            try? await saver.save(viewModel.model.toRecipe(isDraft: true))
        }
    }
    
    @MainActor
    static func composeViewModel(
        model: RecipeDraftModel,
        saver: any RecipeSaver,
        deleter: any RecipeDeleter,
        onCancel: @escaping () -> Void,
        onSaveCompleted: @escaping () -> Void,
        onDeleteCompleted: @escaping () -> Void
    ) -> RecipeEditViewModel {
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
        
        viewModel.onDeleteTapped = {
            Task {
                try await deleter.delete(id: model.id)
                guard !Task.isCancelled else { return }
                onDeleteCompleted()
            }
        }
        
        return viewModel
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
