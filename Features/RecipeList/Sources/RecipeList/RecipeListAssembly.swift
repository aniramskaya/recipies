//
//  RecipeListAssembly.swift
//  recipes
//
//  Created by Марина Чемезова on 15.01.2026.
//

import SwiftUI
import Foundation
import Scenarios

public enum RecipeListAssembly {
    @MainActor
    public static func composeWithAsyncServices(
        loader: RecipeListLoader,
        onSelectItem: @escaping @MainActor (_ id: UUID, _ isDraft: Bool) -> Void,
    ) -> (some View, () -> Void) {
        let (view, onReload, _) = composeInternalWithAsyncServices(
            loader: loader,
            onSelectItem: onSelectItem,
        )
        return (view, onReload)
    }

    @MainActor
    static func composeInternalWithAsyncServices(
        loader: RecipeListLoader,
        onSelectItem: @escaping @MainActor (_ id: UUID, _ isDraft: Bool) -> Void,
    ) -> (RecipeListScreen, () -> Void, [AnyObject]) {
        let viewModel = RecipeListScreenViewModel()

        let loadingScenario = BasicLoadingScenario(
            loader: { try await loader.load() }
        )
        
        var loadingTask: Task<Void, Never>? = nil
        
        let load = { [weak viewModel] in
            loadingTask?.cancel()
            loadingTask = Task { [weak viewModel] in
                let stream = loadingScenario.start()
                for await state in stream {
                    guard let viewModel else { return }
                    setViewModelState(viewModel: viewModel, state)
                }
            }
        }
        
        viewModel.onAppear = load
        viewModel.onRetry = load
        viewModel.onDisappear = { loadingTask?.cancel() }
        viewModel.onSelectItem = onSelectItem
        
        let screen = RecipeListScreen(viewModel: viewModel)
        return (screen, load, [viewModel, loadingScenario])
    }
    
    @MainActor
    private static func setViewModelState(
        viewModel: RecipeListScreenViewModel,
        _ state: BasicLoadingScenario<[RecipeListItem]>.State
    ) {
        switch state {
            case .loading: viewModel.state = .loading
            case let .failure(error): viewModel.state = .failed(error)
            case let .loaded(data): viewModel.state = .loaded(data.asViewModels())
        }
    }
}
