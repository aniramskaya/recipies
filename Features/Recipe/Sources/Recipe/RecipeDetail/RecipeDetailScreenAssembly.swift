//
//  RecipeDetailScreenAssembly.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 21.07.2026.
//

import SwiftUI
import Scenarios
import RecipeUIKit
import RecipeTypes

enum RecipeDetailScreenAssembly {    
    @MainActor
    static func composeModel(
        loader: any RecipeDetailLoader,
        onEdit: @escaping (RecipeDraftModel, @escaping () -> Void) -> Void = { _, _ in }
    ) -> (RecipeDetailScreenModel, [AnyObject]) {
        let loadingScenario = BasicLoadingScenario(loader: loader.load)
        let model = RecipeDetailScreenModel()
        var recipe: Recipe?

        var loadingTask: Task<Void, Never>? = nil
        let load = { [weak model] in
            loadingTask?.cancel()
            loadingTask = Task { [weak model] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let model else { return }
                    setLoadingState(state, viewModel: model)
                    if case let .loaded(data) = state {
                        recipe = data
                    }
                }
            }
        }

        model.onAppear = load
        model.onDisappear = {
            loadingTask?.cancel()
        }
        model.onRetry = load
        model.onEdit = {
            guard let recipe else { return }
            onEdit(
                recipe.asDraftModel(),
                load
            )
        }

        return (model, [loadingScenario])
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
            imageSource: imageSource.map { .remote($0) } ?? .system("photo"),
            cookingTimeMins: cookingTimeMins,
            complexity: complexity,
            title: title,
            description: description,
            ingredients: IngredientListModel(
                items: ingredients.map { IngredientModel(id: $0.id, name: $0.name, isOn: false) }
            ),
            topText: topText.map { TextBlockViewModel(text: $0.text, title: $0.title) },
            steps: steps.map {
                RecipeStepViewModel(
                    id: $0.id,
                    title: $0.title ?? "",
                    imageSource: $0.imageSource.map { .remote($0) },
                    text: $0.text
                )
            },
            bottomText: bottomText.map { TextBlockViewModel(text: $0.text, title: $0.title) },
            onShare: {}
        )
    }
}
