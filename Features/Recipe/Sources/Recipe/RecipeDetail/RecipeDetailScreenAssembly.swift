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
    static func compose(
        loader: any RecipeDetailLoader,
        onEdit: @escaping (RecipeDraftModel) -> Void = { _ in }
    ) -> some View {
        composeInternal(loader: loader, onEdit: onEdit).0
    }

    @MainActor
    static func composeInternal(
        loader: any RecipeDetailLoader,
        onEdit: @escaping (RecipeDraftModel) -> Void = { _ in }
    ) -> (RecipeDetailScreen, [AnyObject]) {
        let loadingScenario = BasicLoadingScenario(loader: loader.load)
        let model = RecipeDetailScreenModel()
        var recipe: Recipe?

        var loadingTask: Task<Void, Never>? = nil
        let load = { [weak model] in
            if case .loaded = model?.loadingState { return }
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
        model.onDisappear = { loadingTask?.cancel() }
        model.onRetry = load
        model.onEdit = {
            guard let recipe else { return }
            onEdit(recipe.asDraftModel())
        }

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
    @MainActor
    func asDraftModel() -> RecipeDraftModel {
        RecipeDraftModel(
            id: id,
            title: title,
            description: description ?? "",
            ingredients: ingredients.map { IngredientDraftModel(id: UUID(), name: $0.name) },
            // TODO: разобраться тут с опциональностью. Возможно убрать опционалы из TextBlock
            topTextBlock: topText != nil ? .init(title: topText?.title ?? "", text: topText?.text ?? "") : nil,
            steps: steps.map { RecipeStepDraftModel(id: $0.id, title: $0.title, imageSource: $0.imageSource, text: $0.text) },
            bottomTextBlock: bottomText != nil ? .init(title: bottomText?.title ?? "", text: bottomText?.text ?? "") : nil,
        )
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
            topText: topText.map { TextBlockViewModel(text: $0.text, title: $0.title) },
            steps: steps.map {
                RecipeStepViewModel(
                    id: $0.id,
                    title: $0.title,
                    imageSource: $0.imageSource.map { .remote($0) },
                    text: $0.text
                )
            },
            bottomText: bottomText.map { TextBlockViewModel(text: $0.text, title: $0.title) },
            onShare: {}
        )
    }
}
