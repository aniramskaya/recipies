//
//  RecipeDetailScreenAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import SwiftUI
import Scenarios
import RecipeUIKit

public enum RecipeDetailScreenAssembly {
    @MainActor
    public static func compose(loader: any RecipeDetailLoader) -> some View {
        composeInternal(loader: loader).0
    }

    @MainActor
    static func composeInternal(
        loader: any RecipeDetailLoader
    ) -> (RecipeDetailScreen, [AnyObject]) {
        let loadingScenario = BasicLoadingScenario(loader: loader.load)
        let model = RecipeDetailScreenModel()

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
        model.onDisappear = { loadingTask?.cancel() }
        model.onRetry = load

        let screen = RecipeDetailScreen(model: model)
        return (screen, [loadingScenario, model])
    }

    @MainActor
    private static func setLoadingState(
        _ state: BasicLoadingScenario<Recipe>.State,
        viewModel: RecipeDetailScreenModel
    ) {
        switch state {
        case .loading:
            viewModel.loadingState = .loading
        case let .failure(error):
            viewModel.loadingState = .failed(error)
        case let .loaded(recipe):
            viewModel.loadingState = .loaded(recipe.asDetailViewModel())
        }
    }
}

private extension Recipe {
    func asDetailViewModel() -> RecipeDetailViewModel {
        RecipeDetailViewModel(
            imageSource: .remote(imageSource),
            cookingTimeMins: cookingTimeMins,
            complexity: complexity,
            title: title,
            description: description,
            ingredients: IngredientListModel(
                items: ingredients.map { IngredientModel(isOn: $0.isOn, name: $0.name) }
            ),
            topText: topText.map { TextBlockViewModel(id: $0.id, text: $0.text, title: $0.title) },
            steps: steps.map {
                RecipeStepViewModel(
                    id: $0.id,
                    title: $0.title,
                    imageSource: $0.imageSource.map { .remote($0) },
                    text: $0.text
                )
            },
            bottomText: bottomText.map { TextBlockViewModel(id: $0.id, text: $0.text, title: $0.title) },
            onShare: {}
        )
    }
}
