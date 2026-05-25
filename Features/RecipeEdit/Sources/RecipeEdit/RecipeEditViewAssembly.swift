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

extension RecipeFormData {
    func validateAndMapToData() -> Result<RecipeData, FormValidationError> {
        let name = self.name.flatMap { $0.isEmpty ? nil : $0 }
        let cookingTime = self.cookingTime.flatMap { $0.isEmpty ? nil : $0 }
        let cookingTimeInt = cookingTime
            .flatMap { Int($0) }
            .flatMap { $0 > 0 ? $0 : nil }

        var errors: Dictionary<String, LocalizedError> = [:]
        errors["name"] = name == nil ? RecipeFormValidationError.required : nil
        if cookingTime == nil {
            errors["cookingTime"] = RecipeFormValidationError.required
        } else if cookingTimeInt == nil {
            errors["cookingTime"] = RecipeFormValidationError.numberInvalid
        }

        guard let name, let cookingTimeInt else {
            return .failure(.init(form: nil, field: errors))
        }

        return .success(RecipeData(
            id: self.id,
            name: name,
            cookingTime: cookingTimeInt,
            complexity: self.complexity ?? 1
        ))
    }
}
