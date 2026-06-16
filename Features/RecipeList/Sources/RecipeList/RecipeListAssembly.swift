//
//  RecipeListAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 15.01.2026.
//

import Foundation
import Scenarios

public enum RecipeListAssembly {
    @MainActor
    public static func composeWithAsyncServices(
        onSelectItem: @escaping @MainActor (_: UUID) -> Void
    ) -> RecipeListScreen {
        return composeInternalWithAsyncServices(
            dtoLoader: AsyncRecipeListDTOLoaderStub(),
            cacheExpirationPolicy: RecipeListExpirationPolicy(timeout: (300)),
            onSelectItem: onSelectItem
        ).0
    }
    
    @MainActor
    static func composeInternalWithAsyncServices(
        dtoLoader: AsyncRecipeListDTOLoader,
        cacheExpirationPolicy: TimestampExpirationPolicy,
        onSelectItem: @escaping @MainActor (_: UUID) -> Void
    ) -> (RecipeListScreen, [AnyObject]) {
        let (recipeListLoader, leakable) = AsyncRecipeListLoaderAssembly.composeInternal(
            dtoLoader: dtoLoader,
            cacheExpirationPolicy: cacheExpirationPolicy
        )
        let viewModel = RecipeListScreenViewModel()
        
        let loadingScenario = BasicLoadingScenario(loader: recipeListLoader.load)
        
        var loadingTask: Task<Void, Never>? = nil
        
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    switch state {
                    case .loading:
                        viewModel.state = .loading
                    case let .failure(error):
                        viewModel.state = .failed(error)
                    case let .loaded(data):
                        viewModel.state = .loaded(data.asViewModels())
                    }
                }
            }
            
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onDisappear = { loadingTask?.cancel() }
        viewModel.onSelectItem = onSelectItem
        
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, leakable + [viewModel])
    }
}
