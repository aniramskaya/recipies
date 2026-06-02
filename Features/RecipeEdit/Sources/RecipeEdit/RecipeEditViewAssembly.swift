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
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> ((_: RecipeDataModel) -> RecipeEditView, [AnyObject]) {
        
        let viewModel = RecipeEditViewModel()
        let dataModelRef = Ref<RecipeDataModel>()
        
        var formTask: Task<Void, Never>? = nil
        
        let formScenario = FormSubmitScenario<RecipeFormRawData, RecipeData>(
            getModel: {
                guard let dataModel = dataModelRef.value else { return nil }
                return await RecipeFormRawData.fromModel(id: recipeId, model: dataModel)
            },
            validate: { data in
                return data.validateAndMapToData()
            },
            save: { data in
                try await saver.save(data)
            }
        )
        
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
        
        let view: (_: RecipeDataModel) -> RecipeEditView = { model in
            let dataModel = model
            dataModelRef.value = dataModel
            
            return RecipeEditView(dataModel: model, viewModel: viewModel)
        }
        return (view, [viewModel])
    }
    
    @MainActor
    private static func setFormState(_ state: FormSubmitState, viewModel: RecipeEditViewModel) {
        switch state {
        case .idle: viewModel.savingState = .idle
        case .validating: viewModel.savingState = .saving
        case .saving:
            viewModel.savingState = .saving
            viewModel.errors = .none
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

private final class Ref<T>: @unchecked Sendable {
    var value: T?
}
