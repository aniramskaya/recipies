//
//  RecipeEditAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI

public enum RecipeEditAssembly {
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
    ) -> (RecipeEditScreen, [AnyObject]) {
        
        let editModel = RecipeDataModel()
        
        let loadingScenario = BasicLoadingScenario(loader: { try await loader.load() })
        let formScenario = RecipeFormSubmitScenario(
            getModel: {
                await RecipeFormData.fromModel(id: recipeId, model: editModel)
            },
            save: { data in
                try await saver.save(data)
            }
        )
        
        let screenModel = RecipeEditScreenModel()
        
        var loadingTask: Task<Void, Never>? = nil
        screenModel.load = { [weak screenModel, weak editModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak screenModel, weak editModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let screenModel, let editModel else { return }
                    setLoadingState(state, viewModel: screenModel, editModel: editModel)
                }
            }
        }
        
        let editViewModel = RecipeEditViewModel()
        
        var formTask: Task<Void, Never>? = nil
        editViewModel.onSave = { [weak editViewModel] in
            guard formTask == nil else { return }
            formTask = Task { [weak editViewModel] in
                let states = formScenario.start()
                for await state in states {
                    guard let editViewModel else { return }
                    setFormState(state, viewModel: editViewModel)
                    // TODO: Remove when SavingOverlay will be replaced with toast
                    if case .saved = state {
                        try? await Task.sleep(for: .seconds(0.5))
                        editViewModel.savingState = .idle
                    }
                }
            }
        }
        
        editViewModel.onClose = { [weak screenModel] in
            screenModel?.loadingState = .idle
        }
        
        screenModel.onDisappear = {
            loadingTask?.cancel()
            formTask?.cancel()
        }
        
        let screen = RecipeEditScreen(
            recipeEditScreenModel: screenModel,
            recipeEditDataModel: editModel,
            recipeEditViewModel: editViewModel
        )
        return (screen, [editModel, loadingScenario, formScenario, screenModel])
    }

    @MainActor
    private static func setLoadingState(
        _ state: LoadingScenarioState<RecipeData>,
        viewModel: RecipeEditScreenModel,
        editModel: RecipeDataModel
    ) {
        switch state {
        case .loading: viewModel.loadingState = .loading
        case let .failure(error): viewModel.loadingState = .failed(error)
        case let .loaded(data):
            editModel.populate(with: data)
            viewModel.loadingState = .loaded(editModel)
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
        case .saved:
            viewModel.savingState = .succeeded
        }
    }
}


private extension RecipeDataModel {
    func populate(with data: RecipeData) {
        self.name = data.name
        self.cookingTime = "\(data.cookingTime)"
        self.complexity = data.complexity
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

