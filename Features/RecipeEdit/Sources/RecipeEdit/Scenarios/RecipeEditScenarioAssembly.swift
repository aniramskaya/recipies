//
//  RecipeEditScenarioAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI

public enum RecipeEditScenarioAssembly {
    @MainActor
    static func composeInternal(
        recipeId: UUID,
        loader: any RecipeLoader,
        saver: any RecipeSaver = RecipeSaverStub()
    ) -> (RecipeEditScenarioScreen, [AnyObject]) {
        
        let editModel = RecipeEditModel()
        
        let loadingScenario = BasicLoadingScenario(loader: { try await loader.load() })
        let formScenario = RecipeFormSubmitScenario {
            await RecipeFormData.fromModel(id: recipeId, model: editModel)
        } save: { data in
            try await saver.save(data)
        }

        
        let viewModel = RecipeEditViewModel(
            load: { Task { await loadingScenario.start() }},
            save: { Task { await formScenario.start() }}
        )
        
        Task {
            let states = await loadingScenario.statesStream()
            for await state in states {
                print("loadingState \(state)")
                switch state {
                case .idle: viewModel.loadingState = .idle
                case .loading: viewModel.loadingState = .loading
                case let .failure(error): viewModel.loadingState = .failed(error)
                case let .success(data):
                    editModel.name = data.name
                    editModel.cookingTime = "\(data.cookingTime)"
                    editModel.complexity = data.complexity
                case .finished: viewModel.loadingState = .loaded(editModel)
                }
            }
        }
        
        Task {
            let states = await formScenario.statesStream()
            for await state in states {
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
        
        let screen = RecipeEditScenarioScreen(recipeEditViewModel: viewModel)
        return (screen, [editModel, loadingScenario, formScenario, viewModel])
    }

    @MainActor
    public static func compose(id: RecipeId) -> some View {
        let loader = RecipeLoaderStub()
        return composeInternal(recipeId: id.id, loader: loader).0
    }
}

extension RecipeFormData {
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

