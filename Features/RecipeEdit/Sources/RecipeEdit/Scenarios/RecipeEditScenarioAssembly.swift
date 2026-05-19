//
//  RecipeEditScenarioAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI

public enum RecipeEditScenarioAssembly {
    @MainActor
    public static func compose(id: RecipeId) -> some View {
        let loader = RecipeLoaderStub()
        return composeInternal(recipeId: id.id, loader: loader).0
    }

    @MainActor
    static func composeInternal(
        recipeId: UUID,
        loader: any RecipeLoader,
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> (RecipeEditScenarioScreen, [AnyObject]) {
        
        let editModel = RecipeEditModel()
        
        let loadingScenario = BasicLoadingScenario(loader: { try await loader.load() })
        let formScenario = RecipeFormSubmitScenario(
            getModel: {
                await RecipeFormData.fromModel(id: recipeId, model: editModel)
            },
            save: { data in
                try await saver.save(data)
            }
        )
        
        let viewModel = RecipeEditViewModel(
            load: { Task { await loadingScenario.start() }},
            save: { Task { await formScenario.start() }}
        )
        
        Task {
            let states = await loadingScenario.statesStream()
            for await state in states {
                setLoadingState(state, viewModel: viewModel, editModel: editModel)
            }
        }
        
        Task {
            let states = await formScenario.statesStream()
            for await state in states {
                setFormState(state, viewModel: viewModel)
            }
        }
        
        let screen = RecipeEditScenarioScreen(recipeEditViewModel: viewModel)
        return (screen, [editModel, loadingScenario, formScenario, viewModel])
    }

    @MainActor
    private static func setLoadingState(
        _ state: LoadingScenarioState<RecipeData>,
        viewModel: RecipeEditViewModel,
        editModel: RecipeEditModel
    ) {
        switch state {
        case .idle: viewModel.loadingState = .idle
        case .loading: viewModel.loadingState = .loading
        case let .failure(error): viewModel.loadingState = .failed(error)
        case let .success(data): editModel.populate(with: data)
        case .finished: viewModel.loadingState = .loaded(editModel)
        }
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
        case .saved: viewModel.savingState = .succeeded
        }
    }
}


private extension RecipeEditModel {
    func populate(with data: RecipeData) {
        self.name = data.name
        self.cookingTime = "\(data.cookingTime)"
        self.complexity = data.complexity
    }
}

private extension RecipeFormData {
    static func fromModel(id: UUID, model: RecipeEditModel) async -> RecipeFormData {
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

