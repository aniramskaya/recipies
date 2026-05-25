//
//  RecipeEditViewAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.05.2026.
//

import SwiftUI

public enum RecipeEditViewAssembly {
    @MainActor
    static func composeInternal(
        recipeId: UUID,
        model: RecipeDataModel,
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> (RecipeEditView, [AnyObject]) {
        
        let dataModel = model
        
        let formScenario = RecipeFormSubmitScenario(
            getModel: {
                await RecipeFormData.fromModel(id: recipeId, model: dataModel)
            },
            save: { data in
                try await saver.save(data)
            }
        )
        
        let viewModel = RecipeEditViewModel()
        
        var formTask: Task<Void, Never>? = nil
        
        viewModel.onSave = { [weak viewModel] in
            guard formTask == nil else { return }
            formTask = Task { [weak viewModel] in
                
                let states = formScenario.start()
                for await state in states {
                    guard let viewModel else { return }
                    setFormState(state, viewModel: viewModel)
                    // TODO: Remove when SavingOverlay will be replaced with toast
                    if case .saved = state {
                        try? await Task.sleep(for: .seconds(0.5))
                        viewModel.savingState = .idle
                    }
                }
                formTask = nil
            }
        }
        
        viewModel.onClose = { [weak viewModel] in
            viewModel?.savingState = .idle
        }

        viewModel.onDisappear = {
            formTask?.cancel()
        }
        
        let view = RecipeEditView(dataModel: dataModel, viewModel: viewModel)
        return (view, [dataModel, formScenario, viewModel])
    }
    
    @MainActor
    private static func setFormState(_ state: FormSubmitState, viewModel: RecipeEditViewModel) {
        switch state {
        case .idle: viewModel.savingState = .idle
        case .validating, .saving: viewModel.savingState = .saving
        case let .validationFailed(error):
            viewModel.errors = .init(
                name: error.field?["name"]?.localizedDescription,
                cookingTime: error.field?["cookingTime"]?.localizedDescription,
                complexity: error.field?["complexity"]?.localizedDescription
            )
            viewModel.savingState = .idle
        case let .savingFailed(error): viewModel.savingState = .failed(error)
        case .saved:
            viewModel.savingState = .succeeded
        }
    }
}

private extension RecipeFormData {
    static func fromModel(id: UUID, model: RecipeDataModel) async -> RecipeFormData {
        async let name = model.name
        async let cookingTime = model.cookingTime
        async let complexity = model.complexity
        
        return .init(
            id: id,
            name: await name,
            cookingTime: await cookingTime,
            complexity: await complexity
        )
    }
}

