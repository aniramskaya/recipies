//
//  RecipeEditViewAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.05.2026.
//

import SwiftUI
import Scenarios

public enum RecipeEditViewAssembly {
    @MainActor
    static func composeInternal(
        recipeId: UUID,
        model: RecipeDataModel,
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> (RecipeEditView, [AnyObject]) {
        
        let dataModel = model
        
        let formScenario = FormSubmitScenario(
            getModel: {
                await RecipeFormRawData.fromModel(id: recipeId, model: dataModel)
            },
            validate: { data in
                return data.validateAndMapToData()
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
                name: error.field?["name"],
                cookingTime: error.field?["cookingTime"],
                complexity: error.field?["complexity"]
            )
            viewModel.savingState = .idle
        case let .savingFailed(error): viewModel.savingState = .failed(error)
        case .saved:
            viewModel.savingState = .succeeded
        }
    }
}

private extension RecipeFormRawData {
    static func fromModel(id: UUID, model: RecipeDataModel) async -> RecipeFormRawData {
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
