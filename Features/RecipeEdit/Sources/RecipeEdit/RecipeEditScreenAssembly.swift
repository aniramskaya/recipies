//
//  RecipeEditAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import SwiftUI
import Scenarios

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
        
        let (editView, editLeakables) = RecipeEditViewAssembly.composeInternal(recipeId: recipeId, saver: saver)
        
        let loadingScenario = BasicLoadingScenario(loader: { try await loader.load() })

        let model = RecipeEditScreenModel()

        var loadingTask: Task<Void, Never>? = nil
        let load = { [weak model] in
            if case .loaded = model?.loadingState { return }
            loadingTask?.cancel()
            loadingTask = Task { [weak model] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let model else { return }
                    setLoadingState(state, viewModel: model)
                }
            }
        }
                
        model.onAppear = load
        
        model.onDisappear = {
            print("Cancelling loading task")
            loadingTask?.cancel()
        }
        
        model.onRetry = load
        
        let screen = RecipeEditScreen(model: model) { dataModel in
            editView(dataModel)
        }
        
        return (screen, [loadingScenario, model] + editLeakables)
    }

    @MainActor
    private static func setLoadingState(
        _ state: LoadingScenarioState<RecipeData>,
        viewModel: RecipeEditScreenModel,
    ) {
        switch state {
        case .loading: viewModel.loadingState = .loading
        case let .failure(error): viewModel.loadingState = .failed(error)
        case let .loaded(data):
            let editModel = RecipeDataModel()
            editModel.populate(with: data)
            viewModel.loadingState = .loaded(editModel)
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

