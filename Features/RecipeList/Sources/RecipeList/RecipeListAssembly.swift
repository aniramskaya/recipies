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
            loader: AsyncRecipeListLoaderStub(),
            onSelectItem: onSelectItem
        ).0
    }

    @MainActor
    static func composeInternalWithAsyncServices(
        loader: RecipeListLoader,
        onSelectItem: @escaping @MainActor (_: UUID) -> Void
    ) -> (RecipeListScreen, [AnyObject]) {
        let viewModel = RecipeListScreenViewModel()

        let storage = InMemoryCacheStorage<String, [RecipeListItem]>()
        let cache = TTLCache(storage: storage, expirationPolicy: TimeoutTTLPolicy(timeout: 300))
        let loadingScenario = CachingLoadingScenario(
            cache: cache.scoped(to: "RecipeList"),
            loader: { try await loader.load() }
        )
        
        var loadingTask: Task<Void, Never>? = nil
        
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.load()
                for await state in stream {
                    guard let viewModel else { return }
                    setViewModelState(viewModel: viewModel, state)
                }
            }
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onReload = { [weak viewModel] in
            let stream = loadingScenario.reload()
            for await state in stream {
                guard let viewModel else { return }
                setViewModelState(viewModel: viewModel, state)
            }
        }
        viewModel.onDisappear = { loadingTask?.cancel() }
        viewModel.onSelectItem = onSelectItem
        
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, [viewModel, storage, cache, loadingScenario])
    }
    
    @MainActor
    private static func setViewModelState(
        viewModel: RecipeListScreenViewModel,
        _ state: CachingLoadingScenario<[RecipeListItem]>.State
    ) {
        if let data = state.data {
            viewModel.state = .loaded(data.asViewModels())
            return
        }
        if state.isLoading {
            viewModel.state = .loading
            return
        }
        if let error = state.error {
            viewModel.state = .failed(error)
        }
    }
}
