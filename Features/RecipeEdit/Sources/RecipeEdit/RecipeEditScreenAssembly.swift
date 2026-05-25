//
//  RecipeEditAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI

public enum RecipeEditScreenAssembly {
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
    ) -> (RecipeEditScreen<RecipeEditView>, [AnyObject]) {
        
        let editModel = RecipeDataModel()
        
        let (editView, editLeakables) = RecipeEditViewAssembly.composeInternal(recipeId: recipeId, model: editModel, saver: saver)
        
        let loadingScenario = BasicLoadingScenario(loader: { try await loader.load() })
        
        let model = RecipeEditScreenModel()
        
        var loadingTask: Task<Void, Never>? = nil
        model.load = { [weak model, weak editModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak model, weak editModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let model, let editModel else { return }
                    setLoadingState(state, viewModel: model, editModel: editModel)
                }
            }
        }
        
        model.onDisappear = {
            loadingTask?.cancel()
        }
        
        let screen = RecipeEditScreen(model: model) {
                editView
        }
        
        return (screen, [editModel, loadingScenario, model] + editLeakables)
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
            viewModel.loadingState = .loaded(Void())
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

